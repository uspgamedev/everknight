
local factories = {}
local sprite = require 'resources.sprites'

function factories.blood (p)
   local sprites = require "resources.sprites"
   p:setTexture(sprites.particle3)
   p:setParticleLifetime(0.3, math.min(1.0, blinglevel))
   p:setEmissionRate(40)
   p:setSizes(1)
   p:setSizeVariation(1, 2)
   p:setSpread(2*math.pi)
   p:setSpeed(128,128)
   p:setLinearAcceleration(0, 400, 0, 400)
   p:setColors(120, 0, 0, 255, 0, 0, 0, 0) -- Fade to transparency.
   p:setEmitterLifetime(.2)
   p:start()
   -- local posx, posy = self.getpos():unpack()
end

return function (which, pos)
   local i, p = next(standbyparticles)
   if p then
     table.remove(standbyparticles, i)
     factories[which](p)
     p:start()
     table.insert(particles, {pos, p, {255, 255, 255, 255}})
   end
end

