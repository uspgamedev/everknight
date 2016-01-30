
local Beetle = require 'lux.class' :new{}

Beetle:inherit(require 'Monster')

function Beetle:instance(obj, power)

  self:super(obj, 5, 'beetle', 100, power)

end

return Beetle

