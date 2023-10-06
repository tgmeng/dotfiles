-- Quickly Swtich Apps
local hyperQuicklySwitchApp = {'alt'}
local quicklySwitchAppHotKeyToAppDict = {
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

local quicklySwitchAppBindings = {}
local isQuicklySwitchAppEnabled = true
for key, bundleId in pairs(quicklySwitchAppHotKeyToAppDict) do
    local binding = hs.hotkey.bind(hyperQuicklySwitchApp, key, function()
        switchApp(bundleId)
    end)
    table.insert(quicklySwitchAppBindings, binding)
end

local lastQuicklySwitchAppToggleTime = 0
local isQuicklySwtichAppAltPressing = false
local function quicklySwitchAppToggleEventHandler(event)
    local flags = event:getFlags()

    if not isQuicklySwtichAppAltPressing then
        if flags:containExactly({'alt'}) then
            isQuicklySwtichAppAltPressing = true

            local currentTime = hs.timer.localTime()
            if (currentTime - lastQuicklySwitchAppToggleTime <= hs.eventtap.doubleClickInterval()) then
                isQuicklySwitchAppEnabled = not isQuicklySwitchAppEnabled

                for _, hkObj in ipairs(quicklySwitchAppBindings) do
                    if isQuicklySwitchAppEnabled then
                        hkObj:enable()
                    else
                        hkObj:disable()
                    end
                end

                if isQuicklySwitchAppEnabled then
                    msg = 'enabled'
                else
                    msg = 'disabled'
                end
                hs.alert.show(string.format('Quickly Switch App is %s', msg))
                lastQuicklySwitchAppToggleTime = 0
            else
                lastQuicklySwitchAppToggleTime = currentTime
            end
        end
    else
        if flags:containExactly({}) then
            isQuicklySwtichAppAltPressing = false
        end
    end
end

quicklySwitchAppToggleEventListener = hs.eventtap.new({hs.eventtap.event.types.flagsChanged},
    quicklySwitchAppToggleEventHandler)
quicklySwitchAppToggleEventListener:start()

function switchApp(targetBundleId)
    local app = hs.application.frontmostApplication()
    if app:bundleID() == targetBundleId then
        app:hide()
    else
        hs.application.launchOrFocusByBundleID(targetBundleId)
    end
end
