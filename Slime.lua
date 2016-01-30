
local Slime = require 'lux.class' :new{}

Slime:inherit(require 'Character')

function Slime:instance (obj, power)

  self:super(obj, 1)

  local sprite = require 'resources.sprites' .slime
  local counter = 0
  local dircooldown = 0

  obj.health = power

  function obj:getpower ()
    return power
  end

  function obj:oncollide(player)
    player:takedamage(power, self:getpos())
    --self:takedamage(1, player:getpos())
  end

  local takedamage = obj.takedamage
  function obj:takedamage(amount, pos)
    takedamage(self)
    self:addpush((self:getpos() - pos):normalized() * 20)
  end

  function obj:update ()
    dircooldown = dircooldown - FRAME
    if dircooldown <= 0 then
      self:setangle(love.math.random()*math.pi*2)
      dircooldown = -math.log(1-love.math.random())/2
    end
    self:setmoving(true)
    counter = math.fmod(counter + FRAME, 1)
    if self:isdead() then
      money = money + 10 * blinglevel
      return true
    end
  end

  function obj:draw (g)
    g.scale(1/64, 1/64)
    local i = (counter < .5) and 1 or 2
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 36, 9, 16)
    g.setColor(COLOR(50, 50, -40 + (power-1)*70))
    --g.setColor(HSL(100 + (power-1)*50, 150, 150, 255))
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
  end

end

return Slime

