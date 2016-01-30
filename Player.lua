
require 'color'

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

  local sprite = require 'resources.sprites' .hero
  local counter = 0

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
  end

  function obj:draw (g)
    local i = (not self:getmoving() or counter > .3) and 1 or 2
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 16, 4, 16)
    g.setColor(HSL(20, 80, 80 + (invincible and 50 or 0), 255))
    local sx = (self:facedir() == 'right') and 1 or -1
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, sx, 1, sprite.hotspot.x, sprite.hotspot.y)
  end

end

return Player

