
require 'color'
local sprites = require 'resources.sprites'

local Player = require 'lux.class' :new{}

local DIRS = {
  up = vec2:new{0,-1},
  down = vec2:new{0,1},
  left = vec2:new{-1,0},
  right = vec2:new{1,0}
}

-- local damage = 0

local shakedur = {
  0.2,
  0.4,
  0.8,
  1.5,
}

Player:inherit(require 'Character')

local function toangle(v)
  return math.atan2(v[2], v[1])
end

local WPN_OFFSET = {
  left = vec2:new{-.5,-.25},
  right = vec2:new{.5,-.25},
}

function Player:instance (obj)

  self:super(obj, 3)

  local weapon = 'Sword'
  local wpnlevel = 0
  local counter = 0
  local tick = 0
  local atkdelay = 0
  local attacking = 0
  local effects = {}

  function obj:load ()
    self.health = 10
    self.damage = 0
    self.displaylife = math.floor(player:gethealth() * blinglevel * 1.5)
    for _,e in ipairs(effects) do
      e.particle:stop()
      print('particle state', e.particle:isActive())
    end
    effects = {}
  end

  function obj:ondamage (power, pos, healthbefore)
    local oldlife = math.floor(healthbefore * blinglevel * 15)--self.displaylife
    local shakebling = math.min(math.floor(blinglevel/10) + 1, #shakedur)
    self.displaylife = math.floor(player:gethealth() * blinglevel * 15)
    lifediff = oldlife - self.displaylife
    local posx, posy = self.getpos():unpack()
    table.insert(displaynumbers,newnum(lifediff, {posx, posy - 1}))
    screenshake.intensity = blinglevel
    screenshake.duration = shakedur[shakebling]
  end

  function obj:onhit (power, pos)
    love.audio.play(SOUNDS.hurt)
    self:addpush((self:getpos() - pos):normalized() * 20)
  end

  function obj:heal()
    love.audio.play(SOUNDS.heal)
    local oldlife = math.floor(player:gethealth() * blinglevel * 15)
    obj.damage = 0
    self.displaylife = math.floor(player:gethealth() * blinglevel * 15)
    lifediff = self.displaylife - oldlife
    local posx, posy = self.getpos():unpack()
    table.insert(displaynumbers,newnum(lifediff, {posx, posy - 1}, {0, 255, 0}))
  end

  function obj:setweapon (set, bling)
    love.audio.play(SOUNDS.get)
    weapon = set
    wpnlevel = math.floor(bling)
    for _,e in ipairs(effects) do
      e.particle:stop()
    end
    effects = {}
    if wpnlevel >= 2 then
      table.insert(effects, EFFECTS.new 'sparkle')
    end
  end

  function obj:onupdate ()
    local sum = vec2:new{}
    self:setmoving(false)
    for key,dir in pairs(DIRS) do
      if love.keyboard.isDown(key) then
        sum = sum + dir
        self:setmoving(true)
      end
    end
    if self:getmoving() then
      local countercopy = counter
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
      love.audio.play(SOUNDS.slash)
      attacking = 10
      atkdelay = 20
    end
    atkdelay = math.max(atkdelay - 1, 0)
    attacking = math.max(attacking - 1, 0)
    for _,e in ipairs(effects) do
      e.pos = self:getpos() + WPN_OFFSET[self:facedir()] + vec2:new{0,-.2}
    end
  end

  function obj:attacking ()
    return attacking > 0
  end

  function obj:reach (other)
    local diff = other:getpos() - self:getpos()
    local dist = diff:size()
    local angle = math.atan2(diff.y, diff.x)
    if dist < 1.5 then
      if math.abs(self:getangle()) < math.pi/4 then
        return math.abs(angle) < math.pi/4
      elseif math.abs(self:getangle()) > 3*math.pi/4 then
        return math.abs(angle) > 3*math.pi/4
      elseif self:getangle() > 0 then
        return angle > math.pi/4 and angle < 3*math.pi/4
      else
        return angle < -math.pi/4 and angle > -3*math.pi/4
      end
    else
      return false
    end
  end

  local function truncateangle ()
    local angle = obj:getangle()
    if math.abs(angle) < math.pi/4 then
      return math.pi/2
    elseif math.abs(angle) > 3*math.pi/4 then
      return -math.pi/2
    elseif angle > 0 then
      return math.pi  
    else
      return 0
    end
  end

  function obj:draw (g)
    local i = (not self:getmoving() or counter > .3) and 1 or 2
    -- shadow
    g.setColor(0, 0, 0, 50)
    g.ellipse('fill', 0, 0, 16, 4, 16)
    -- avatar
    g.setColor(HSL(20, 100, 120 + self:getinvincible()*100, 255))
    local sx = (self:facedir() == 'right') and 1 or -1
    local sprite = sprites.hero
    g.draw(sprite.img, sprite.quads[i], 0, 0, 0, sx, 1, sprite.hotspot.x, sprite.hotspot.y)
    -- weapon
    local wpnsprite = sprites[weapon]
    if attacking > 0 then
      local slash = sprites.slash
      g.translate(0, -32)
      g.rotate(truncateangle())
      g.setColor(255, 255, 255, 255*attacking/10)
      g.draw(slash.img, slash.quad, 32, -16, 0, 1, 1, slash.hotspot.x, slash.hotspot.y)
      g.setColor(WPNCOLOR(wpnlevel))
      g.draw(wpnsprite.img, wpnsprite.quads[2], 32, -16, 0, 1, 1,
             wpnsprite.hotspot.x, wpnsprite.hotspot.y)
    else
      local dy = 4*math.sin(tick * 2 * math.pi)
      g.setColor(WPNCOLOR(wpnlevel))
      g.draw(wpnsprite.img, wpnsprite.quads[1], sx*32, -16 + dy, 0, 1, 1,
             wpnsprite.hotspot.x, wpnsprite.hotspot.y)
    end
  end

end

return Player

