
local Slime = require 'lux.class' :new{}

Slime:inherit(require 'Monster')

function Slime:instance (obj, power)

  self:super(obj, 1, 'slime', -40, power)

  local dircooldown = 0

  function obj:behaviour ()
    dircooldown = dircooldown - FRAME
    if dircooldown <= 0 then
      self:setangle(love.math.random()*math.pi*2)
      dircooldown = -math.log(1-love.math.random())/2
    end
    self:setmoving(true)
  end

end

return Slime

