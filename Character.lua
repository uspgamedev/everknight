
local Character = require 'lux.class' :new{}

function Character:instance (obj, spd)

  spd = spd or 2
  local pos = vec2:new{}
  local angle = 0
  local moving = false

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

  function obj:load ()
    -- behaviour
  end

  function obj:update ()
    -- behaviour
  end

end

return Character

