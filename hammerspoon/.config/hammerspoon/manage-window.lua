local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'

local ManageWindow = {}

function ManageWindow:new(config)
  config = config or {}

  local obj = {
    bindings = {},
    snapbackStates = {},
    config = {
      resizeModifiers = config.resizeModifiers or {},
      screenModifiers = config.screenModifiers or {},
      resizeBindings = config.resizeBindings or {},
      screenBindings = config.screenBindings or {},
      animationDuration = config.animationDuration or 0
    }
  }

  setmetatable(obj, self)
  self.__index = self
  return obj
end

function ManageWindow:getGoodFocusedWindow(isNoFull)
  local win = window.focusedWindow()
  if not win or not win:isStandard() then
    return nil
  end

  if isNoFull and win:isFullScreen() then
    return nil
  end

  return win
end

function ManageWindow:snapback()
  local win = self:getGoodFocusedWindow()
  if not win then
    return
  end

  local id = win:id()
  local state = win:frame()
  local prevState = self.snapbackStates[id]
  if prevState then
    win:setFrame(prevState)
  end
  self.snapbackStates[id] = state
end

function ManageWindow:setFrame(win, unit)
  if not win then
    return nil
  end

  local id = win:id()
  self.snapbackStates[id] = win:frame()
  return win:setFrame(unit)
end

function ManageWindow:splitResizeWindow(action)
  local win = self:getGoodFocusedWindow(true)
  if not win then
    return
  end

  local max = win:screen():frame()
  local state = nil

  if action == 'left' then
    state = geometry.rect(max.x, max.y, max.w / 2, max.h)
  elseif action == 'right' then
    state = geometry.rect(max.x + (max.w / 2), max.y, max.w / 2, max.h)
  elseif action == 'up' then
    state = geometry.rect(max.x, max.y, max.w, max.h / 2)
  elseif action == 'down' then
    state = geometry.rect(max.x, max.y + (max.h / 2), max.w, max.h / 2)
  elseif action == 'maximize' then
    state = geometry.rect(max.x, max.y, max.w, max.h)
  elseif action == 'center' then
    local ww = max.w / 2
    local wh = max.h / 2

    state = geometry.rect(
      max.x + (max.w / 2) - (ww / 2),
      max.y + (max.h / 2) - (wh / 2),
      ww,
      wh
    )
  else
    return
  end

  self:setFrame(win, state)
end

function ManageWindow:moveWindowOneScreen(action)
  local win = self:getGoodFocusedWindow(true)
  if not win then
    return
  end

  local screen = nil
  if action == 'next' then
    screen = win:screen():next()
  elseif action == 'previous' then
    screen = win:screen():previous()
  else
    return
  end

  win:moveToScreen(screen)
end

function ManageWindow:bindHotkeys(modifiers, bindings, handler)
  for key, action in pairs(bindings) do
    local binding = hotkey.bind(modifiers, key, function()
      handler(self, action)
    end)
    table.insert(self.bindings, binding)
  end
end

function ManageWindow:start()
  self:stop()

  window.animationDuration = self.config.animationDuration

  self:bindHotkeys(self.config.resizeModifiers, self.config.resizeBindings, function(instance, action)
    if action == 'snapback' then
      instance:snapback()
      return
    end

    instance:splitResizeWindow(action)
  end)

  self:bindHotkeys(self.config.screenModifiers, self.config.screenBindings, function(instance, action)
    instance:moveWindowOneScreen(action)
  end)
end

function ManageWindow:stop()
  for _, binding in ipairs(self.bindings) do
    binding:delete()
  end
  self.bindings = {}
end

return ManageWindow
