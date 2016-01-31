
local timetolivetable = {
  1,
  1.25,
  1.5,
  2,
}

local fontsize = {
  2,
  2,
  3,
}

local function update(displaynumber)
  if not displaynumber.hugepower then
    displaynumber.pos[2] = displaynumber.pos[2] - FRAME * 0.8
  else 
    displaynumber.blinkdt = displaynumber.blinkdt - FRAME
    if displaynumber.blinkdt <= 0 then
      displaynumber.blinkdt = 0.1
      displaynumber.color, displaynumber.backupcolor = displaynumber.backupcolor, displaynumber.color
    end
  end
  displaynumber.timetolive = displaynumber.timetolive - FRAME
  -- --print("yo", displaynumber.timetolive)
  return displaynumber.timetolive <= 0
end

local function draw(displaynumber, g)
  g.push()
  g.scale(1/64, 1/64)
  g.setFont(FONTS[fontsize[math.min(displaynumber.power, #fontsize)]])
  g.setColor(unpack(displaynumber.color))
  g.print(math.floor(displaynumber.value), 0, 0)
  g.pop()
end

local function getpos(displaynumber)
  return displaynumber.pos:clone()
end

local function new(number, pos, color)
  local displaynumber = {}
  color = color or {255, 0, 0}
  displaynumber.pos = vec2:new(pos)
  displaynumber.value = number
  displaynumber.color = color
  displaynumber.power = math.max( math.floor(number/500) + 1, 1)
  if number > 50000 then
    displaynumber.hugepower = true
    displaynumber.backupcolor = {255,255,255}
    displaynumber.blinkdt = 0.1
  end
  --print (displaynumber.power)
  displaynumber.timetolive = timetolivetable[ math.min(displaynumber.power, #timetolivetable) ]
  --print (displaynumber.timetolive)
  -- --print(displaynumber.timetolive)
  displaynumber.update = update
  displaynumber.draw = draw
  displaynumber.getpos = getpos
  return displaynumber
end



local displaynumbergenerator = {}

displaynumbergenerator.new = new

return displaynumbergenerator