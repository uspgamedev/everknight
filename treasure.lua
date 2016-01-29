local treasure = {}

local tobedeleted = false
local pos

treasure.color = {15, 15}

function treasure.oncollide()
  tobedeleted = true
end

function treasure.load(blinglevel, W, H)
  pos = vec2:new{W/2, H/2}
end

function treasure.getpos()
  return pos
end

function treasure.update()
  if tobedeleted then blinglevel = blinglevel * blingfactor end
  return tobedeleted
end

return treasure