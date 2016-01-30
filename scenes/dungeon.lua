
require 'color'
local Player = require 'Player'

local dungeon = {}

local W, H = 16, 10

local map
local sprites

local music = require "resources/music"

blinglevel = 1
blingfactor = 1.5
miniblingfactor = 1.5 ^ 0.25

screenshake = {
  intensity = 0,
  duration = 0,
  curshake = 0,
  trx = 0,
  try = 0,
}

local treasure = require "treasure"
local Slime    = require 'Slime'
local Beetle   = require 'Beetle'
local Chicken  = require 'Chicken'
money = 10
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

weaponname = "Sord"

local opposites = {
  ['N'] = 'S',
  ['S'] = 'N',
  ['E'] = 'W',
  ['W'] = 'E',
}

local nextexit, lastexit, lastentry

local directions = {'N','S','E','W'}

baseweapons = {
  "Sword",
  "Axe",
  "Mace",
}

-----
---PARTCTICLESESZ!
-----

namegenerator = require "namegenerator"
namegen = namegenerator.generate

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
  {Slime, 1, 1, 1, 1, 3, 3},
  {},
  {Beetle, 2, 2, 2, 4},
  {},
  {Chicken, 6},
}

displaynumbers = {}
numgenerator = require "displaynumbergenerator"
newnum = numgenerator.new

local activeobjects = {}


