local treasure = {}

local tobedeleted = false

function treasure.oncollide()
  blinglevel = blinglevel * blingfactor
  tobedeleted = true
end

function treasure.load(blinglevel)

end

function treasure.update()
  return tobedeleted
end

return treasure