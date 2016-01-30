
local healstuff = {}

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
  -- if tobedeleted then blinglevel = blinglevel * blingfactor end
  return tobedeleted
end

function healstuff:draw (g)
  g.setColor(200, 200, 200, 255)
  g.rectangle('fill', 0, 0, 1, 1)
end

return healstuff
