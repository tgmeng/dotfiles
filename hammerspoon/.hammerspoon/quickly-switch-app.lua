-------------
--   API   --
-------------
local hyperKey = { 'alt' }
local hotKeyToAppDict = {
  ['Q'] = 'com.google.Chrome',
  ['W'] = 'com.googlecode.iterm2',
  ['E'] = 'com.todesktop.230313mzl4w4u92',
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
local lastPressedAltTime = 0
local interval = 0.2 * 1e9

-- Correctly checks if ONLY the hyper key(s) are pressed.
local function isHyperKeyOnly(flags)
  -- Create a lookup table from the hyperKey array for faster checking.
  local hyperKeyFlags = {}
  for _, key in ipairs(hyperKey) do
    hyperKeyFlags[key] = true
  end

  -- Check if all required hyper keys are pressed.
  for key, _ in pairs(hyperKeyFlags) do
    if not flags[key] then
      return false
    end
  end

  -- Check if any non-hyper keys are pressed.
  for key, isPressed in pairs(flags) do
    if isPressed and not hyperKeyFlags[key] then
      return false
    end
  end

  return true
end


local function toggleEventHandler(event)
  local flags = event:getFlags()

  if not isHyperKeyOnly(flags) then
    return
  end

  local currentTime = hs.timer.absoluteTime()

  -- If it's a double-press within the interval, toggle the state.
  if (currentTime - lastPressedAltTime) <= interval then
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
    lastPressedAltTime = 0 -- Reset timer to prevent triple-presses from toggling again.
    return
  end

  -- This is the first press, so just record the time.
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