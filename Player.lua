
require 'color'
local sprites = require 'resources.sprites'

local Player = require 'lux.class' :new{}

local DIRS = {
  up = vec2:new{0,-1},
  down = vec2:new{0,1},
  left = vec2:new{-1,0},
  right = vec2:new{1,0}
}

local invincible

-- local damage = 0

Player:inherit(require 'Character')

local function toangle(v)
  return math.atan2(v[2], v[1])
end

function Player:instance (obj)

  self:super(obj, 3)

  local weapon = 'axe'
  local counter = 0
  local tick = 0
  local atkdelay = 0
  local attacking = 0

  function obj:takedamage (power, pos)
    -- print("yo")
    if not invincible then
      print("ouch")
      -- print("")
      obj.damage = obj.damage + 1
      -- damage = damage + 1
      invincible = 1
    end
    self:addpush((self:getpos() - pos):normalized() * 20)
  end

  function obj:heal()
    obj.damage = 0
  end

  function obj:update ()
    if invincible then
      invincible = invincible - FRAME
      if invincible <= 0 then
        invincible = nil
      end
    end
    local sum = vec2:new{}
    self:setmoving(false)
    for key,dir in pairs(DIRS) do
      if love.keyboard.isDown(key) then
        sum = sum + dir
        self:setmoving(true)
      end
    end
    if self:getmoving() then
      counter = math.fmod(counter + FRAME, 0.6)
    else
      counter = 0
    end
    if sum*sum > 0 then
      self:setangle(toangle(sum))
    else
      self:setangle(self:facedir() == 'right' and 0 or math.pi)
    end
    tick = math.fmod(tick + FRAME, 1)
    if love.keyboard.isDown 'z' and atkdelay <= 0 then
      attacking = 10
      atkdelay = 20
    end
    atkdelay = math.max(atkdelay - 1, 0)
    attacking = math.max(attacking - 1, 0)
  end

  function obj:attacking ()
    return attacking > 0
  end

  function obj:reach (other)
    local diff = other:getpos() - self:getpos()
    local dist = diff:size()
    local angle = math.atan2(diff.y, diff.x)
    return dist < 1 and
          (self:facedir() == 'right' and math.abs(angle) < math.pi/4) or
          (self:facedir() == 'left' and math.abs(angle) > 3*math.pi/4)
  end

  function obj:draw (g)
    local i = (not self:getmoving() or counter > .3) and 1 or 2
    -- shadow
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 16, 4, 16)
    -- avatar
    g.setColor(HSL(20, 80, 80 + (invincible and 50 or 0), 255))
    local sx = (self:facedir() == 'right') and 1 or -1
    local sprite = sprites.hero
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, sx, 1, sprite.hotspot.x, sprite.hotspot.y)
    -- weapon
    local wpnsprite = sprites[weapon]
    if attacking > 0 then
      g.draw(wpnsprite.img, wpnsprite.quads[2], sx*32, -48, 0, sx*1, 1,
             wpnsprite.hotspot.x, wpnsprite.hotspot.y)
      g.setColor(255, 255, 255, 255*attacking/10)
      g.rectangle('fill', 32*sx, -48, sx*24, 64)
    else
      local dy = 4*math.sin(tick * 2 * math.pi)
      g.draw(wpnsprite.img, wpnsprite.quads[1], sx*32, -16 + dy, 0, 1, 1,
             wpnsprite.hotspot.x, wpnsprite.hotspot.y)
    end
  end

end

return Player

