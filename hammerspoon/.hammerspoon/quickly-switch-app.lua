-------------
--   API   --
-------------
local hyperKey = { 'alt' }
local hotKeyToAppDict = {
  ['Q'] = 'com.google.Chrome',
  ['W'] = 'com.googlecode.iterm2',
  ['E'] = 'com.microsoft.VSCode',
  ['R'] = 'com.apple.iCal',
  ['T'] = 'com.apple.Safari',
  ['I'] = 'com.apple.ScreenContinuity',
  ['P'] = 'com.proxyman.NSProxy',

  ['A'] = 'com.culturedcode.ThingsMac',
  ['S'] = 'com.DanPristupov.Fork',
  ['D'] = 'com.binarynights.ForkLift',
  ['G'] = 'com.kapeli.dashdoc',
  ['J'] = 'net.shinystone.OKJSON',
  ['K'] = 'com.vladbadea.csveditor',

  ['Z'] = 'com.youzan.zanproxy',
  ['X'] = 'com.electron.lark',
  ['C'] = 'md.obsidian',
  ['V'] = 'com.tencent.xinWeChat',
  ['N'] = 'com.apple.Notes',
  ['M'] = 'com.ideasoncanvas.mindnode.macos',

  ['`'] = 'com.apple.Stickies'
}

local logger = hs.logger.new('quickly-switch-app', 'info')

local bindings = {}
local isEnabled = true

local function switchApp(targetBundleId)
  local app = hs.application.frontmostApplication()
  if app:bundleID() == targetBundleId then
    app:hide()
  else
    hs.application.launchOrFocusByBundleID(targetBundleId)
  end
end

local alertId
local lastPressedAltTime
local interval = 250000000 -- 使用 0.25 秒间隔 (250ms)，单位为纳秒 (1000000000 纳秒 = 1 秒)

local function toggleEventHandler(event)
  local flags = event:getFlags()

  if not flags:containExactly(hyperKey) then
    return
  end

  local currentTime = hs.timer.absoluteTime()


  -- 如果是第一次按下或者两次按键的时间间隔大于设定的 interval，则重置时间
  if lastPressedAltTime and (currentTime - lastPressedAltTime <= interval) then
    isEnabled = not isEnabled

    for _, hkObj in ipairs(bindings) do
      if isEnabled then
        hkObj:enable()
      else
        hkObj:disable()
      end
    end

    local msg = isEnabled and 'enabled' or 'disabled'

    if alertId then
      hs.alert.closeSpecific(alertId)
    end

    alertId = hs.alert.show(string.format('Quickly Switch App is %s', msg))
  end

  -- 无论如何，都要重置 lastPressedAltTime
  lastPressedAltTime = currentTime
end

local function init()
  for key, bundleId in pairs(hotKeyToAppDict) do
    local binding = hs.hotkey.bind(hyperKey, key, function()
      switchApp(bundleId)
    end)
    table.insert(bindings, binding)
  end
end


--------------
-- Bindings --
--------------

init()

toggleEventListener = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, toggleEventHandler)
toggleEventListener:start()
