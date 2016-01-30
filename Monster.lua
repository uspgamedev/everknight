
local Monster = require 'lux.class' :new{}

Monster:inherit(require 'Character')

function Monster:instance (obj, spd, kind, color, power)

  self:super(obj, spd)

  local sprite = require 'resources.sprites' [kind]
  local counter = 0

  obj.health = power

  function obj:getpower ()
    return power
  end

  function obj:oncollide(player)
    player:takedamage(power, self:getpos())
  end

  local takedamage = obj.takedamage
  function obj:takedamage(amount, pos)
    takedamage(self)
    self:addpush((self:getpos() - pos):normalized() * 20)
  end

  function obj:update ()
    self:behaviour()
    counter = math.fmod(counter + FRAME, 1)
    if self:isdead() then
      money = money + 10 * blinglevel
      return true
    end
  end

  function obj:behaviour ()
    -- abstract
  end

  function obj:draw (g)
    g.scale(1/64, 1/64)
    local i = (counter < .5) and 1 or 2
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 36, 9, 16)
    g.setColor(COLOR(50, 50, color + (power-1)*70))
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
  end

end

return Monster

