shop = {
  cheapitem = {
    color = {30, -30}
  },
  expensiveitem = {
    color = {60, -60}
  },
}

local tobedeleted = false

local sprites = require 'resources.sprites'

local cheapitempos, expensiveitempos

local function makeweapon (x)
  x = x or 0
  local base = baseweapons[love.math.random(#baseweapons)]
  local shopweaponname, extra = namegen(base, blinglevel)
  return base, shopweaponname, math.floor(blinglevel+x), extra
end

local LOCK_POS = 1
local VALID_POSITIONS

function shop.cheapitem.load(_, W, H)
  VALID_POSITIONS = {
    vec2:new{W/3 + 1, H/2}, vec2:new{2*W/3 + 1, H/2}
  }
  tobedeleted = false
  shop.cheapitem.price = math.floor(money * 0.8)
  LOCK_POS = love.math.random(#VALID_POSITIONS)
  cheapitempos = VALID_POSITIONS[LOCK_POS]
  shop.cheapitem.weapon = { makeweapon() }
end

function shop.expensiveitem.load(_, W, H)
  shop.expensiveitem.price = math.floor(money * 1.5 + love.math.random(10, 500))
  expensiveitempos = VALID_POSITIONS[3 - LOCK_POS]
  shop.expensiveitem.weapon = { makeweapon(2) }
end

function shop.cheapitem.oncollide()
  tobedeleted = true
end

function shop.expensiveitem.oncollide()
  return
end

function shop.cheapitem.getpos()
  return cheapitempos
end

function shop.expensiveitem.getpos()
  return expensiveitempos
end

function shop.cheapitem.update()
  if tobedeleted then 
    local base, level
    base, weaponname, level, extra = unpack(shop.cheapitem.weapon)
    player:setweapon(base, level, extra)
    blinglevel = blinglevel * blingfactor
    money = money - shop.cheapitem.price
  end
  return tobedeleted
end

function shop.expensiveitem.update()
  return
end

function shop.cheapitem:draw (g)
  g.push()
  local wpn = shop.cheapitem.weapon
  local sprite = sprites[wpn[1]]
  g.setColor(WPNCOLOR(wpn[3]))
  g.scale(1/64, 1/64)
  g.draw(sprite.img, sprite.quads[2], -16, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
  g.setColor(255, 255, 255, 255)
  g.printf("$ "..shop.cheapitem.price, -64, 8, 128, 'center')
  g.pop()
end

function shop.expensiveitem:draw (g)
  g.push()
  local wpn = shop.expensiveitem.weapon
  local sprite = sprites[wpn[1]]
  g.setColor(WPNCOLOR(wpn[3]))
  g.scale(1/64, 1/64)
  g.draw(sprite.img, sprite.quads[2], -16, 0, 0, 1, 1, sprite.hotspot.x, sprite.hotspot.y)
  g.setColor(255, 255, 255, 255)
  g.printf("$ "..shop.expensiveitem.price, -64, 8, 128, 'center')
  g.pop()
end

return shop
