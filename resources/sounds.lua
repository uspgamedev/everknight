local sfx = {}

sfx.slash = love.audio.newSource("Slash.wav", "static")
sfx.hurt = love.audio.newSource("Hurt.wav", "static")
sfx.heal = love.audio.newSource("Heal.wav", "static")
sfx.walk = love.audio.newSource("Walk.wav", "static")
sfx.get = love.audio.newSource("Get.wav", "static")
sfx.ok = love.audio.newSource("Ok.wav", "static")
sfx.die = love.audio.newSource("Die.wav", "static")

return sfx