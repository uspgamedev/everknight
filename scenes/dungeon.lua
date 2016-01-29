
local player = require 'player'

local dungeon = {}

local W, H = 16, 12

local map

-- local rooms = require "rooms"

local roomexits = {'E','S','W','N','N','E'}
local roomentries = {'W','W','N','E','E','S'}
local roomnumber = 1

function dungeon.load ()
  map = {}
  for i=1,H do
    map[i] = {}
    for j=1,W do
      if (roomexits[roomnumber] == 'E' and ((i == H/2 or i == H/2+1) and j == W)) or
         (roomexits[roomnumber] == 'W' and ((i == H/2 or i == H/2+1) and j == 1)) or
         (roomexits[roomnumber] == 'S' and ((j == W/2 or j == W/2+1) and i == H)) or
         (roomexits[roomnumber] == 'N' and ((j == W/2 or j == W/2+1) and i == 1)) then
        map[i][j] = 'FLOOR'
      elseif (roomentries[roomnumber] == 'E' and ((i == H/2 or i == H/2+1) and j == W)) or
             (roomentries[roomnumber] == 'W' and ((i == H/2 or i == H/2+1) and j == 1)) or
             (roomentries[roomnumber] == 'S' and ((j == W/2 or j == W/2+1) and i == H)) or
             (roomentries[roomnumber] == 'N' and ((j == W/2 or j == W/2+1) and i == 1)) then
        map[i][j] = 'DOOR'
      elseif
       --love.math.random() > .9 or
       i == 1 or j == 1 or i == H or j == W then
        map[i][j] = 'WALL'
      else
        map[i][j] = 'FLOOR'
      end
    end
  end
  player.clear()
  player.setpos(vec2:new{2,2})
end

function dungeon.update (dt)
  player.update(dt)
end

function dungeon.draw ()
  local g = love.graphics
  g.push()
  g.scale(64, 64)
  g.translate(-1, -1)
  for i,row in ipairs(map) do
    for j,tile in ipairs(row) do
      g.push()
      g.setColor(255, 255, 255)
      g.translate(j, i)
      if tile == 'WALL' then
        g.setColor(80, 150, 100)
        g.rectangle('fill', 0, -.5, 1, 1)
        g.setColor(60, 120, 80)
        g.rectangle('fill', 0, .5, 1, 1)
      elseif tile == 'DOOR' then
        g.setColor(20, 90, 40)
        g.rectangle('fill', 0, -.5, 1, 1)
        g.setColor(0, 60, 20)
        g.rectangle('fill', 0, .5, 1, 1)
      elseif tile == 'FLOOR' then
        g.setColor(20, 100, 180)
        g.rectangle('fill', 0, 0, 1, 1)
      end
      g.pop()
    end
  end
  do -- draw player
    g.push()
    g.translate(player.getpos():unpack())
    g.setColor(150, 100, 80)
    g.circle('fill', .5, .5, .4, 16)
    g.pop()
  end
  g.pop()
end

return dungeon

