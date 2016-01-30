
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
  displaynumber.pos[2] = displaynumber.pos[2] - FRAME * 0.8
  -- print("yo", displaynumber.timetolive)
  return displaynumber.timetolive <= 0
end

local function draw(displaynumber, g)
  g.push()
  g.scale(1/64, 1/64)
  g.setFont(FONTS[fontsize[math.min(displaynumber.power, #fontsize)]])
  g.setColor(255, 0, 0)
  g.print(math.floor(displaynumber.value), 0, 0)
  g.pop()
end

local function getpos(displaynumber)
  return displaynumber.pos:clone()
end

local function new(number, pos)
  local displaynumber = {}
  displaynumber.pos = vec2:new(pos)
  displaynumber.value = number
  displaynumber.power = math.max( math.floor(number/500) + 1, 1)
  print (displaynumber.power)
  displaynumber.timetolive = timetolivetable[ math.min(displaynumber.power, #timetolivetable) ]
  print (displaynumber.timetolive)
  -- print(displaynumber.timetolive)
  displaynumber.update = update
  displaynumber.draw = draw
  displaynumber.getpos = getpos
  return displaynumber
end



local displaynumbergenerator = {}

displaynumbergenerator.new = new

return displaynumbergenerator