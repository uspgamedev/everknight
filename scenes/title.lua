title = {}

local change

function title.load ()
  change = nil
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
    return change
  end
end

return title
