local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'
local drawing = require 'hs.drawing'
local mouse = require 'hs.mouse'
local keycodes = require 'hs.keycodes'
local spaces = require 'hs._asm.undocumented.spaces'

window.animationDuration = 0

--------------
-- Bindings --
--------------

local hyperMouse = {'alt'}
local hyperSize = {'cmd', 'ctrl', 'alt'}
local hyperScreen = {'ctrl', 'alt'}
local hyperSpace =      {"ctrl", "cmd"}
local hyperSpaceShift = {"ctrl", "cmd","shift"}

--- Split & Resize ---
-- Split Screen --
hotkey.bind(hyperSize, 'H', function() splitResizeWindow('left') end)
hotkey.bind(hyperSize, 'L', function() splitResizeWindow('right') end)
hotkey.bind(hyperSize, 'K', function() splitResizeWindow('up') end)
hotkey.bind(hyperSize, 'J', function() splitResizeWindow('down') end)

-- Resize window --
hotkey.bind(hyperSize, 'M', function() splitResizeWindow('maximize') end)
hotkey.bind(hyperSize, 'C', function() splitResizeWindow('center') end)

-- Snapback --
hotkey.bind(hyperSize, '/', function() snapback() end)

--- Move window betbeen Spaces (using undocumented API) ---
if spaces then
    hotkey.bind(hyperSpace, "X", nil, function() moveWindowOneSpace("right", false) end)
    hotkey.bind(hyperSpace, "Z", nil, function() moveWindowOneSpace("left", false) end)
    hotkey.bind(hyperSpaceShift, "X", nil, function() moveWindowOneSpace("right", true) end)
    hotkey.bind(hyperSpaceShift, "Z", nil, function() moveWindowOneSpace("left", true) end)
end

--- Multiple Monitors ---
-- Move window between monitors --
hotkey.bind(hyperScreen, 'X', function() moveWindowOneScreen('next') end)
hotkey.bind(hyperScreen, 'Z', function() moveWindowOneScreen('previous') end)

-- Move mouse between monitors --
local mouseBinds = {
    hotkey.bind(hyperMouse, '2', function() moveMouseOneScreen('next') end),
    hotkey.bind(hyperMouse, '1', function() moveMouseOneScreen('previous') end)
}
local enabled = true
hotkey.bind(hyperMouse, keycodes.map['escape'], function()
    enabled = not enabled
    for _, hkObj in ipairs(mouseBinds) do
        if enabled then hkObj:enable()
        else hkObj:disable()
        end
    end

    local msg = nil
    if enabled then msg = 'Move mouse enabled'
    else msg = 'Move mouse disabled'
    end
    hs.alert.show(msg)
end)

-------------
--   API   --
-------------

function splitResizeWindow(type)
    local win = getGoodFocusedWindow(true)
    if not win then return end

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
        fillColor = {alpha = 0.25, red = 1},
        type = "rectangle"
    })

    flash:show()
    hs.timer.doAfter(.15,function () flash:delete() end)
end 

function switchSpace(skip,dir)
    for i = 1, skip do
        hs.eventtap.keyStroke({"ctrl"}, dir)
    end 
end

function moveWindowOneSpace(dir,switch)
    local win = getGoodFocusedWindow(true)
    if not win then return end

    local screen = win:screen()
    local uuid = screen:spacesUUID()
    local userSpaces = spaces.layout()[uuid]
    local thisSpace = win:spaces() -- first space win appears on
    if not thisSpace then return else thisSpace = thisSpace[1] end

    local last = nil
    local skipSpaces = 0
    for _, spc in ipairs(userSpaces) do
        if spaces.spaceType(spc) ~= spaces.types.user then -- skippable space
            skipSpaces = skipSpaces + 1
        else 			-- A good user space, check it
            if last and
                (dir == "left"  and spc == thisSpace) or
                (dir == "right" and last == thisSpace)
            then
                win:spacesMoveTo(dir == "left" and last or spc)
                if switch then
                    switchSpace(skipSpaces + 1,dir)
                    win:focus()
                end
                return
            end
            last = spc	 -- Haven't found it yet...
            skipSpaces = 0
        end 
    end 

    flashScreen(screen)   -- Shouldn't get here, so no space found
end

function moveWindowOneScreen(type)
    local win = getGoodFocusedWindow(true)
    if not win then return end

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

    mouseHighlight()
end

local snapbackStates = {} 
function snapback()
    local win = getGoodFocusedWindow()
    if not win then return end

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
    if not win or not win:isStandard() then return end
    if isNoFull and win:isFullScreen() then return end
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

function mouseHighlight()
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    local mouseCircle = drawing.circle(geometry.rect(mousepoint.x - 40, mousepoint.y - 40, 80, 80))
    mouseCircle:setStrokeColor({["red"] = 1, ["blue"] = 0, ["green"] = 0, ["alpha"] = 1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after n seconds
    hs.timer.doAfter(.3, function() mouseCircle:delete() end)
end

--- https://gist.github.com/josephholsten/1e17c7418d9d8ec0e783
--- hs.window:moveToScreen(screen)
--- Method
--- move window to the the given screen, keeping the relative proportion and position window to the original screen.
--- Example: win:moveToScreen(win:screen():next()) -- move window to next screen
function hs.window:moveToScreen(nextScreen)
    local currentFrame = self:frame()
    local screenFrame = self:screen():frame()
    local nextScreenFrame = nextScreen:frame()
    self:setFrame({
        x = ((((currentFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x),
        y = ((((currentFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y),
        h = currentFrame.h,
        w = currentFrame.w
    })
end

hs.alert.show('Config loaded')
