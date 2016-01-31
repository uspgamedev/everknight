
local scenes = require 'scene'

FRAME = 1/60
LOADED = false

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

for name,handler in pairs(love.handlers) do
  if name ~= 'quit' then
    love[name] = function (...)
      return (curscene[name] or function () end) (...)
    end
  end
end

function love.draw()
  curscene.draw()
end

