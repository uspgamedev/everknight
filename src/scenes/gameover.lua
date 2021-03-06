gameover = {}

music = require "resources/music"

local silence, playing

function gameover.load ()
  LOADED = false
  music.gameover:setLooping(true)
  silence = 1.75
  -- music.gameover:play()
  return
end

function gameover.draw ()
  -- local x, y = love.graphics.
  love.graphics.setFont(FONTS[3])
  love.graphics.printf(
    "YOU DIED",
    love.graphics.getWidth()/2,
    love.graphics.getHeight()/2,
    3*64,
    "center",
    0, 1, 1,
    1.5*64, 0
  )
end

function gameover.update()
  silence = silence - FRAME
  if silence < 0  and not playing then
    music.gameover:play()
    if INPUT.confirm then
      music.gameover:stop()
      return ("title")
    end
  end
  return
end

return gameover
