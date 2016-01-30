
local sprites = {}

local img = love.graphics.newImage "assets/sprites.png"
local quads = {}

img:setFilter('nearest', 'nearest')

sprites.hero = {
  img = img,
  quad = love.graphics.newQuad(0, 128, 64, 64, img:getDimensions()),
  hotspot = vec2:new{32, 64}
}

return sprites

