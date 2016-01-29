
local scenes = require 'scene'

FRAME = 1/60

vec2 = require 'lux.geom.Vector'

function love.load()
  curscene = scenes.title
  curscene.load()
end

do
  local lag = 0
  function love.update (dt)
    lag = lag + dt
    while lag >= FRAME do
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

