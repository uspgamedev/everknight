
local treasure = {}

local sprite = require 'resources.sprites' .chest
local tobedeleted = false
local pos

treasure.color = {15, 15}

function treasure.oncollide()
  tobedeleted = true
end

function treasure.load(blinglevel, W, H)
  pos = vec2:new{W/2, H/2}
  tobedeleted = false
end

function treasure.getpos()
  return pos
end

function treasure.update()
  if tobedeleted then
    local base = baseweapons[love.math.random(#baseweapons)]
    player:setweapon(base)
    weaponname = namegen(base, blinglevel)
    blinglevel = blinglevel * blingfactor
  end
  return tobedeleted
end

function treasure:draw (g)
  g.scale(1/64, 1/64)
  g.setColor(COLOR(80, 20))
  g.draw(sprite.img, sprite.quad, 0, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
end

return treasure

