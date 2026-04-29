local QuicklySwitchApp = {}
QuicklySwitchApp.__index = QuicklySwitchApp

local TOGGLE_OPTION_KEY_CODES = {
  [hs.keycodes.map.alt] = true,
  [hs.keycodes.map.rightalt] = true
}

local NANOSECONDS_PER_SECOND = 1e9

local function buildFlagLookup(keys)
  -- Hammerspoon 的 flags 是 `{ alt = true }` 这类表，先把配置转成同结构，后面判断更直接。
  local flags = {}
  for _, key in ipairs(keys) do
    flags[key] = true
  end
  return flags
end

function QuicklySwitchApp:new(config)
  config = config or {}
  local hyperKey = config.hyperKey or {}
  local toggleIntervalSeconds = config.toggleIntervalSeconds or 0.2

  -- 每个实例维护两类状态：
  -- 1. alt + key 的应用切换绑定
  -- 2. 单独双击 Option 时的开关检测状态
  local instance = {
    bindings = {},
    isEnabled = true,
    alertId = nil,
    -- 记录上一次“可参与双击判断”的 Option 点击时间；nil 表示当前没有待结算点击。
    pendingToggleTapAtNs = nil,
    toggleEventListener = nil,
    config = {
      hyperKey = hyperKey,
      hyperKeyFlags = buildFlagLookup(hyperKey),
      hotKeyToAppDict = config.hotKeyToAppDict or {},
      toggleIntervalSeconds = toggleIntervalSeconds
    }
  }

  -- 调试用 logger，不要删
  -- instance.logger = hs.logger.new('quickly-switch-app', 'info')

  setmetatable(instance, self)
  return instance
end

function QuicklySwitchApp:switchApp(targetBundleId)
  local app = hs.application.frontmostApplication()
  if app and app:bundleID() == targetBundleId then
    app:hide()
    return
  end

  hs.application.launchOrFocusByBundleID(targetBundleId)
end

function QuicklySwitchApp:hasOnlyHyperKeyFlags(flags)
  -- 只有在“所有 hyperKey 都按下，且没有其它修饰键”时才算成立。
  for key in pairs(self.config.hyperKeyFlags) do
    if not flags[key] then
      return false
    end
  end

  for key, isPressed in pairs(flags) do
    if isPressed and not self.config.hyperKeyFlags[key] then
      return false
    end
  end

  return true
end

function QuicklySwitchApp:isToggleOptionEvent(event)
  local keyCode = event:getKeyCode()
  return TOGGLE_OPTION_KEY_CODES[keyCode] == true
end

function QuicklySwitchApp:clearPendingToggleTap()
  self.pendingToggleTapAtNs = nil
end

function QuicklySwitchApp:rememberToggleTap(tapAtNs)
  self.pendingToggleTapAtNs = tapAtNs
end

function QuicklySwitchApp:isToggleTapWithinInterval(tapAtNs)
  if not self.pendingToggleTapAtNs then
    return false
  end

  -- `absoluteTime()` 返回纳秒时间戳，这里统一换算后再比较，避免把时间窗单位散落在调用点。
  local toggleIntervalNs = self.config.toggleIntervalSeconds * NANOSECONDS_PER_SECOND
  return (tapAtNs - self.pendingToggleTapAtNs) <= toggleIntervalNs
end

function QuicklySwitchApp:setBindingsEnabled(enabled)
  self.isEnabled = enabled

  for _, binding in ipairs(self.bindings) do
    if enabled then
      binding:enable()
    else
      binding:disable()
    end
  end
end

function QuicklySwitchApp:closeAlert()
  if not self.alertId then
    return
  end

  -- 先关闭旧提示，再创建新提示，避免快速切换时屏幕上叠多个 alert。
  hs.alert.closeSpecific(self.alertId)
  self.alertId = nil
end

function QuicklySwitchApp:toggleBindings()
  local nextEnabledState = not self.isEnabled
  self:setBindingsEnabled(nextEnabledState)

  self:closeAlert()
  self.alertId = hs.alert.show(
    string.format(
      'Quickly Switch App is %s',
      nextEnabledState and 'enabled' or 'disabled'
    )
  )
end

function QuicklySwitchApp:handleToggleKeyDown()
  -- `keyDown` 只负责让候选失效：Option 一旦参与组合键，这次按压就不再算独立点击。
  self:clearPendingToggleTap()
end

function QuicklySwitchApp:handleToggleFlagsChanged(event)
  -- `flagsChanged` 负责整个 Option 点击生命周期：记录按下，结算松开。

  if not self:isToggleOptionEvent(event) then
    -- 一旦出现别的修饰键事件，本轮双击判断直接作废，避免跨按键串台。
    self:clearPendingToggleTap()
    return
  end

  local flags = event:getFlags()
  local hasOnlyHyperKeyFlags = self:hasOnlyHyperKeyFlags(flags)
  if not hasOnlyHyperKeyFlags then
    -- 松开 Option 键，直接作废本轮双击判断
    return
  end

  local tapAtNs = hs.timer.absoluteTime()
  if not self.pendingToggleTapAtNs then
    -- 第一次纯 Option 点击只记录时间，等待下一次点击来决定是否真的切换。
    self:rememberToggleTap(tapAtNs)
    return
  end

  if not self:isToggleTapWithinInterval(tapAtNs) then
    -- 松开 Option 键，但时间窗已过，直接作废本轮双击判断
    self:rememberToggleTap(tapAtNs)
    return
  end

  -- 两次有效点击都落在时间窗内，才切换整套绑定的启用状态。
  self:toggleBindings()
  self:clearPendingToggleTap()
end

function QuicklySwitchApp:start()
  -- 允许重复调用 `start()`：先清理旧 binding 和旧监听器，再按当前配置重建。
  self:stop()

  for key, bundleId in pairs(self.config.hotKeyToAppDict) do
    local binding = hs.hotkey.bind(self.config.hyperKey, key, function()
      self:switchApp(bundleId)
    end)

    if not self.isEnabled then
      binding:disable()
    end

    table.insert(self.bindings, binding)
  end

  self.toggleEventListener = hs.eventtap.new(
    { hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown },
    function(event)
      -- `flagsChanged` 负责追踪独立 Option 点击；`keyDown` 只负责在组合键出现时让候选失效。
      if event:getType() == hs.eventtap.event.types.keyDown then
        self:handleToggleKeyDown()
      else
        self:handleToggleFlagsChanged(event)
      end
      return false
    end
  )
  self.toggleEventListener:start()
end

function QuicklySwitchApp:stop()
  if self.toggleEventListener then
    self.toggleEventListener:stop()
    self.toggleEventListener = nil
  end

  for _, binding in ipairs(self.bindings) do
    binding:delete()
  end
  self.bindings = {}

  self:closeAlert()
  self:clearPendingToggleTap()
end

return QuicklySwitchApp
