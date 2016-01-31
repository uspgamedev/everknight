local splash = {}

local sprites = require 'resources/sprites'

local second = 1/FRAME

local timer = 0
local timer_fade = 1.5*second

local fadein = 0
local stay = 1
local fadeout = 2

local state = fadein
local alpha = 0

function splash.load()

end

function splash.draw()
	love.graphics.setColor(255,255,255,alpha)
	love.graphics.draw( sprites.splash.img,
		love.graphics.getWidth()/2,
		love.graphics.getHeight()/2,
		0, 1, 1,
		sprites.splash.hotspot:unpack())
	if state > 2 then
		love.graphics.clear()
	end
end

function splash.update()
	if animate() then
		love.graphics.setColor(255,255,255,255)
		return "title"
	end
end

function animate()
	timer = timer + 1
	if timer >= timer_fade then
		state = state + 1
		timer = 0
	end
	if state == fadein then
		alpha = alpha + 255/timer_fade
	elseif state == fadeout then
		alpha = alpha - 255/timer_fade
	end
	if state > 2 then
		return true
	end
end

return splash