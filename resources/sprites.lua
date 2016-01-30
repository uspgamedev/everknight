
local sprites = {}

local img = love.graphics.newImage "assets/sprites.png"
local quads = {}

img:setFilter('nearest', 'nearest')

sprites.floor = {
  img = img,
  quad = love.graphics.newQuad(0, 64, 64, 64, img:getDimensions())
}

sprites.hero = {
  img = img,
  quads = {
    love.graphics.newQuad(0, 128, 64, 64, img:getDimensions()),
    love.graphics.newQuad(64, 128, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 64}
}

sprites.slime = {
  img = img,
  quads = {
    love.graphics.newQuad(0, 3*64, 64, 64, img:getDimensions()),
    love.graphics.newQuad(64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 48}
}

return sprites

