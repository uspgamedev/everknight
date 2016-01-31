title = {}

music = require "resources/music"

local change

function title.load ()
  change = nil
  music[5]:setLooping(true)
  music[5]:play()
end

function title.draw ()
    -- local x, y = love.graphics.
  love.graphics.setFont(FONTS[4])
  love.graphics.print("PRESS ENTER", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
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
