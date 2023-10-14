local chinese = 'com.sogou.inputmethod.sogou.pinyin'
local english = 'com.apple.keylayout.ABC'

local appToIme = {
    ['com.tencent.xinWeChat'] = chinese,
    ['com.electron.lark'] = chinese,

    ['com.googlecode.iterm2'] = english,
    ['com.DanPristupov.Fork'] = english,
    ['com.microsoft.VSCode'] = english,
    ['com.kapeli.dashdoc'] = english,
    ['org.vim.MacVim'] = english
}

local function tryToSwitchInputSource()
    local app = hs.window.frontmostWindow():application()
    local sourceId = appToIme[app:bundleID()]
    if sourceId then
        local currentSourceId = hs.keycodes.currentSourceID()
        if not (currentSourceId == sourceId) then
            hs.keycodes.currentSourceID(sourceId)
        end
    end
end

-- Handle cursor focus and application's screen manage.
local function activatedAppHandler(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        tryToSwitchInputSource()
    end
end

appWatcher = hs.application.watcher.new(activatedAppHandler)
appWatcher:start()
