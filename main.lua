scenes = require 'scene'

vec2 = require 'lux.geom.Vector'


function love.load()
    scene = scenes.title
end

function love.draw()
    scene.draw()

end

function love.update()
    scene.update()
end