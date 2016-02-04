
local sprites
local fragments = {}

local yield = coroutine.yield
local rand = love.math.random

local function fragment_routine (self, pos, level)
  self.frags = {}
  for i = 1,math.max(3,level) do
    local dir = rand()*math.pi*2
    self.frags[i] = {
      pos = pos:clone(),
      target = pos + (.7+.5*rand())*vec2:new{math.cos(dir), math.sin(dir)},
      phase = rand()*math.pi*2,
      delay1 = rand(1,10),
      delay2 = rand(1,15),
      t1 = 0, t2 = 0
    }
  end
  yield()
  for i=20,1,-1 do
    for j,frag in ipairs(self.frags) do
      if frag.t1 < frag.delay1 then
        frag.t1 = frag.t1 + 1
      else
        local diff = frag.target - frag.pos
        frag.pos = frag.pos + diff/15
      end
    end
    yield()
  end
  for i=30,1,-1 do
    for j,frag in ipairs(self.frags) do
      if frag.t2 < frag.delay2 then
        frag.t2 = frag.t2 + 1
      else
        local target = player:getpos()
        local diff = (target - frag.pos)
        frag.pos = frag.pos + diff/i
      end
    end
    yield()
  end
  return true
end

function fragments.load ()
  sprites = require 'resources.sprites'
end

function fragments.new (pos, level)
  local fragment = {
    routine = coroutine.wrap(fragment_routine),
  }
  fragment:routine(pos, math.floor(level))
  table.insert(fragments, fragment)
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
  g.setColor(255, 255, 255, 255)
  for _,fragment in ipairs(fragments) do
    for _,frag in ipairs(fragment.frags) do
      g.push()
      g.translate(frag.pos:unpack())
      g.scale(1/64, 1/64)
      g.draw(sphere.img, 0, 0, 0, 1, 1, sphere.hotspot.x, sphere.hotspot.y)
      g.pop()
    end
  end
end

return fragments

