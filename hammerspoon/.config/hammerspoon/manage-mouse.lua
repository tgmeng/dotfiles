local hotkey = require 'hs.hotkey'
local geometry = require 'hs.geometry'
local canvas = require 'hs.canvas'
local mouse = require 'hs.mouse'

local ManageMouse = {}

local rainbowColors = {
  { red = 1, green = 0.2, blue = 0.2, alpha = 1 },
  { red = 1, green = 0.55, blue = 0.1, alpha = 1 },
  { red = 1, green = 0.85, blue = 0.15, alpha = 1 },
  { red = 0.2, green = 0.8, blue = 0.3, alpha = 1 },
  { red = 0.2, green = 0.55, blue = 1, alpha = 1 },
  { red = 0.7, green = 0.3, blue = 1, alpha = 1 }
}

function ManageMouse:new(config)
  config = config or {}

  local obj = {
    bindings = {},
    mouseState = {},
    mouseCircle = nil,
    mouseCircleTimer = nil,
    mouseCircleAnimationTimer = nil,
    config = {
      modifiers = config.modifiers or {},
      bindings = config.bindings or {}
    }
  }

  setmetatable(obj, self)
  self.__index = self
  return obj
end

function ManageMouse:clearMouseHighlight()
  if self.mouseCircle then
    self.mouseCircle:delete()
    self.mouseCircle = nil
  end

  if self.mouseCircleAnimationTimer then
    self.mouseCircleAnimationTimer:stop()
    self.mouseCircleAnimationTimer = nil
  end

  if self.mouseCircleTimer then
    self.mouseCircleTimer:stop()
    self.mouseCircleTimer = nil
  end
end

function ManageMouse:highlightMouse()
  self:clearMouseHighlight()

  local mousepoint = mouse.absolutePosition()
  local radius = 40
  local strokeWidth = 6
  local canvasPadding = strokeWidth + 6
  local canvasRadius = radius + canvasPadding
  local diameter = canvasRadius * 2
  local segmentOverlap = 2
  local segmentSweep = (360 / #rainbowColors) + segmentOverlap
  local frame = geometry.rect(
    mousepoint.x - canvasRadius,
    mousepoint.y - canvasRadius,
    diameter,
    diameter
  )

  self.mouseCircle = canvas.new(frame)
  self.mouseCircle:level('overlay')
  self.mouseCircle:behavior({ 'canJoinAllSpaces', 'stationary' })
  self.mouseCircle:show()

  for index, color in ipairs(rainbowColors) do
    local startAngle = (index - 1) * (360 / #rainbowColors)
    self.mouseCircle:appendElements({
      type = 'arc',
      action = 'stroke',
      strokeColor = color,
      fillColor = { alpha = 0 },
      strokeWidth = strokeWidth,
      strokeCapStyle = 'round',
      center = { x = canvasRadius, y = canvasRadius },
      radius = radius,
      startAngle = startAngle,
      endAngle = startAngle + segmentSweep,
      arcRadii = false
    })
  end

  local rotationAngle = 0
  self.mouseCircleAnimationTimer = hs.timer.doEvery(0.016, function()
    if not self.mouseCircle then
      return
    end

    rotationAngle = (rotationAngle + 8) % 360
    self.mouseCircle:transformation(
      hs.canvas.matrix
        .translate(canvasRadius, canvasRadius)
        :rotate(rotationAngle)
        :translate(-canvasRadius, -canvasRadius)
    )
  end)

  self.mouseCircleTimer = hs.timer.doAfter(0.35, function()
    self:clearMouseHighlight()
  end)
end

function ManageMouse:moveMouseOneScreen(action)
  local screen = mouse.getCurrentScreen()
  local toScreen = nil

  if action == 'next' then
    toScreen = screen:next()
  elseif action == 'previous' then
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
  local toScreenId = toScreen:id()
  local toPos = self.mouseState[toScreenId]

  if not toPos then
    local x = pos.x / rect.w * toRect.w
    local y = pos.y / rect.h * toRect.h
    toPos = geometry.point(x, y)
  end

  mouse.setRelativePosition(toPos, toScreen)
  self.mouseState[screen:id()] = pos

  self:highlightMouse()
end

function ManageMouse:start()
  self:stop()

  for key, action in pairs(self.config.bindings) do
    local binding = hotkey.bind(self.config.modifiers, key, function()
      self:moveMouseOneScreen(action)
    end)
    table.insert(self.bindings, binding)
  end
end

function ManageMouse:stop()
  for _, binding in ipairs(self.bindings) do
    binding:delete()
  end
  self.bindings = {}
  self:clearMouseHighlight()
end

return ManageMouse
