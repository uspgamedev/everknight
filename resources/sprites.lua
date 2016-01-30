
local sprites = {}

local img = love.graphics.newImage "assets/sprites.png"
local quads = {}

local newQuad = love.graphics.newQuad

img:setFilter('nearest', 'nearest')

sprites.floor = {
  img = img,
  quad = newQuad(0, 64, 64, 64, img:getDimensions())
}

sprites.wall = {
  img = img,
  quads = {
    newQuad(0, 0, 64, 64, img:getDimensions()),
    newQuad(64, 0, 64, 48, img:getDimensions()),
    newQuad(64, 64, 64, 48, img:getDimensions()),
  }
}

sprites.hero = {
  img = img,
  quads = {
    newQuad(0, 128, 64, 64, img:getDimensions()),
    newQuad(64, 128, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 64}
}

sprites.axe = {
  img = img,
  quads = {
    newQuad(2*64, 3*64, 64, 64, img:getDimensions()),
    newQuad(3*64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 48}
}

sprites.slime = {
  img = img,
  quads = {
    newQuad(0, 3*64, 64, 64, img:getDimensions()),
    newQuad(64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 56}
}

return sprites

