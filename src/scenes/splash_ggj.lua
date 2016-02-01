local splash = {}

local sprites = require 'resources/sprites'

local second = 1/FRAME

local timer = 0
local timer_fade = 1*second

local stay = 0
local fadeout = 1

local state = stay
local alpha = 255
local scale = love.graphics.getHeight()/sprites.splash_ggj.img:getHeight()

function splash.load()

end

function splash.draw()
	love.graphics.setColor(255,255,255,alpha)
	love.graphics.draw( sprites.splash_ggj.img,
		love.graphics.getWidth()/2,
		love.graphics.getHeight()/2,
		0, scale, scale,
		sprites.splash_ggj.hotspot:unpack())
	if state > 2 then
		love.graphics.clear()
	end
end

function splash.update()
	if INPUT.confirm then
		animate()
		animate()
		animate()
		animate()
	end
	if animate() then
		love.graphics.setColor(255,255,255,255)
		return "splash"
	end
end

function animate()
	if state > fadeout then
		return true
	end
	timer = timer + 1
	if timer >= timer_fade then
		state = state + 1
		timer = 0
	end
	if state == fadeout then
		alpha = alpha - 255/timer_fade
	end
end

return splash
