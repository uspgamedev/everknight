gameover = {}

music = require "resources/music"

function gameover.load ()
  -- music.gameover:setLooping(true)
  -- music.gameover:play()
  return
end

function gameover.draw ()
    -- local x, y = love.graphics.
  love.graphics.print("YOU DIED", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

function gameover.update()
  if love.keyboard.isDown("return") then
    -- music.gameover:stop()
    return ("title")
  end
  return
end

return gameover