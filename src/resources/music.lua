local music = {}

table.insert(music, love.audio.newSource("assets/music1.mp3", "stream"))
table.insert(music, love.audio.newSource("assets/music2.mp3", "stream"))
table.insert(music, love.audio.newSource("assets/music3.mp3", "stream"))
table.insert(music, love.audio.newSource("assets/music4.mp3", "stream"))
table.insert(music, love.audio.newSource("assets/music5.ogg", "stream"))

music.boss = love.audio.newSource("assets/boss.mp3", "stream")
music.gameover = love.audio.newSource("assets/gameover.mp3", "stream")

return music