local sfx = {}

sfx.slash = love.audio.newSource("assets/Slash.wav", "static")
sfx.hurt = love.audio.newSource("assets/Hurt.wav", "static")
sfx.hit = love.audio.newSource("assets/Hit.wav", "static")
sfx.heal = love.audio.newSource("assets/Heal.wav", "static")
sfx.walk = love.audio.newSource("assets/Walk.wav", "static")
sfx.get = love.audio.newSource("assets/Get.wav", "static")
sfx.ok = love.audio.newSource("assets/Ok.wav", "static")
sfx.die = love.audio.newSource("assets/Die.wav", "static")

return sfx