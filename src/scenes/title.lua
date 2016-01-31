-- title scene

title = {}

music = require "resources/music"
local sprites = require 'resources/sprites'
require 'color'

local change

local second = 1/FRAME
local timer
local timer_limit = 1*second
local entercolor = {255, 255, 255}

function title.load ()
  timer = 0
  change = nil
  music[5]:setLooping(true)
  music[5]:play()
end

function title.draw ()
  -- local x, y = love.graphics.  
  love.graphics.setColor(HSL(50,100,220))
  love.graphics.draw(
    sprites.title.img,
    sprites.title.quad,
    love.graphics.getWidth()/2,
    love.graphics.getHeight()/2,
    0, 1, 1,
    sprites.title.hotspot:unpack()
  )
  love.graphics.setColor(unpack(entercolor))
  love.graphics.setFont(FONTS[2])
  love.graphics.printf(
    "PRESS ENTER",
    love.graphics.getWidth()/2,
    love.graphics.getHeight()/2 + 64,
    3*64,
    "center",
    0, 1, 1,
    1.5*64, 0
  )
end

function title.keypressed (key)
  if key == "return" then
    love.audio.play(SOUNDS.get)
    change = "dungeon"
  end
end

function check()
  if change then
    -- JUICY THING HERE
    timer = timer + 1
    if math.fmod(timer,second/4) > second/8 then
      entercolor = {255,255,255}
    else
      entercolor = {30,140,200}
    end
    -- LOAD GAME
    if timer > timer_limit then
      music[5]:stop()
      return change
    end
  end
end

function title.update ()
  if check() then
    return change
  end
end

return title
