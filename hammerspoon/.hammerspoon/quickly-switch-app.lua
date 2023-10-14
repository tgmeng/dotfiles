-------------
--   API   --
-------------
local hyperKey = {'alt'}
local hotKeyToAppDict = {
    ['Q'] = 'com.google.Chrome',
    ['W'] = 'com.googlecode.iterm2',
    ['E'] = 'com.microsoft.VSCode',
    ['R'] = 'com.apple.iCal',
    ['T'] = 'com.culturedcode.ThingsMac',

    ['A'] = 'com.apple.Safari',
    ['S'] = 'com.DanPristupov.Fork',
    ['D'] = 'com.kapeli.dashdoc',
    ['G'] = 'com.binarynights.ForkLift-3',

    ['Z'] = 'com.youzan.zanproxy',
    ['X'] = 'com.electron.lark',
    ['C'] = 'com.coderforart.MWeb3',
    ['V'] = 'com.tencent.xinWeChat'
}

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
local isPressingAlt = false
local interval = hs.eventtap.doubleClickInterval() / 3 * 1000000000
local function toggleEventHandler(event)
    local flags = event:getFlags()

    if not isPressingAlt then
        if flags:containExactly(hyperKey) then
            isPressingAlt = true

            local currentTime = hs.timer.absoluteTime()
            if (currentTime - lastPressedAltTime <= interval) then
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

                lastPressedAltTime = 0
            else
                lastPressedAltTime = currentTime
            end
        end
    else
        if flags:containExactly({}) then
            isPressingAlt = false
        end
    end
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

toggleEventListener = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, toggleEventHandler)
toggleEventListener:start()

