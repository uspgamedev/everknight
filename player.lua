
local player = {}

local DIRS = {
  up = vec2:new{0,-1},
  down = vec2:new{0,1},
  left = vec2:new{-1,0},
  right = vec2:new{1,0}
}

local SPD = 2

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

function player.update (dt)
  local spd = vec2:new{}
  for key,dir in pairs(DIRS) do
    if love.keyboard.isDown(key) then
      spd = spd + dir
    end
  end
  pos = pos + SPD*spd*dt
end

return player

