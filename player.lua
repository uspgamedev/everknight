
local player = {}

local pos

function player.clear ()
  pos = vec2:new{}
end

function player.getpos ()
  return pos:clone()
end

function player.setpos (set)
  pos = set:clone()
end

return player

