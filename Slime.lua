
local Slime = require 'lux.class' :new{}

Slime:inherit(require 'Character')

function Slime:instance (obj, power)

  self:super(obj, 1)

  function obj:getpower ()
    return power
  end

  function obj:update ()
    setangle(math.random()*math.pi*2)
    setmoving(true)
  end

end

return Slime

