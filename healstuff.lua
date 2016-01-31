
local healstuff = {}

local sprite = require 'resources.sprites' .chicken
local tobedeleted = false
local pos

healstuff.color = {15, 15}

function healstuff.oncollide(_, player)
  tobedeleted = true
  print("yay")
  player:heal()
end

function healstuff.load(blinglevel, W, H)
  pos = vec2:new{W/2, H/2}
  tobedeleted = false
end

function healstuff.getpos()
  return pos
end

function healstuff.update()
  return tobedeleted
end

function healstuff:draw (g)
  g.scale(1/64, 1/64)
  g.setColor(HSL(10, 80, 80))
  g.draw(sprite.img, sprite.quad, 0, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
end

return healstuff
