-- Alt + 配置键用来切应用。单独快速点两次左或右 Option，则启用或停用这些快捷键。
local QuicklySwitchApp = {}
QuicklySwitchApp.__index = QuicklySwitchApp

-- 左右 Option 的 keyCode 不同，但它们共用同一套双击状态。
local TOGGLE_OPTION_KEY_CODES = {
  [hs.keycodes.map.alt] = true,
  [hs.keycodes.map.rightalt] = true
}

local function buildFlagLookup(keys)
  -- getFlags() 返回 `{ alt = true }` 这种表。配置先转成同样的结构，后面就不用反复遍历数组。
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

  -- bindings 是应用快捷键，几个 toggle 字段只服务于 Option 双击。
  -- 它们都放在实例上，start() 和 stop() 才能一起清理。
  local instance = {
    bindings = {},
    isEnabled = true,
    alertId = nil,
    -- 只有一次完整的 Option 点击结束后才会写入。nil 表示没有等待第二击。
    pendingToggleTapAtSeconds = nil,
    -- Option 按下后先设为 true。期间出现普通键或其它修饰键，这次点击就作废。
    isToggleTapCandidate = false,
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
  -- 双击只认单独按下的 hyperKey，cmd、shift 等修饰键混进来都不算。
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

function QuicklySwitchApp:cancelToggleTapSequence()
  self.pendingToggleTapAtSeconds = nil
  self.isToggleTapCandidate = false
end

function QuicklySwitchApp:rememberToggleTap(tapAtSeconds)
  self.pendingToggleTapAtSeconds = tapAtSeconds
end

function QuicklySwitchApp:isToggleTapWithinInterval(tapAtSeconds)
  if not self.pendingToggleTapAtSeconds then
    return false
  end

  local elapsedSeconds = tapAtSeconds - self.pendingToggleTapAtSeconds
  -- 这里故意不用 absoluteTime()。它在系统睡眠时会暂停，可能把睡前和唤醒后的点击拼成双击。
  -- 系统时钟回拨时 elapsedSeconds 会是负数。这种情况直接按超时处理，避免误触发。
  return elapsedSeconds >= 0 and elapsedSeconds <= self.config.toggleIntervalSeconds
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
  -- 普通键按下后，Option 就是在参与组合键。清掉首击，避免 Alt + key 被后面的单击接成双击。
  self:cancelToggleTapSequence()
end

function QuicklySwitchApp:handleToggleFlagsChanged(event)
  -- 修饰键没有单独的 keyDown 和 keyUp，按下与松开都会进 flagsChanged。

  if not self:isToggleOptionEvent(event) then
    -- 一旦出现别的修饰键事件，本轮双击判断直接作废，避免跨按键串台。
    self:cancelToggleTapSequence()
    return
  end

  local flags = event:getFlags()
  if self:hasOnlyHyperKeyFlags(flags) then
    -- Option 还在 flags 里，说明当前是按下状态。先做标记，真正的一击要等松开时才算。
    self.isToggleTapCandidate = true
    return
  end

  -- 候选按下结束后才会用到这个时间。即使系统重复送来 Option-down，也不会多记一击。
  local tapAtSeconds = hs.timer.secondsSinceEpoch()
  if not self.isToggleTapCandidate then
    -- 松开前出现过普通键或其它修饰键，本轮不算独立 Option tap。
    self:cancelToggleTapSequence()
    return
  end

  self.isToggleTapCandidate = false
  if not self.pendingToggleTapAtSeconds then
    -- 第一次纯 Option 点击只记录时间，等待下一次点击来决定是否真的切换。
    self:rememberToggleTap(tapAtSeconds)
    return
  end

  if not self:isToggleTapWithinInterval(tapAtSeconds) then
    -- 超过双击窗口：上一击失效，把本次松开作为新一轮首击。
    self:rememberToggleTap(tapAtSeconds)
    return
  end

  -- 两次有效点击都落在时间窗内，才切换整套绑定的启用状态。
  self:toggleBindings()
  self:cancelToggleTapSequence()
end

function QuicklySwitchApp:start()
  -- start() 可能被手动重复调用。先收掉旧监听器和 binding，避免同一按键触发多次。
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
      -- 普通键按下时取消双击，修饰键的按下和松开都交给 flagsChanged。
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
  self:cancelToggleTapSequence()
end

return QuicklySwitchApp
