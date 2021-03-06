local Chicken = require 'lux.class' :new{}

Chicken:inherit(require 'Monster')

function Chicken:instance(obj, power)

  self:super(obj, 5, 'boss', 100, power)

  local dircooldown = 1
  local movedur = 0

  function obj:behaviour ()
    if dircooldown > 0 then
      dircooldown = dircooldown - 1
      self:setmoving(true)
      if dircooldown <= 0 then
        posdiff = (player:getpos() - self:getpos()):normalized()
        self:setangle(math.atan2(posdiff[2],posdiff[1]))
        -- self:setangle(love.math.random(0,3)*math.pi/2)
        movedur = love.math.random(10,20)
      end
    elseif movedur > 0 then
      self:setmoving(false)
      movedur = movedur - 1
      if movedur <= 0 then
        dircooldown = love.math.random(60,80)
      end
    end
  end

end

return Chicken
