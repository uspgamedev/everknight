gameover = {}

music = require "resources/music"

local silence, playing

function gameover.load ()
  music.gameover:setLooping(true)
  silence = 1.75
  -- music.gameover:play()
  return
end

function gameover.draw ()
    -- local x, y = love.graphics.
  love.graphics.print("YOU DIED", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

function gameover.update()
  silence = silence - FRAME
  if love.keyboard.isDown("return") then
    music.gameover:stop()
    return ("title")
  end
  if silence < 0  and not playing then
    music.gameover:play()
  end
  return
end

return gameover