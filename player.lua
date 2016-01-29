
local player = {}

local DIRS = {
  up = vec2:new{0,-1},
  down = vec2:new{0,1},
  left = vec2:new{-1,0},
  right = vec2:new{1,0}
}

local pos
local angle
local spd

function player.clear ()
  pos = vec2:new{}
  angle = 0
  spd = 0
end

function player.getpos ()
  return pos:clone()
end

function player.setpos (set)
  pos = set:clone()
end

function player.getmove ()
  return spd*vec2:new{ math.cos(angle), math.sin(angle) }
end

function player.update ()
  local sum = vec2:new{}
  local moving = false
  for key,dir in pairs(DIRS) do
    if love.keyboard.isDown(key) then
      sum = sum + dir
      moving = true
    end
  end
  angle = math.atan2(sum.y, sum.x)
  spd = moving and 2 or 0
end

return player

