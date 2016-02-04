
local sprites
local fragments = {}

local yield = coroutine.yield

local function fragment_routine (self, pos, level)
  self.frags = {}
  for i = 1,math.max(3,level) do
    self.frags[i] = pos:clone()
  end
  yield()
  for i=1,100 do
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
  fragment:routine(pos,level)
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
  g.push()
  g.setColor(255, 255, 255, 255)
  for _,fragment in ipairs(fragments) do
    for _,frag in ipairs(fragment.frags) do
      g.translate(frag:unpack())
      g.scale(1/64, 1/64)
      g.draw(sphere.img, 0, 0, 0, 1, 1, sphere.hotspot.x, sphere.hotspot.y)
    end
  end
  g.pop()
end

return fragments

