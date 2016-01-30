
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
    newQuad(64, 0, 64, 64, img:getDimensions()),
    newQuad(64, 64, 64+16, 64, img:getDimensions()),
  }
}

sprites.torch = {
  img = img,
  quads = {
    newQuad(3*64, 2*64, 64, 64, img:getDimensions()),
    newQuad(4*64, 2*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{0,32}
}

sprites.hero = {
  img = img,
  quads = {
    newQuad(0, 128, 64, 64, img:getDimensions()),
    newQuad(64, 128, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 64}
}

sprites.Axe = {
  img = img,
  quads = {
    newQuad(2*64, 3*64, 64, 64, img:getDimensions()),
    newQuad(3*64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 48}
}

sprites.Sword = {
  img = img,
  quads = {
    newQuad(6*64, 3*64, 64, 64, img:getDimensions()),
    newQuad(7*64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 48}
}

sprites.Mace = {
  img = img,
  quads = {
    newQuad(4*64, 3*64, 64, 64, img:getDimensions()),
    newQuad(5*64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 48}
}

sprites.slash = {
  img = img,
  quad = newQuad(2*64, 0, 128, 128, img:getDimensions()),
  hotspot = vec2:new{84, 100}
}

sprites.slime = {
  img = img,
  quads = {
    newQuad(0, 3*64, 64, 64, img:getDimensions()),
    newQuad(64, 3*64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 56}
}

sprites.beetle = {
  img = img,
  quads = {
    newQuad(4*64, 64, 64, 64, img:getDimensions()),
    newQuad(5*64, 64, 64, 64, img:getDimensions())
  },
  hotspot = vec2:new{32, 56}
}

sprites.chicken = {
  img = img,
  quad = newQuad(7*64, 64, 64, 64, img:getDimensions()),
  hotspot = vec2:new{32, 48}
}

sprites.chest = {
  img = img,
  quad = newQuad(6*64, 64, 64, 64, img:getDimensions()),
  hotspot = vec2:new{32, 48}
}

sprites.boss = {
  img = img,
  quads = {
    newQuad(0, 256, 128, 128, img:getDimensions()),
    newQuad(128, 256, 128, 128, img:getDimensions())
  },
  hotspot = vec2:new{64, 128}
}

sprites.particle1 = love.graphics.newImage("assets/particle_00.png")
sprites.particle2 = love.graphics.newImage("assets/particle_01.png")
sprites.particle3 = love.graphics.newImage("assets/particle_02.png")

return sprites

