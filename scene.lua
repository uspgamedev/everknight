
local scene = {}
local meta = {}

function meta:__index (key)
  return require('scenes.'..key)
end

return setmetatable(scene, meta)

