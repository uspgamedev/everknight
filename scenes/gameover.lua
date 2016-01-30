gameover = {}

function gameover.load ()
  return
end

function gameover.draw ()
    -- local x, y = love.graphics.
  love.graphics.print("YOU DIED", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

function gameover.update()
  if love.keyboard.isDown("return") then
    -- print("asd")
    return ("title")
  end
  return
end

return gameover