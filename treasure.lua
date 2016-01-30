
local treasure = {}

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
    weaponname = namegen(baseweapons[math.random(#baseweapons)], blinglevel)
    blinglevel = blinglevel * blingfactor
  end
  return tobedeleted
end

function treasure:draw (g)
  g.setColor(200, 200, 200, 255)
  g.rectangle('fill', 0, 0, 1, 1)
end

return treasure

