title = {}

music = require "resources/music"
local sprites = require 'resources/sprites'
require 'color'

local change

function title.load ()
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
  love.graphics.setColor(255,255,255)
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
    change = "dungeon"
  end
end

function title.update ()
  if change then
    music[5]:stop()
    return change
  end
end

return title
