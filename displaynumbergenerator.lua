
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
  displaynumber.timetolive = displaynumber.timetolive - FRAME
  -- print("yo", displaynumber.timetolive)
  return displaynumber.timetolive <= 0
end

local function draw(displaynumber, g)
  g.push()
  g.scale(1/64, 1/64)
  g.setFont(FONTS[fontsize[math.min(displaynumber.power, #fontsize)]])
  g.setColor(255, 0, 0)
  g.print(displaynumber.value, 0, 0)
  g.pop()
end

local function getpos(displaynumber)
  return displaynumber.pos:clone()
end

local function new(number, pos)
  local displaynumber = {}
  displaynumber.pos = vec2:new(pos)
  displaynumber.value = number
  displaynumber.power = math.floor(number/100 + 1)
  displaynumber.timetolive = timetolivetable[ math.min(displaynumber.power, #timetolivetable) ]
  -- print(displaynumber.timetolive)
  displaynumber.update = update
  displaynumber.draw = draw
  displaynumber.getpos = getpos
  return displaynumber
end



local displaynumbergenerator = {}

displaynumbergenerator.new = new

return displaynumbergenerator