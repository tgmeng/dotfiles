local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'
local drawing = require 'hs.drawing'
local mouse = require 'hs.mouse'
local keycodes = require 'hs.keycodes'
local logger = require 'hs.logger'

local log = logger.new('init', 'debug')

require './quickly-app-switch'

window.animationDuration = 0

--------------
-- Bindings --
--------------

-- Window

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

-- Mouse

local hyperMouse = {'alt'}

--- Move mouse between monitors
local mouseBinds = {hotkey.bind(hyperMouse, '2', function()
    moveMouseOneScreen('next')
end), hotkey.bind(hyperMouse, '1', function()
    moveMouseOneScreen('previous')
end)}

-- local enabled = true
-- hotkey.bind(hyperMouse, keycodes.map['escape'], function()
--     enabled = not enabled
--     for _, hkObj in ipairs(mouseBinds) do
--         if enabled then
--             hkObj:enable()
--         else
--             hkObj:disable()
--         end
--     end

--     local msg = nil
--     if enabled then
--         msg = 'Move mouse enabled'
--     else
--         msg = 'Move mouse disabled'
--     end
--     hs.alert.show(msg)
-- end)

-------------
--   API   --
-------------

function splitResizeWindow(type)
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

function flashScreen(screen)
    local flash = hs.canvas.new(screen:fullFrame()):appendElements({
        action = "fill",
        fillColor = {
            alpha = 0.25,
            red = 1
        },
        type = "rectangle"
    })

    flash:show()
    hs.timer.doAfter(.15, function()
        flash:delete()
    end)
end

function moveWindowOneScreen(type)
    local win = getGoodFocusedWindow(true)
    if not win then
        return
    end

    local screen = nil
    if type == 'next' then
        hs.alert.show("Next Monitor")
        screen = win:screen():next()
    elseif type == 'previous' then
        hs.alert.show("Prev Monitor")
        screen = win:screen():previous()
    else
        return
    end

    win:moveToScreen(screen)
end

local mouseState = {}
function moveMouseOneScreen(type)
    local screen = mouse.getCurrentScreen()

    local toScreen = nil
    if type == 'next' then
        toScreen = screen:next()
    elseif type == 'previous' then
        toScreen = screen:previous()
    else
        return
    end

    if toScreen:id() == screen:id() then
        return
    end

    local rect = screen:fullFrame()
    local toRect = toScreen:fullFrame()

    local pos = mouse.getRelativePosition()
    local toPos = nil

    local toScreenId = toScreen:id()
    if mouseState[toScreenId] then
        toPos = mouseState[toScreenId]
    else
        local x = pos.x / rect.w * toRect.w
        local y = pos.y / rect.h * toRect.h
        toPos = geometry.point(x, y)
    end

    mouse.setRelativePosition(toPos, toScreen)
    mouseState[screen:id()] = pos

    highlightMouse()
end

local snapbackStates = {}
function snapback()
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

function getGoodFocusedWindow(isNoFull)
    local win = window.focusedWindow()
    if not win or not win:isStandard() then
        return
    end
    if isNoFull and win:isFullScreen() then
        return
    end
    return win
end

function setFrame(win, unit)
    if not win then
        return nil
    end

    local id = win:id()
    local state = win:frame()
    snapbackStates[id] = state
    return win:setFrame(unit)
end

-- Find my mouse pointer
local mouseCircle = nil
local mouseCircleTimer = nil
function highlightMouse()
    if mouseCircle then
        mouseCircle:delete()
        mouseCircle = nil
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.absolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - 40, mousepoint.y - 40, 80, 80))
    mouseCircle:setStrokeColor({
        ["red"] = 1,
        ["blue"] = 0,
        ["green"] = 0,
        ["alpha"] = 1
    })
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()
    mouseCircleTimer = hs.timer.doAfter(0.2, function()
        mouseCircle:delete()
        mouseCircle = nil
    end)
end

hs.alert.show('Config is loaded')
