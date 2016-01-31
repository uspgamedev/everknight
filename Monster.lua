
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

  function obj:ondamage (power, pos)
    local dmg = (10 + love.math.random(5,10)) * blinglevel * 15
    local posx, posy = self.getpos():unpack()
    love.audio.play(SOUNDS.hit)
    for i=1,math.floor(blinglevel) do
      local ef = EFFECTS.new 'blood'
      if ef then
        ef.pos = self:getpos()*3/4 + pos/4 + vec2:new{0,-1}
                 + 1*vec2:new{love.math.random(), love.math.random()}
      end
    end
    table.insert(displaynumbers,newnum(dmg, {posx, posy - 1}))
  end

  function obj:onhit(amount, pos)
    self:addpush((self:getpos() - pos):normalized() * 20)
  end

  function obj:onupdate ()
    self:behaviour()
    counter = math.fmod(counter + FRAME, 1)
    if self:isdead() then
      love.audio.play(SOUNDS.die)
      money = money + 10 * blinglevel
      SOMEBLING()
      TIMERS.gotmoney = 60
      return true
    end
  end

  function obj:behaviour ()
    -- abstract
  end

  function obj:draw (g)
    g.scale(1/64, 1/64)
    local i = (counter < .5) and 1 or 2
    local sx = (self:facedir() == 'right') and 1 or -1
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 36, 9, 16)
    g.setColor(COLOR(50, 50 + self:getinvincible()*70, color + (power-1)*70))
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, sx, 1, sprite.hotspot.x, sprite.hotspot.y)
  end

end

return Monster

