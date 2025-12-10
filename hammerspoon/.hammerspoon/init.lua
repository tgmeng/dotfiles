require './manage-window'
require './manage-mouse'
require './quickly-switch-app'

local AutoSwitchInputSource = require './auto-switch-input-source'

--[[
  ShowBundleId
--]]
local ShowAppBundleId = require './show-app-bundle-id'
local showAppBundleId = ShowAppBundleId:new()
showAppBundleId:start()


--[[
  AutoSwitchInputSource
--]]
local chinese = 'im.rime.inputmethod.Squirrel.Hans'
-- local chinese = 'com.apple.inputmethod.SCIM.ITABC'
local english = 'com.apple.keylayout.ABC'
local autoSwitchInputSource = AutoSwitchInputSource:new(
  {
    ['com.tencent.xinWeChat'] = chinese,
    ['com.electron.lark'] = chinese,

    ['com.googlecode.iterm2'] = english,
    ['com.DanPristupov.Fork'] = english,
    ['com.microsoft.VSCode'] = english,
    ['com.kapeli.dashdoc'] = english,
    ['org.vim.MacVim'] = english
  }
)
autoSwitchInputSource:start()

hs.alert.show('Config is loaded')

-- generate lua autocomplete annotations
-- hs.loadSpoon('EmmyLua')
