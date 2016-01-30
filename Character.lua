
local Character = require 'lux.class' :new{}

function Character:instance (obj, spd)

  spd = spd or 2
  local pos = vec2:new{}
  local angle = 0
  local moving = false

  local health = 10
  local damage = 0

  function obj:getpos ()
    return pos:clone()
  end

  function obj:setpos (set)
    pos = set:clone()
  end
  
  function obj:getmove ()
    return (moving and spd or 0)*vec2:new{ math.cos(angle), math.sin(angle) }
  end

  function obj:setmoving (set)
    moving = set
  end

  function obj:setangle (set)
    angle = set
  end

  function obj:gethealth()
    return health - damage
  end
  
  function obj:takedamage()
    damage = damage + 1
  end

  function obj:isdead()
    return damage >= health
  end

  function obj:load ()
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

