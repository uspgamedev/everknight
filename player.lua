
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
local moving

local health = 10
local damage = 0

function player.clear ()
  pos = vec2:new{}
  angle = 0
  spd = 2
end

function player.getpos ()
  return pos:clone()
end

function player.setpos (set)
  pos = set:clone()
end

function player.getmove ()
  return (moving and spd or 0)*vec2:new{ math.cos(angle), math.sin(angle) }
end

function player.gethealth()
  return health - damage
end

function player.takedamage()
  if not invincible then
    damage = damage + 1
    invincible = 3
  end
end

function player.isdead()
  return damage >= health
end

function player.update ()
  if invincible then
    invincible = invincible - FRAME
    if invincible <= 0 then
      invincible = nil
    end
  end
  local sum = vec2:new{}
  moving = false
  for key,dir in pairs(DIRS) do
    if love.keyboard.isDown(key) then
      sum = sum + dir
      moving = true
    end
  end
  angle = math.atan2(sum.y, sum.x)
end

return player

