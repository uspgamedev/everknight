
local Slime = require 'lux.class' :new{}

Slime:inherit(require 'Character')

function Slime:instance (obj, power)

  self:super(obj, 1)

  local sprite = require 'resources.sprites' .slime
  local counter = 0

  obj.health = power

  function obj:getpower ()
    return power
  end

  function obj:oncollide(player)
    player:takedamage()
    obj:takedamage()
  end

  function obj:update ()
    self:setangle(math.random()*math.pi*2)
    self:setmoving(true)
    counter = math.fmod(counter + FRAME, 1)
    return self:isdead()
  end

  function obj:draw (g)
    g.scale(1/64, 1/64)
    local i = (counter < .5) and 1 or 2
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
  end

end

return Slime

