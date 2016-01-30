
local player = require 'player'

local dungeon = {}

local W, H = 16, 10

local map

blinglevel = 1
blingfactor = 1.2

-- local rooms = require "rooms"

-- local room = require "room"

local treasure = require "treasure"

local roomexits = {'E','S','W','W','N','E'}
local roomentries = {'W','W','N','E','E','S'}
local roomnumber = 1
local playerstartingpos = {}
playerstartingpos['W'] = {2, H/2}
playerstartingpos['E'] = {W-1, H/2}
playerstartingpos['N'] = {W/2, 2}
playerstartingpos['S'] = {W/2, H-1}

roomobjects = {
  {},
  {},
  {treasure},
  {},
  {},
  {},
}

local activeobjects = {}

local function updateroom()
    for i=1,H do
    map[i] = {}
    for j=1,W do
      if (roomexits[roomnumber] == 'E' and ((i == H/2 or i == H/2+1) and j == W)) or
         (roomexits[roomnumber] == 'W' and ((i == H/2 or i == H/2+1) and j == 1)) or
         (roomexits[roomnumber] == 'S' and ((j == W/2 or j == W/2+1) and i == H)) or
         (roomexits[roomnumber] == 'N' and ((j == W/2 or j == W/2+1) and i == 1)) then
        map[i][j] = 'FLOOR'
      elseif (roomentries[roomnumber] == 'E' and ((i == H/2 or i == H/2+1) and j == W)) or
             (roomentries[roomnumber] == 'W' and ((i == H/2 or i == H/2+1) and j == 1)) then
        map[i][j] = 'DOOR'
      elseif
             (roomentries[roomnumber] == 'S' and ((j == W/2 or j == W/2+1) and i == H)) or
             (roomentries[roomnumber] == 'N' and ((j == W/2 or j == W/2+1) and i == 1)) then
        map[i][j] = 'HDOOR'
      elseif
       --love.math.random() > .9 or
       i == 1 or j == 1 or i == H or j == W then
        map[i][j] = 'WALL'
      else
        map[i][j] = 'FLOOR'
      end
    end
  end
end

function dungeon.load ()
  map = {}
  updateroom()
  player.clear()
  player.setpos(vec2:new{2,H/2})
end

function dungeon.update ()

  local todelete = {}

  player.update()
  do -- check collision
    local pos = player.getpos() + FRAME*player.getmove()
    local j, i = pos:unpack()
    if not map[math.floor(i)] or not map[math.floor(i)][math.floor(j)] or map[math.floor(i)][math.floor(j)] == 'FLOOR' then
      player.setpos(pos)
    end
  end
  local playerpos = player.getpos()

  ----
  --CHECK COLLISION HERE
  ----
  -- e chama obj.oncollision plz

  for i,obj in ipairs(activeobjects) do
    todelete[i] = obj.update()
  end

  for i = #activeobjects,1,-1 do
    if todelete[i] then
      activeobjects[i] = nil
    end
  end

  --REMINDER: ULTIMA COISA A ACONTECER KTHXBYE
  if playerpos[1] < 0 or playerpos[2] < 0 or
    playerpos[1] > W + 1 or playerpos[2] > H + 1 then
    roomnumber = roomnumber + 1
    if roomnumber > #roomexits then
      roomnumber = 1
      blinglevel = blinglevel * blingfactor
    end
    for i = #activeobjects,1,-1 do
      activeobjects[i] = nil
    end
    for _,obj in ipairs(roomobjects[roomnumber]) do
      table.insert(activeobjects, obj)
      obj.load()
    end
    updateroom()
    player.setpos(vec2:new(playerstartingpos[roomentries[roomnumber]]))
  end
end

-- Converts HSL to RGB. (input and output range: 0 - 255)
local function HSL(h, s, l, a)
  if s<=0 then return l,l,l,a end
  h, s, l = h/256*6, s/255, l/255
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

local function COLOR (ds, dl)
  ds = ds or 0
  dl = dl or 0
  return HSL(150, 30+ds, 30+dl, 255)
end

local function drawfloor (g)
  g.setColor(COLOR())
  g.rectangle('fill', 0, 0, 1, 1)
end

local function drawwall (g)
  g.setColor(COLOR(80, -5))
  g.rectangle('fill', 0, -.75, 1, 1)
  g.setColor(COLOR(80, -10))
  g.rectangle('fill', 0, .25, 1, .75)
end

local function drawhdoor (g)
  g.setColor(COLOR(-15, -5))
  g.rectangle('fill', 0, -1, 1, .5)
  g.setColor(COLOR(-15, -10))
  g.rectangle('fill', 0, -.50, 1, 1.25)
end

local function drawdoor (g)
  g.setColor(COLOR(-15, -5))
  g.rectangle('fill', .25, -1.25, .5, 1)
  g.setColor(COLOR(-15, -10))
  g.rectangle('fill', .25, -.25, .5, 1.25)
end

local function drawwalls (g, i0, j0, dh, dw)
  for i=i0,i0+dh-1 do
    for j=j0,j0+dw-1 do
      local tile = map[i][j]
      g.push()
      g.translate(j, i)
      if tile == 'WALL' then
        drawwall(g)
      elseif tile == 'DOOR' then
        drawdoor(g)
      elseif tile == 'HDOOR' then
        drawhdoor(g)
      end
      g.pop()
    end
  end
end

function dungeon.draw ()
  local g = love.graphics
  g.push()
  g.scale(64, 64)
  g.translate(-1, 1)
  -- Draw floor
  for i,row in ipairs(map) do
    for j,tile in ipairs(row) do
      g.push()
      g.translate(j, i)
      drawfloor(g)
      g.pop()
    end
  end
  -- Draw top walls
  drawwalls(g, 1, 1, 1, W)
  -- Draw upper side walls
  drawwalls(g, 1, 1, H/2, 1)
  drawwalls(g, 1, W, H/2, 1)
  do -- draw player
    g.push()
    g.translate(player.getpos():unpack())
    g.setColor(150, 100, 80)
    g.circle('fill', 0, 0, .4, 16)
    g.pop()
  end
  -- Draw lower side walls
  drawwalls(g, H/2+1, 1, H/2, 1)
  drawwalls(g, H/2+1, W, H/2, 1)
  -- Draw bottom walls
  drawwalls(g, H, 1, 1, W)
  g.pop()
end

return dungeon

