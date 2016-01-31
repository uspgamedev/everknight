
local sprites = require 'resources.sprites'

local numparticles = 32
local effects = {}
local standbyparticles = {}

function effects.reset()
  if numparticles then
    --DO STUFF
    for i =1,numparticles do
      local tmpp = love.graphics.newParticleSystem(sprites.particle1, 10)
      table.insert(standbyparticles, tmpp)
    end
    numparticles = nil --sujo
  else
    for i = #effects,1,-1 do
      local particle = effects[i].particle
      if particle:getEmitterLifetime() >= 0 then
        particle:stop()
      end
    end
  end
end

function effects.update ()
  local todelete = {}
  for i,v in ipairs(effects) do
    local p = v.particle
    todelete[i] = not p:isActive()
    p:update(FRAME)
  end
  for i = #effects,1,-1 do
    if todelete[i] then
      table.insert(standbyparticles, effects[i].particle)
      table.remove(effects, i)
    end
  end
end

local factories = {}

function effects.new (which)
  local i, p = next(standbyparticles)
  if p then
    table.remove(standbyparticles, i)
    local blend = factories[which] (p)
    p:start()
    local ef = {particle = p, pos = vec2:new{}, blend = blend or 'add'}
    table.insert(effects, ef)
    return ef
  end
end

function factories.blood (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(0.6, math.min(1.0, blinglevel))
  p:setEmissionRate(40)
  p:setBufferSize(16)
  p:setSizes(1,1.5)
  p:setSizeVariation(1)
  p:setSpread(2*math.pi)
  p:setSpeed(128,128)
  p:setLinearAcceleration(0, 400, 0, 400)
  p:setColors(120, 0, 0, 255, 0, 0, 0, 0) -- Fade to transparency.
  p:setEmitterLifetime(.2)
  p:start()
end

function factories.bleeding (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(0.4)
  p:setEmissionRate(24)
  p:setBufferSize(16)
  p:setSizes(.9,1.1)
  p:setSizeVariation(1)
  p:setDirection(-math.pi)
  p:setSpread(1.2*math.pi)
  p:setAreaSpread('uniform', 8, 8)
  p:setSpeed(96,96)
  p:setLinearAcceleration(0, 600, 0, 1200)
  p:setColors(120, 10, 10, 255, 0, 0, 0, 0) -- Fade to transparency.
  p:setEmitterLifetime(-1)
  p:start()
  return 'alpha'
end

function factories.sparkle (p)
  p:reset()
  p:setTexture(sprites.particle1)
  p:setParticleLifetime(.8)
  p:setEmissionRate(15)
  p:setSizes(1, 1+math.min(blinglevel,2), .5)
  p:setSizeVariation(1)
  p:setDirection(-math.pi/2)
  p:setSpread(0)
  p:setAreaSpread('normal', 4, 4)
  p:setLinearAcceleration(0, -80, 0, -80)
  p:setColors(255, 255, 255, 255)
  p:setEmitterLifetime(-1)
  p:start()
end

function factories.vortex (p)
  p:reset()
  p:setTexture(sprites.particle1)
  p:setParticleLifetime(.8)
  p:setBufferSize(32)
  p:setEmissionRate(24)
  p:setSizes(1, 1+math.min(blinglevel,2), .5)
  p:setSizeVariation(1)
  p:setSpread(2*math.pi)
  p:setSpeed(16, 16)
  p:setTangentialAcceleration(80, 150)
  p:setColors(50, 50, 50, 250)
  p:setEmitterLifetime(-1)
  p:start()
  return 'subtract'
end

function factories.shock (p)
  p:reset()
  p:setTexture(sprites.particle2)
  p:setParticleLifetime(.6)
  p:setEmissionRate(10)
  p:setSizes(1 + math.min(blinglevel,2)*.1)
  p:setSizeVariation(1)
  p:setSpread(0)
  p:setSpeed(0,0)
  p:setRotation(0, 2*math.pi)
  p:setAreaSpread('normal', 6, 6)
  p:setLinearAcceleration(0, 0, 0, 0)
  p:setColors(100, 100, 255, 200, 255, 255, 255, 0)
  p:setEmitterLifetime(-1)
  p:start()
end

function factories.flame (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(1.2)
  p:setEmissionRate(32)
  p:setBufferSize(64)
  p:setSizes(1+math.min(blinglevel,2), 1, .5)
  p:setSizeVariation(.5)
  p:setDirection(-math.pi/2)
  p:setSpread(0)
  p:setSpeed(64, 96)
  p:setAreaSpread('normal', 2, 2)
  p:setLinearAcceleration(0, -80, 0, -150)
  p:setColors(255, 150, 100, 150, 50, 50, 50, 255, 0, 0, 0, 0)
  p:setEmitterLifetime(-1)
  p:start()
end

function factories.puffs (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(1.5)
  p:setEmissionRate(12)
  p:setBufferSize(32)
  p:setSizes(1+math.min(blinglevel,2))
  p:setSizeVariation(.5)
  p:setDirection(math.pi/2)
  p:setSpread(math.pi)
  p:setSpeed(8, 16)
  p:setSpin(-1, 1)
  p:setAreaSpread('normal', 2, 2)
  p:setLinearAcceleration(0, 80, 0, 100)
  p:setColors(100, 150, 240, 100, 255, 255, 255, 0)
  p:setEmitterLifetime(-1)
  p:start()
end

function effects.draw (g)
  for i,v in ipairs(effects) do
    g.push()
    g.setBlendMode(v.blend)
    g.translate(v.pos:unpack())
    g.setColor(255, 255, 255, 255)
    g.scale(1/64, 1/64)
    g.draw(v.particle, 0, 0)
    g.setBlendMode 'alpha'
    g.pop()
  end
end

return effects

