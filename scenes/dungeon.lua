
local dungeon = {}

local W, H = 16, 12

local map

function dungeon.load ()
  map = {}
  for i=1,H do
    map[i] = {}
    for j=1,W do
      map[i][j] = 'FLOOR'
    end
  end
end

function dungeon.update (dt)
  
end

function dungeon.draw ()
  local g = love.graphics
  g.push()
  g.scale(32, 32)
  for i,row in ipairs(map) do
    for j,tile in ipairs(row) do
      g.push()
      g.setColor(255, 255, 255)
      g.translate(j, i)
      if tile == 'FLOOR' then
        g.setColor(200, 100, 180)
        g.rectangle('fill', .1, .1, .8, .8)
      end
      g.pop()
    end
  end
  g.pop()
end

return dungeon

