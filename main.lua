
local scenes = require 'scene'

vec2 = require 'lux.geom.Vector'


function love.load()
  curscene = scenes.title
  curscene.load()
end

function love.update(dt)
  retscene = curscene.update(dt)
  if retscene and scenes[retscene] then
    curscene = scenes[retscene]
    curscene.load()
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

