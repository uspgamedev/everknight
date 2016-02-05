
local sprites
local fragments = {}

local yield = coroutine.yield
local rand = love.math.random
local shader

local function fragment_routine (self, pos, move, level)
  -- Personal delay
  for i=1,self.delay do yield() end
  do -- init
    self.pos = pos:clone()
    local dir = rand()*math.pi*2
    self.target = pos + (1+self.power/3)*vec2:new{math.cos(dir), math.sin(dir)}
    dir = dir + math.pi/3
    move = move:normalized()/10
    self.spd = move + .05*vec2:new{math.cos(dir), math.sin(dir)}
  end
  -- Follow target
  for i=(60+rand(math.log(level))),1,-1 do
    if i < 40 then
      self.target = self.target + (player:getpos() - self.target)/i
    end
    local dist = (self.target - self.pos)
    local len = dist:size()
    self.spd = self.spd + .02*dist/math.max(.01,len)
    self.pos = self.pos + self.spd
    yield()
  end
  for i=30,1,-1 do
    local accel = (player:getpos() - self.pos - self.spd*i)/i^2
    self.spd = self.spd + accel
    self.pos = self.pos + self.spd
    yield()
  end
  BLINGFRAG(self.bling)
  return true
end

function fragments.load ()
  sprites = require 'resources.sprites'
  if not shader then
    shader = love.graphics.newShader [[
      vec4 effect(vec4 color, Image tex, vec2 vtx, vec2 pos) {
        float dist = distance(vtx, vec2(.5, .5));
        float alpha = step(.5, 1.f-dist)*.5f;
        float flag = smoothstep(.55, .5, 1.f-dist);
        float value = flag*(.7f - dist) + (1.f-flag)*1.f;
        return color*vec4(value, value, value, alpha);
      }
    ]]
  end
end

function fragments.new (pos, move, level)
  level = math.max(3, math.floor(level))
  local power = 1
  while level > 0 do
    local n = level%10
    for i=1,n do
      local fragment = {
        routine = coroutine.wrap(fragment_routine),
        power = power,
        bling = power/level,
        delay = rand(15)
      }
      fragment:routine(pos, move, power)
      table.insert(fragments, fragment)
    end
    power = power + 1
    level = math.floor(level/10)
  end
end

function fragments.update ()
  for i=#fragments,1,-1 do
    if fragments[i].routine () then
      table.remove(fragments, i)
    end
  end
end

function fragments.draw (g)
  local sphere = sprites.sphere
  g.setShader(shader)
  for _,fragment in ipairs(fragments) do
    if fragment.pos then
      g.push()
      g.translate(fragment.pos:unpack())
      g.scale(1/64, 1/64)
      local scale = math.sqrt(fragment.power)
      g.setColor(HSL(50 + fragment.power*80, 200, 200))
      g.draw(sphere.img, 0, 0, 0, scale, scale,
                                  sphere.hotspot.x, sphere.hotspot.y)
      g.pop()
    end
  end
  g.setShader()
  g.setColor(255, 255, 255, 255)
end

return fragments

