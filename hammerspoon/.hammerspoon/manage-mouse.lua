local hotkey = require 'hs.hotkey'
local geometry = require 'hs.geometry'
local drawing = require 'hs.drawing'
local mouse = require 'hs.mouse'
local keycodes = require 'hs.keycodes'

-------------
--   API   --
-------------

local highlightMouse
local moveMouseOneScreen

local mouseState = {}
moveMouseOneScreen = function(type)
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

-- Find my mouse pointer
local mouseCircle = nil
local mouseCircleTimer = nil
highlightMouse = function()
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

--------------
-- Bindings --
--------------

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
