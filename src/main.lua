
local scenes = require 'scene'

FRAME = 1/60
LOADED = false
TUTORIAL = true
local KINPUT = {
  up = false, down = false, left = false, right = false,
  confirm = false
}
local JINPUT = {
  up = false, down = false, left = false, right = false,
  confirm = false
}
INPUT = setmetatable({}, {
  __index = function (self, which)
    return KINPUT[which] or JINPUT[which]
  end
})

local DIR_KEYS = { up = true, down = true, left = true, right = true }
local CONFIRM_KEYS = { ['return'] = true, z = true, x = true }

vec2 = require 'lux.geom.Vector'

function love.load()
  curscene = scenes.splash_ggj
  curscene.load()
  SOUNDS = require 'resources.sounds'
  EFFECTS = require 'resources.effects'
  FONTS = {}
  for i=1,4 do
    FONTS[i] = love.graphics.newFont('assets/LCD_Solid.ttf', 2^(2+i))
  end
end

do
  local lag = 0
  function love.update (dt)
    lag = lag + dt
    while lag >= FRAME do
      if ( love.keyboard.isDown("lalt") and love.keyboard.isDown("f4") ) or 
        ( love.keyboard.isDown("lgui") and love.keyboard.isDown("f4") ) or
        ( love.keyboard.isDown("lgui") and love.keyboard.isDown("q") ) or
        ( love.keyboard.isDown("lctrl") and love.keyboard.isDown("q") ) or
        ( love.keyboard.isDown("lalt") and love.keyboard.isDown("q") ) then
        love.event.quit()
      end
      retscene = curscene.update()
      if retscene and scenes[retscene] then
        curscene = scenes[retscene]
        curscene.load()
      end
      lag = lag - FRAME
    end
  end
end

function love.keypressed (key)
  if DIR_KEYS[key] then
    KINPUT[key] = true
  elseif CONFIRM_KEYS[key] then
    KINPUT.confirm = true
  end
  return (curscene.keypressed or function () end) (key)
end

function love.keyreleased (key)
  if DIR_KEYS[key] then
    KINPUT[key] = false
  elseif CONFIRM_KEYS[key] then
    KINPUT.confirm = false
  end
  return (curscene.keyreleased or function () end) (key)
end

local BTNCHECK = 0

function love.joystickpressed (joystick, btn)
  BTNCHECK = BTNCHECK + 1
  JINPUT.confirm = true
  return (curscene.keypressed or function () end) ('return')
end

function love.joystickreleased (joystick, btn)
  BTNCHECK = BTNCHECK - 1
  if BTNCHECK <= 0 then
    JINPUT.confirm = false
    return (curscene.keyreleased or function () end) ('return')
  end
end

function love.joystickaxis (joystick, axis, value)
  if axis == 2 then
    JINPUT.up = false
    JINPUT.down = false
    if value < -.5 then
      JINPUT.up = true
    elseif value > .5 then
      JINPUT.down = true
    end
  elseif axis == 3 then
    JINPUT.left = false
    JINPUT.right = false
    if value < -.5 then
      JINPUT.left = true
    elseif value > .5 then
      JINPUT.right = true
    end
  end
end

function love.draw()
  curscene.draw()
end

