local music = {}

table.insert(music, love.audio.newSource("assets/music1.mp3", "static"))
table.insert(music, love.audio.newSource("assets/music2.mp3", "static"))
table.insert(music, love.audio.newSource("assets/music3.mp3", "static"))
table.insert(music, love.audio.newSource("assets/music4.mp3", "static"))

music.boss = love.audio.newSource("assets/boss.mp3")

-- sfx.slash = love.audio.newSource("assets/Slash.wav", "static")
-- sfx.hurt = love.audio.newSource("assets/Hurt.wav", "static")
-- sfx.hit = love.audio.newSource("assets/Hit.wav", "static")
-- sfx.heal = love.audio.newSource("assets/Heal.wav", "static")
-- sfx.walk = love.audio.newSource("assets/Walk.wav", "static")
-- sfx.get = love.audio.newSource("assets/Get.wav", "static")
-- sfx.ok = love.audio.newSource("assets/Ok.wav", "static")
-- sfx.die = love.audio.newSource("assets/Die.wav", "static")

return music