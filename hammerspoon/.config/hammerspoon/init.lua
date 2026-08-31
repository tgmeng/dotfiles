local ManageWindow = require './manage-window'
local ManageMouse = require './manage-mouse'
local QuicklySwitchApp = require './quickly-switch-app'
local AutoSwitchInputSource = require './auto-switch-input-source'

local Apps = {
  Chrome = 'com.google.Chrome',
  Zed = 'dev.zed.Zed',
  ITerm2 = 'com.googlecode.iterm2',
  Ghostty = 'com.mitchellh.ghostty',
  Cursor = 'com.todesktop.230313mzl4w4u92',
  Codex = 'com.openai.codex',
  Safari = 'com.apple.Safari',
  Calendar = 'com.apple.iCal',
  ContinuityCamera = 'com.apple.ScreenContinuity',
  Proxyman = 'com.proxyman.NSProxy',
  Things = 'com.culturedcode.ThingsMac',
  Fork = 'com.DanPristupov.Fork',
  Forklift = 'com.binarynights.ForkLift',
  Dash = 'com.kapeli.dashdoc',
  OKJSON = 'net.shinystone.OKJSON',
  CSVEditor = 'com.vladbadea.csveditor',
  Zanproxy = 'com.youzan.zanproxy',
  Lark = 'com.electron.lark',
  Obsidian = 'md.obsidian',
  OpenAIChat = 'com.openai.chat',
  WeChat = 'com.tencent.xinWeChat',
  Notes = 'com.apple.Notes',
  MindNode = 'com.ideasoncanvas.mindnode.macos',
  Stickies = 'com.apple.Stickies',
  VSCode = 'com.microsoft.VSCode'
}

--[[
  ShowBundleId
--]]
-- local ShowAppBundleId = require './show-app-bundle-id'
-- local showAppBundleId = ShowAppBundleId:new()
-- showAppBundleId:start()

--[[
  ManageWindow
--]]
local manageWindow = ManageWindow:new(
  {
    resizeModifiers = { 'cmd', 'ctrl', 'alt' },
    screenModifiers = { 'ctrl', 'alt' },
    resizeBindings = {
      ['H'] = 'left',
      ['L'] = 'right',
      ['K'] = 'up',
      ['J'] = 'down',
      ['M'] = 'maximize',
      ['C'] = 'center',
      ['/'] = 'snapback'
    },
    screenBindings = {
      ['X'] = 'next',
      ['Z'] = 'previous'
    },
    animationDuration = 0
  }
)
manageWindow:start()

--[[
  ManageMouse
--]]
local manageMouse = ManageMouse:new(
  {
    modifiers = { 'alt' },
    bindings = {
      ['2'] = 'next',
      ['1'] = 'previous'
    }
  }
)
manageMouse:start()

--[[
  QuicklySwitchApp
--]]
local quicklySwitchApp = QuicklySwitchApp:new(
  {
    hyperKey = { 'alt' },
    hotKeyToAppDict = {
      ['Q'] = Apps.Chrome,
      ['3'] = Apps.Zed,
      -- ['W'] = Apps.ITerm2,
      ['W'] = Apps.Ghostty,
      ['E'] = Apps.VSCode,
      ['R'] = Apps.Codex,
      -- ['T'] = Apps.Safari,
      ['T'] = Apps.Calendar,
      ['I'] = Apps.ContinuityCamera,
      ['P'] = Apps.Proxyman,

      ['A'] = Apps.Things,
      ['S'] = Apps.Fork,
      ['D'] = Apps.Forklift,
      ['G'] = Apps.Dash,
      ['J'] = Apps.OKJSON,
      ['K'] = Apps.CSVEditor,

      ['Z'] = Apps.Zanproxy,
      ['X'] = Apps.Lark,
      ['C'] = Apps.Obsidian,
      ['Tab'] = Apps.OpenAIChat,
      ['V'] = Apps.WeChat,
      ['N'] = Apps.Notes,
      ['M'] = Apps.MindNode,

      ['`'] = Apps.Stickies
    },
    toggleIntervalSeconds = 0.2
  }
)
quicklySwitchApp:start()

--[[
  AutoSwitchInputSource
--]]
local chinese = 'im.rime.inputmethod.Squirrel.Hans'
-- local chinese = 'com.apple.inputmethod.SCIM.ITABC'
local english = 'com.apple.keylayout.ABC'
local autoSwitchInputSource = AutoSwitchInputSource:new(
  {
    [Apps.WeChat] = chinese,
    [Apps.Lark] = chinese,

    [Apps.VSCode] = english,
    [Apps.Zed] = english,
    [Apps.Cursor] = english,
    [Apps.Codex] = chinese,

    [Apps.ITerm2] = english,
    [Apps.Ghostty] = english,

    [Apps.Dash] = english,
  }
)
autoSwitchInputSource:start()

hs.alert.show('Config is loaded')

-- generate lua autocomplete annotations
-- hs.loadSpoon('EmmyLua')
