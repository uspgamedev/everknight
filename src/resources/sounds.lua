local sfx = {}

local function poliphonic (path, num, vol)
  vol = vol or 1
  local sound = {}
  for i=1,num do
    sound[i] = love.audio.newSource(path, "static")
    sound[i]:setVolume(vol)
  end
  local nextidx = 1
  function sound:play ()
    sound[nextidx]:play()
    nextidx = (nextidx % num) + 1
  end
  return sound
end

sfx.slash = love.audio.newSource("assets/Slash.wav", "static")
sfx.hurt = love.audio.newSource("assets/Hurt.wav", "static")
sfx.hit = love.audio.newSource("assets/Hit.wav", "static")
sfx.heal = love.audio.newSource("assets/Heal.wav", "static")
sfx.walk = love.audio.newSource("assets/Walk.wav", "static")
sfx.get = love.audio.newSource("assets/Get.wav", "static")
sfx.ok = love.audio.newSource("assets/Ok.wav", "static")
sfx.die = love.audio.newSource("assets/Die.wav", "static")
sfx.grow = poliphonic("assets/Grow.wav", 16)
sfx.shoot = poliphonic("assets/Shoot.wav", 16, .3)

return sfx
