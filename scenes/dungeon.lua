
require 'color'
local Player = require 'Player'

local dungeon = {}

local W, H = 16, 10

local map
local player
local sprites

blinglevel = 1
blingfactor = 1.2

local treasure = require "treasure"
local Slime    = require 'Slime'
money = 0
local shop = require "shop"
local healstuff = require "healstuff" --nil --TODO: implementar

local roomexits = {'E','S','W','W','N','E'}
local roomentries = {'W','W','N','E','E','S'}
local roomnumber = 1
local playerstartingpos = {}
playerstartingpos['W'] = {2.5, H/2}
playerstartingpos['E'] = {W-1.5, H/2}
playerstartingpos['N'] = {W/2, 2.5}
playerstartingpos['S'] = {W/2, H-1.5}

roomobjects = {
  {healstuff},
  {},
  {treasure},
  {},
  {shop.cheapitem, shop.expensiveitem},
  {},
}

roommonsters = {
  {},
  {Slime, 1, 1, 1, 1, 2, 2},
  {},
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

  for _,obj in ipairs(roomobjects[roomnumber]) do
    table.insert(activeobjects, obj)
    obj.load(blingfactor, W, H)
  end

  local monster = roommonsters[roomnumber]

  for i = 2,#monster do
    local newmonster = monster[1](monster[i])
    newmonster:setpos(vec2:new{W/2 + i/2, 2 + 6*love.math.random()})
    newmonster:load()
    table.insert(activeobjects, newmonster)
  end
end

function dungeon.load ()
  map = {}
  sprites = require 'resources.sprites'
  roomnumber = 1
  updateroom()
  player = Player()
  player:load()
  player:setpos(vec2:new{2.5,H/2})
end

local function validpos (pos)
  local j, i = pos:unpack()
  i, j = math.floor(i), math.floor(j)
  return not map[i] or not map[i][j] or map[i][j] == 'FLOOR'
end

local function moveobj (obj)
  if not obj.getmove then return end
  local pos = obj:getpos() + FRAME*obj:getmove()
  for k=1,3 do
    if  validpos(pos + vec2:new{.4,0}) and
        validpos(pos + vec2:new{-.4,0}) and
        validpos(pos + vec2:new{0,.4}) and
        validpos(pos + vec2:new{0,-.4}) then
      obj:setpos(pos)
      break
    end
    pos = (pos + obj:getpos())/2
  end
end

local function checkcollision (obj1, obj2)
  local pos1, pos2 = obj1:getpos(), obj2:getpos()
  return (pos1 - pos2):size() < .8
end

-----
-- UPDATE
-----

function dungeon.update ()

  local todelete = {}

  player:update()
  do -- check collision
    moveobj(player)
  end
  local playerpos = player:getpos()

  for i,obj in ipairs(activeobjects) do
    moveobj(obj)
  end

  ----
  --CHECK COLLISION HERE
  ----
  -- e chama obj.oncollide plz
  for _,obj in ipairs(activeobjects) do
    if checkcollision(player, obj) then
      obj.oncollide(obj, player)
    end
  end

  for i,obj in ipairs(activeobjects) do
    todelete[i] = obj:update()
  end

  for i = #activeobjects,1,-1 do
    if todelete[i] then
      table.remove(activeobjects, i)
    end
  end

  if player:isdead() then
    for i = #activeobjects,1,-1 do
      table.remove(activeobjects, i)
    end
    return "gameover"
  end

  --REMINDER: ULTIMA COISA A ACONTECER KTHXBYE
  if playerpos[1] < 1 or playerpos[2] < 1 or
    playerpos[1] > W + 1 or playerpos[2] > H + 1 then
    roomnumber = roomnumber + 1
    if roomnumber > #roomexits then
      roomnumber = 1
      blinglevel = blinglevel * blingfactor
    end
    for i = #activeobjects,1,-1 do
      table.remove(activeobjects, i)
    end
    -- for _,obj in ipairs(roomobjects[roomnumber]) do
    --   table.insert(activeobjects, obj)
    --   obj.load(blingfactor, W, H)
    -- end
    -- local monster = roommonsters[roomnumber]
    -- for i = 2,#monster do
    --   local newmonster = monster[1](monster[i])
    --   newmonster:setpos(vec2:new{W/2 + i/2, 2 + 6*love.math.random()})
    --   table.insert(activeobjects, newmonster)
    -- end
    updateroom()
    player:setpos(vec2:new(playerstartingpos[roomentries[roomnumber]]))
  end
end


----
-- DRAW
----

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

  --draw objects
  for _,obj in ipairs(activeobjects) do
    g.push()
    g.translate(obj:getpos():unpack())
    obj:draw(g)
    g.pop()
  end

  do -- draw player
    g.push()
    g.translate(player:getpos():unpack())
    g.scale(1/64, 1/64)
    player:draw(g)
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

