title = {}

function title.load ()
  return
end

function title.draw ()
    -- local x, y = love.graphics.
  love.graphics.setFont(FONTS[4])
  love.graphics.print("PRESS ENTER", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end

function title.update()
  if love.keyboard.isDown("return") then
    -- print("asd")
    return ("dungeon")
  end
  return
end

return title
