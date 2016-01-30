
local Character = require 'lux.class' :new{}

function Character:instance (obj, spd)

  spd = spd or 2
  local pos = vec2:new{}
  local angle = 0
  local moving = false
  local push = vec2:new{}

  local health = 10
  local damage = 0

  function obj:getpos ()
    return pos:clone()
  end

  function obj:setpos (set)
    pos = set:clone()
  end
  
  function obj:getmove ()
    local move = push + (moving and spd or 0)*vec2:new{ math.cos(angle), math.sin(angle) }
    push = push*0.8
    if math.abs(push.x) < .1 or math.abs(push.y) < .1 then
      push = vec2:new{}
    end
    return move
  end

  function obj:getmoving ()
    return moving
  end

  function obj:setmoving (set)
    moving = set
  end

  function obj:getangle ()
    return angle
  end

  function obj:setangle (set)
    angle = set
  end

  function obj:facedir ()
    return (math.abs(angle) <= math.pi/2) and 'right' or 'left'
  end

  function obj:addpush (add)
    push = push + add
  end

  -----

  function obj:gethealth()
    return self.health - self.damage
  end
  
  function obj:takedamage()
    self.damage = self.damage + 1
    local posx, posy = self.getpos():unpack()
    local dmg = (10 + love.math.random(5,10)) * blinglevel * 15
    table.insert(displaynumbers,newnum(dmg, {posx, posy - 1}))
  end

  function obj:isdead()
    return self.damage >= self.health
  end

  -----

  function obj:load ()
    print("load")
    print (self.health)
    self.health = self.health or health
    print (self.health)
    self.damage = self.damage or damage
    -- behaviour
  end

  function obj:update ()
    -- behaviour
  end

  function obj:draw (g)
    g.setColor(255, 255, 255, 255)
    g.rectangle('fill', .1, .1, .8, .8)
  end

end

return Character

