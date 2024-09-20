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
  ['D'] = 'com.kapeli.dashdoc',
  ['G'] = 'com.binarynights.ForkLift',
  ['J'] = 'net.shinystone.OKJSON',
  ['K'] = 'com.vladbadea.csveditor',

  ['Z'] = 'com.youzan.zanproxy',
  ['X'] = 'com.electron.lark',
  -- ['C'] = 'com.coderforart.MWeb3',
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
local interval = hs.eventtap.doubleClickInterval() / 3 * 1000000000
local function toggleEventHandler(event)
  local flags = event:getFlags()

  if not flags:containExactly(hyperKey) then
    return
  end

  local lastTime = lastPressedAltTime or 0
  local currentTime = hs.timer.absoluteTime()
  lastPressedAltTime = currentTime

  if (currentTime - lastTime > interval) then
    return
  end

  isEnabled = not isEnabled

  for _, hkObj in ipairs(bindings) do
    if isEnabled then
      hkObj:enable()
    else
      hkObj:disable()
    end
  end

  if isEnabled then
    msg = 'enabled'
  else
    msg = 'disabled'
  end

  if alertId then
    hs.alert.closeSpecific(alertId)
  end
  alertId = hs.alert.show(string.format('Quickly Switch App is %s', msg))

  lastPressedAltTime = nil
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
-- 防止误触 --
--------------
local function keyEventHandler(event)
  lastPressedAltTime = nil
end

--------------
-- Bindings --
--------------

init()

toggleEventListener = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, toggleEventHandler)
toggleEventListener:start()

keyDownListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, keyEventHandler)
keyDownListener:start()

keyUpListener = hs.eventtap.new({ hs.eventtap.event.types.keyUp }, keyEventHandler)
keyUpListener:start()
