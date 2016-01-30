
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
  print("standby", #standbyparticles)
  if p then
    table.remove(standbyparticles, i)
    factories[which] (p)
    p:start()
    local ef = {particle = p, pos = vec2:new{}}
    table.insert(effects, ef)
    return ef
  end
end

function factories.blood (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(0.3, math.min(1.0, blinglevel))
  p:setEmissionRate(40)
  p:setSizes(1)
  p:setSizeVariation(1)
  p:setSpread(2*math.pi)
  p:setSpeed(128,128)
  p:setLinearAcceleration(0, 400, 0, 400)
  p:setColors(120, 0, 0, 255, 0, 0, 0, 0) -- Fade to transparency.
  p:setEmitterLifetime(.2)
  p:start()
  -- local posx, posy = self.getpos():unpack()
end

function factories.sparkle (p)
  p:reset()
  p:setTexture(sprites.particle1)
  p:setParticleLifetime(.5, math.log(blinglevel)/3)
  p:setEmissionRate(15)
  p:setSizes(1, 1+math.min(blinglevel,2), .5)
  p:setSizeVariation(1)
  p:setDirection(-math.pi/2)
  p:setSpread(0)
  p:setAreaSpread('normal', 4+blinglevel, 4+blinglevel)
  p:setLinearAcceleration(0, -80, 0, -80)
  p:setColors(255, 255, 255, 255)
  p:setEmitterLifetime(-1)
  p:start()
end

function effects.draw (g)
  for i,v in ipairs(effects) do
    g.push()
    g.translate(v.pos:unpack())
    g.setColor(255, 255, 255, 255)
    g.scale(1/64, 1/64)
    g.draw(v.particle, 0, 0)
    g.pop()
  end
end

return effects

