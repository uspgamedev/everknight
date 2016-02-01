
local sprites = require 'resources.sprites'

local numparticles = 32
local effects = {}
local standbyparticles = {}
local min = math.min

local sphere

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
  if not sphere then
    local data = love.image.newImageData(16,16)
    local center = vec2:new{8,8}
    data:mapPixel(function (x, y)
      local d = vec2:new{x,y} - center
      d = (d*d)/64
      d = math.max(0, 1-d)
      return 255, 255, 255, d*255
    end)
    sphere = love.graphics.newImage(data)
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

function effects.new (which, ...)
  local i, p = next(standbyparticles)
  if p then
    table.remove(standbyparticles, i)
    p:reset()
    p:setParticleLifetime(1)
    p:setBufferSize(16)
    p:setEmissionRate(8)
    p:setSizes(1)
    p:setSizeVariation(0)
    p:setSpread(2*math.pi)
    p:setAreaSpread('none')
    p:setSpeed(0, 0)
    p:setRelativeRotation(false)
    p:setLinearAcceleration(0, 0, 0, 0)
    p:setRadialAcceleration(0, 0)
    p:setTangentialAcceleration(0, 0)
    p:setColors(255, 255, 255, 255)
    p:setEmitterLifetime(1)
    local blend = factories[which] (p, ...)
    p:start()
    local ef = {particle = p, pos = vec2:new{}, blend = blend or 'add'}
    table.insert(effects, ef)
    return ef
  end
end

function factories.blood (p, dir)
  p:reset()
  p:setTexture(sphere)
  p:setParticleLifetime(math.min(1.0, blinglevel), 2)
  p:setEmissionRate(64)
  p:setBufferSize(8)
  p:setSizes(.5,math.log(blinglevel)/10)
  p:setSizeVariation(1)
  p:setDirection(math.atan2(dir.y, dir.x))
  p:setSpread(math.pi/4)
  p:setSpeed(256,256)
  p:setRadialAcceleration(0, 0)
  p:setLinearAcceleration(0, 0, 0, 0)
  p:setColors(120, 0, 0, 255, 0, 0, 0, 0) -- Fade to transparency.
  p:setEmitterLifetime(.5)
  return 'alpha'
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
end

function factories.vortex (p)
  p:reset()
  p:setTexture(sprites.particle1)
  p:setParticleLifetime(.3)
  p:setBufferSize(64)
  p:setEmissionRate(16 + 16*min(blinglevel,3))
  p:setSizes(1, 1+min(blinglevel,3), .5)
  p:setSizeVariation(1)
  p:setSpread(2*math.pi)
  p:setAreaSpread('normal', 2*min(blinglevel,3), 2*min(blinglevel,3))
  p:setSpeed(0, 0)
  p:setLinearAcceleration(0, 0, 0, 0)
  p:setRadialAcceleration(-600, -600)
  p:setTangentialAcceleration(800, 800)
  p:setColors(0, 0, 0, 200)
  p:setEmitterLifetime(-1)
  return 'alpha'
end

function factories.wisps (p)
  p:reset()
  p:setTexture(sphere)
  p:setParticleLifetime(1)
  p:setBufferSize(16)
  p:setEmissionRate(8)
  p:setSizes(.5)
  p:setSizeVariation(0)
  p:setSpread(2*math.pi)
  p:setAreaSpread('uniform', 16*min(blinglevel,2), 16*min(blinglevel,2))
  p:setSpeed(0, 0)
  p:setRelativeRotation(true)
  p:setLinearAcceleration(0, 0, 0, 0)
  p:setRadialAcceleration(-8000)
  p:setTangentialAcceleration(500)
  p:setColors(100, 255, 255, 200)
  p:setEmitterLifetime(-1)
end

function factories.shock (p)
  p:reset()
  p:setTexture(sprites.particle2)
  p:setParticleLifetime(.6)
  p:setEmissionRate(6)
  p:setSizes(2 + min(blinglevel,2)*.5)
  p:setSizeVariation(1)
  p:setSpread(0)
  p:setSpeed(0,0)
  p:setRotation(0, 2*math.pi)
  p:setAreaSpread('normal', 2, 2)
  p:setLinearAcceleration(0, 0, 0, 0)
  p:setColors(100, 100, 255, 200, 255, 255, 255, 0)
  p:setEmitterLifetime(-1)
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
end

function factories.explo (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(1)
  p:setEmissionRate(64)
  p:setBufferSize(16)
  p:setSizes(2, blinglevel^.5)
  p:setSizeVariation(.5)
  p:setSpread(2*math.pi)
  p:setSpeed(32, 64)
  p:setAreaSpread('normal', 2, 2)
  p:setColors(255, 150, 100, 150, 50, 50, 50, 255, 0, 0, 0, 0)
  p:setEmitterLifetime(1)
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
end

function effects.draw (g)
  for i,v in ipairs(effects) do
    g.push()
    g.setBlendMode(v.blend)
    --g.translate(v.pos:unpack())
    v.particle:setPosition((v.pos*64):unpack())
    g.setColor(255, 255, 255, 255)
    g.scale(1/64, 1/64)
    g.draw(v.particle, 0, 0)
    g.setBlendMode 'alpha'
    g.pop()
  end
end

return effects