local function updateroom()
  if roomnumber == 1 then
    NEXT_COLOR()
  end
  lastentry = opposites[nextexit]
  lastexit = nextexit
  repeat
    nextexit = directions[love.math.random(#directions)]
  until nextexit ~= lastentry
  print ("lastexit, nextexit, lastentry: ", lastexit, nextexit, lastentry)
  for i=1,H do
    map[i] = {}
    for j=1,W do
      if (nextexit == 'E' and ((i == H/2 or i == H/2+1) and j == W)) or
         (nextexit == 'W' and ((i == H/2 or i == H/2+1) and j == 1)) or
         (nextexit == 'S' and ((j == W/2 or j == W/2+1) and i == H)) or
         (nextexit == 'N' and ((j == W/2 or j == W/2+1) and i == 1)) then
        map[i][j] = 'FLOOR'
      elseif (lastentry == 'E' and ((i == H/2 or i == H/2+1) and j == W)) or
             (lastentry == 'W' and ((i == H/2 or i == H/2+1) and j == 1)) then
        map[i][j] = 'DOOR'
      elseif (lastentry == 'S' and ((j == W/2 or j == W/2+1) and i == H)) or
             (lastentry == 'N' and ((j == W/2 or j == W/2+1) and i == 1)) then
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

  map[2][2] = 'TORCH'
  map[2][W-1] = 'TORCH'
  map[H-1][2] = 'TORCH'
  map[H-1][W-1] = 'TORCH'

  for _,obj in ipairs(roomobjects[roomnumber]) do
    table.insert(activeobjects, obj)
    obj.load(blingfactor, W, H)
  end

  local monster = roommonsters[roomnumber]

  for i = 2,#monster do
    local newmonster = monster[1](monster[i])
    newmonster:setpos(vec2:new{W/2 + -4 + 8*love.math.random(),
                               H/2 + -1 + 6*love.math.random()})
    newmonster:load()
    table.insert(activeobjects, newmonster)
  end
  player:setpos(vec2:new(playerstartingpos[lastentry]))
end

local function changemusic(nextmusic)
  nextmusic = nextmusic or love.math.random(#music)
  if nextmusic == curmusic then return end
  music[curmusic]:stop()
  music[nextmusic]:setLooping(true)
  music[nextmusic]:play()
  curmusic = nextmusic
end

function dungeon.load ()
  curmusic = 2
  music[curmusic]:setLooping(true)
  music[curmusic]:play()
  RESET_COLOR()
  map = {}
  sprites = require 'resources.sprites'
  blinglevel = 1
  roomnumber = 1
  lastexit = 'E'
  nextexit = 'E'
  print ("YO", lastexit)
  screenshake = {
    intensity = 0,
    duration = 0,
    curshake = 0,
    trx = 0,
    try = 0,
  }
  displaynumbers = {}
  money = 10
  EFFECTS.reset()
  if not player then
    player = Player()
  end
  player:load()
  player:setpos(vec2:new{2.5,H/2})
  updateroom()
  weaponname = "Sord"
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
    if  validpos(pos + vec2:new{.3,.3}) and
        validpos(pos + vec2:new{-.3,.3}) and
        validpos(pos + vec2:new{.3,-.3}) and
        validpos(pos + vec2:new{-.3,-.3}) then
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
  if player:attacking() then
    for _,obj in ipairs(activeobjects) do
      if player:reach(obj) and obj.takedamage then
        obj:takedamage(1, player:getpos())
      end
    end
  end


  EFFECTS.update()

  ---objects
  todelete = {}

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
    music[curmusic]:stop()
    return "gameover"
  end

  screenshake.duration = screenshake.duration - FRAME
  screenshake.curshake = screenshake.curshake - FRAME

  if screenshake.curshake <= 0 and screenshake.duration > 0 then
    screenshake.curshake = 0.05
    screenshake.try = (2 * (love.math.random() - 0.5) ) *math.max(math.min(screenshake.intensity * 16, 64), -64) * math.min(screenshake.duration, 1)
    screenshake.trx = (2 * (love.math.random() - 0.5) ) *math.max(math.min(screenshake.intensity * 16, 64), -64) * math.min(screenshake.duration, 1)
  end

  todelete = {}

  for i,num in ipairs(displaynumbers) do
    todelete[i] = num:update()
  end

  for i = #displaynumbers,1,-1 do
    if todelete[i] then
      table.remove(displaynumbers, i)
    end
  end

  money = math.floor(money)

  --REMINDER: ULTIMA COISA A ACONTECER KTHXBYE
  if playerpos[1] < 1 or playerpos[2] < 1 or
    playerpos[1] > W + 1 or playerpos[2] > H + 1 then
    EFFECTS.reset()
    -- if #roommonsters[roomnumber] > 0 and
    --   #activeobjects == 0 then
    --   blinglevel = blinglevel * blingfactor
    -- end
    roomnumber = roomnumber + 1
    if roomnumber == #roomexits then
      changemusic("boss")
    end
    if roomnumber > #roomexits then
      changemusic()
      roomnumber = 1
      -- blinglevel = blinglevel * blingfactor
    end
    for i = #activeobjects,1,-1 do
      table.remove(activeobjects, i)
    end
    updateroom()
    -- player:setpos(vec2:new(playerstartingpos[lastentry]))
  end
end

function dungeon.keypressed (key)
  if key == 'q' then
    blinglevel = blinglevel * blingfactor
  elseif key == 'w' then
    local base = baseweapons[love.math.random(#baseweapons)]
    weaponname, extra = namegen(base, blinglevel)
    player:setweapon(base, blinglevel, extra)
  end
end


----
-- DRAW
----

local function drawfloor (g)
  local floor = sprites.floor
  g.setColor(COLOR(-15, 40, 128))
  g.scale(1/64, 1/64)
  g.draw(floor.img, floor.quad, 0, 0)
end

local function drawtorch (g, i, j)
  local torch = sprites.torch
  g.setColor(COLOR(60, 30))
  g.scale(1/64, 1/64)
  g.draw(torch.img, torch.quads[love.math.random(1,2)], 0, 0, 0, 1, 1,
         torch.hotspot.x, torch.hotspot.y)
end

local function drawwall (g, i, j)
  local wall = sprites.wall
  g.setColor(COLOR(20, 60))
  g.scale(1/64, 1/64)
  g.draw(wall.img, wall.quads[2], 0, 0)
  g.draw(wall.img, wall.quads[1], 0, -48)
  if i == H and (j == 1 or j == W) then
    g.draw(wall.img, wall.quads[3], j == 1 and 64 or 0, 0, 0, j == 1 and -1 or 1, 1)
  end
end

local function drawhdoor (g, i, j)
  local door = sprites.hdoor
  g.scale(1/64, 1/64)
  g.setColor(COLOR(-15, -5))
  g.draw(door.img, door.quads[j <= W/2 and 1 or 2], 0, -64)
end

local function drawdoor (g, i, j)
  local door = sprites.vdoor
  g.scale(1/64, 1/64)
  g.setColor(COLOR(-15, -5))
  g.draw(door.img, door.quads[i <= H/2 and 1 or 2], 0, -64)
end

local function drawwalls (g, i0, j0, dh, dw)
  for i=i0,i0+dh-1 do
    for j=j0,j0+dw-1 do
      local tile = map[i][j]
      g.push()
      g.translate(j, i)
      if tile == 'WALL' then
        drawwall(g, i, j)
      elseif tile == 'DOOR' then
        drawdoor(g, i, j)
      elseif tile == 'TORCH' then
        drawtorch(g)
      elseif tile == 'HDOOR' then
        drawhdoor(g, i, j)
      end
      g.pop()
    end
  end
end

local function drawicon (g, which, i, j)
  local sprite = sprites[which]
  g.push()
  g.translate(j-1, i-1)
  g.scale(1/32, 1/32)
  g.setColor(sprite.color)
  g.draw(sprite.img, sprite.quad, 0, 0)
  g.pop()
end

local function drawtext (g, i, j, w, fmt, ...)
  g.push()
  g.translate(j-1, i-1)
  g.scale(1/32, 1/32)
  g.setColor(255, 255, 255, 255)
  g.setFont(FONTS[2])
  g.printf(fmt:format(...), 0, 12, w, 'left')
  g.pop()
end

local function drawhud(g)
  drawicon(g, 'life', 1, 1)
  drawicon(g, 'coin', 2, 1)
  drawicon(g, 'swordicon', 1, 14)
  drawicon(g, 'atk', 2, 14)
  drawicon(g, 'def', 2, 24)
  drawtext(g, 1, 2, 5*64, "%d/%d",
           math.floor(player:gethealth() * blinglevel * 15), blinglevel*15*10)
  drawtext(g, 1, 15, 5*64, "%s",
           weaponname)
  drawtext(g, 2, 15, 5*64, "%d",
           math.floor(10 * blinglevel))
  drawtext(g, 2, 25, 5*64, "%d",
           math.floor(8 * blinglevel))
  drawtext(g, 2, 2, 5*64, "%d G",
           math.floor(money))
  --g.push()
  --  g.translate(1, -1)
  --  g.setColor(255, 255, 255)
  --  g.scale(1/64, 1/64)
  --  g.setFont(FONTS[2])
  --  g.print("HP: "..math.floor(player:gethealth() * blinglevel * 15) .. "/" ..
  --          math.floor(10 * blinglevel * 15), 0, 0)
  --  g.print("ATTACK: "..math.floor(blinglevel*10).." DEFENSE: "..math.floor(blinglevel * 8), 0, 16)
  --  g.print("WEAPON: "..weaponname, 0, 32)
  --  g.print("MONEY: "..money.."G", 0, 48)
  --g.pop()
end

local function drawnum(g)
  for _, num in ipairs(displaynumbers) do
    -- print("NUM")
    g.push()
    g.translate(num:getpos():unpack())
    num:draw(g)
    g.pop()
  end
end

function dungeon.draw ()
  local g = love.graphics
  g.push()
  g.scale(64, 64)
  g.translate(-1, 1)
  if screenshake.duration > 0  then
    g.scale(1/64, 1/64)
    g.translate(screenshake.trx, screenshake.try)
    g.scale(64, 64) 
  -- else 
    -- print ("ohnoes") 
  end
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
  drawwalls(g, 2, 2, 1, 1)
  drawwalls(g, 2, W-1, 1, 1)
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

  --PARTICLESES
  EFFECTS.draw(g)
  
  -- Draw lower side walls
  drawwalls(g, H/2+1, 1, H/2, 1)
  drawwalls(g, H/2+1, W, H/2, 1)
  -- Draw bottom walls
  drawwalls(g, H-1, 2, 1, 1)
  drawwalls(g, H-1, W-1, 1, 1)
  drawwalls(g, H, 1, 1, W)

  --draw numbers
  drawnum(g)
  g.pop()

    --draw hud
  g.push()
  g.scale(32, 32)
  g.translate(0, .5)
  drawhud(g)
  g.pop()
  g.setColor(255, 255, 255, 255)
end

return dungeon

