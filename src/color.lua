
-- Converts HSL to RGB. (input and output range: 0 - 255)
function HSL(h, s, l, a)
  h = math.fmod(h, 256)
  if s<=0 then return l,l,l,a end
  h, s, l = h/256*6, s/255, l/255
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

local base

function RESET_COLOR()
  base = 80
end

function NEXT_COLOR()
  base = math.fmod(base + 70, 255)
end

function COLOR (ds, dl, dh)
  ds = ds or 0
  dl = dl or 0
  dh = dh or 0
  return HSL(base+dh, 30+ds, 80+dl, 255)
end


function WPNCOLOR (wpnlevel)
  return HSL(wpnlevel*40, 40+math.log(wpnlevel)^2, 100+math.log(wpnlevel))
end

