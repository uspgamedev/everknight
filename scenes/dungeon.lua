
local dungeon = {}

local W, H = 16, 12

local map

function dungeon.load ()
  map = {}
  for i=1,H do
    map[i] = {}
    for j=1,W do
      if love.math.random() > .9 then
        map[i][j] = 'WALL'
      else
        map[i][j] = 'FLOOR'
      end
    end
  end
end

function dungeon.update (dt)
  
end

function dungeon.draw ()
  local g = love.graphics
  g.push()
  g.scale(64, 64)
  for i,row in ipairs(map) do
    for j,tile in ipairs(row) do
      g.push()
      g.setColor(255, 255, 255)
      g.translate(j-1, i-1)
      if tile == 'WALL' then
        g.setColor(80, 150, 100)
        g.rectangle('fill', 0, -.5, 1, 1)
        g.setColor(60, 120, 80)
        g.rectangle('fill', 0, .5, 1, 1)
      elseif tile == 'FLOOR' then
        g.setColor(20, 100, 180)
        g.rectangle('fill', 0, 0, 1, 1)
      end
      g.pop()
    end
  end
  g.pop()
end

return dungeon

