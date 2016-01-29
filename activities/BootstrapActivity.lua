
local BootstrapActivity = class:new{}

BootstrapActivity:inherit(require 'Activity')

function BootstrapActivity:instance (obj, ...)
  
  self:super(obj)

  function obj.__accept:Load (engine)
    -- Start here
  end

end

return BootstrapActivity
