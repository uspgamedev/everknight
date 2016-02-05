
local Monster = require 'lux.class' :new{}
local fragments = require 'fragments'

Monster:inherit(require 'Character')

local ECHOS = {
  'blood', 'explo'
}

function Monster:instance (obj, spd, kind, color, power)

  self:super(obj, spd)

  local sprite = require 'resources.sprites' [kind]
  local counter = 0

  local echoeffect = 0
  local echodelay = 0
  local echodir

  local dying

  obj.health = power

  function obj:getpower ()
    return power
  end

  function obj:oncollide(player)
    player:takedamage(power, self:getpos())
  end

  function obj:ondamage (power, pos)
    local dmg = (love.math.random(5,10)) * blinglevel * 1.5
    local posx, posy = self.getpos():unpack()
    love.audio.play(SOUNDS.hit)
    echoeffect = 1+math.floor(math.log(blinglevel)/10)
    echodir = pos - self:getpos()
    echodir = echodir:normalized()
    table.insert(displaynumbers,newnum(dmg, {posx, posy - 1}))
  end

  function obj:onhit(amount, pos)
    self:addpush((self:getpos() - pos):normalized() * 20)
  end

  function obj:onupdate ()
    self:behaviour()
    counter = math.fmod(counter + FRAME, 1)
    if echoeffect > 0 then
      if echodelay > 0 then
        echodelay = echodelay - 1
      else
        local range = math.min(#ECHOS, 1+math.floor(blinglevel/10))
        local ef = EFFECTS.new(ECHOS[love.math.random(range)], echodir)
        if ef then
          ef.pos = self:getpos() + vec2:new{0,-.5}
        end
        echoeffect = echoeffect - 1
        echodelay = 5
      end
    else
      echodelay = 0
    end
    if self:isdead() then
      if dying then
        dying = dying - 1
        if dying <= 15 then
          fragments.new(self:getpos():clone(), self:getmove(), power*blinglevel)
          return true
        end
        return dying <= 0
      else
        love.audio.play(SOUNDS.die)
        money = money + 10 * blinglevel
        TIMERS.gotmoney = 60
        dying = 20
      end
    end
  end

  function obj:behaviour ()
    -- abstract
  end

  function obj:draw (g)
    if echoeffect then
      local str = math.min(.2, (.05*echoeffect)^0.5)
      g.translate((2*love.math.random()-1)*str,
                  (2*love.math.random()-1)*str)
    end
    g.scale(1/64, 1/64)
    local i = (counter < .5) and 1 or 2
    local sx = (self:facedir() == 'right') and 1 or -1
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 36, 9, 16)
    local xcolor = { COLOR(50, 50 + self:getinvincible()*70, color + (power-1)*35) }
    xcolor[4] = dying and dying/20*255 or 255
    g.setColor(xcolor)
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, sx, 1, sprite.hotspot.x, sprite.hotspot.y)
  end

end

return Monster

