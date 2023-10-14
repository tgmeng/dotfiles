local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'

-------------
--   API   --
-------------
local function getGoodFocusedWindow(isNoFull)
    local win = window.focusedWindow()
    if not win or not win:isStandard() then
        return
    end
    if isNoFull and win:isFullScreen() then
        return
    end
    return win
end

local snapbackStates = {}
local function snapback()
    local win = getGoodFocusedWindow()
    if not win then
        return
    end

    local id = win:id()
    local state = win:frame()
    local prevState = snapbackStates[id]
    if prevState then
        win:setFrame(prevState)
    end
    snapbackStates[id] = state
end

local function setFrame(win, unit)
    if not win then
        return nil
    end

    local id = win:id()
    local state = win:frame()
    snapbackStates[id] = state
    return win:setFrame(unit)
end

local function splitResizeWindow(type)
    local win = getGoodFocusedWindow(true)
    if not win then
        return
    end

    local screen = win:screen()
    local max = screen:frame()
    local state = nil

    if type == 'left' then
        state = geometry.rect(max.x, max.y, max.w / 2, max.h)
    elseif type == 'right' then
        state = geometry.rect(max.x + (max.w / 2), max.y, max.w / 2, max.h)
    elseif type == 'up' then
        state = geometry.rect(max.x, max.y, max.w, max.h / 2)
    elseif type == 'down' then
        state = geometry.rect(max.x, max.y + (max.h / 2), max.w, max.h / 2)
    elseif type == 'maximize' then
        state = geometry.rect(max.x, max.y, max.w, max.h)
    elseif type == 'center' then
        local winState = win:frame()
        local ww = max.w / 2
        local wh = max.h / 2

        state = geometry.rect(max.x + (max.w / 2) - (ww / 2), max.y + (max.h / 2) - (wh / 2), ww, wh)
    else
        return
    end

    setFrame(win, state)
end

local function moveWindowOneScreen(type)
    local win = getGoodFocusedWindow(true)
    if not win then
        return
    end

    local screen = nil
    if type == 'next' then
        screen = win:screen():next()
    elseif type == 'previous' then
        screen = win:screen():previous()
    else
        return
    end

    win:moveToScreen(screen)
end

--------------
-- Bindings --
--------------

-- disable moving window animation
window.animationDuration = 0

local hyperSize = {'cmd', 'ctrl', 'alt'}
local hyperScreen = {'ctrl', 'alt'}

--- Split Screen
hotkey.bind(hyperSize, 'H', function()
    splitResizeWindow('left')
end)
hotkey.bind(hyperSize, 'L', function()
    splitResizeWindow('right')
end)
hotkey.bind(hyperSize, 'K', function()
    splitResizeWindow('up')
end)
hotkey.bind(hyperSize, 'J', function()
    splitResizeWindow('down')
end)

--- Resize window
hotkey.bind(hyperSize, 'M', function()
    splitResizeWindow('maximize')
end)
hotkey.bind(hyperSize, 'C', function()
    splitResizeWindow('center')
end)

--- Snapback
hotkey.bind(hyperSize, '/', function()
    snapback()
end)

--- Move window between monitors
hotkey.bind(hyperScreen, 'X', function()
    moveWindowOneScreen('next')
end)
hotkey.bind(hyperScreen, 'Z', function()
    moveWindowOneScreen('previous')
end)
