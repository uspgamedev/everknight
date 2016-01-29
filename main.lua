
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

function love.draw()
  curscene.draw()
end

