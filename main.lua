push = require("push")

Class = require("class")

require("Bird")
require("Pipe")
require("PipePair")
require("StateMachine")
require("states/BaseState")
require("states/PlayState")
require("states/TitleScreenState")
require("states/ScoreState")
require("states/CountdownState")

WIN_WD = 1280
WIN_HT = 720

VIR_WD = 512
VIR_HT = 288

-- TODO:
-- love.mousepressed(x,y,button) for jumps
-- p for pause -> pausestate
-- if score > limits -> certain medals
--
-- All the image stuff start
local background = love.graphics.newImage("background.png")
local bgScroll = 0
local BG_SCROLL_SPEED = 30
local BG_LOOP_POINT = 413

local ground = love.graphics.newImage("ground.png")
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60
-- end

function love.load()
	-- filter setup for a bit retro look and no blurring of the edges
	love.graphics.setDefaultFilter("nearest", "nearest")

	math.randomseed(os.time())

	love.window.setTitle("Flappy Bird Clone")

	-- fonts
	smallFont = love.graphics.newFont("font.ttf", 8)
	mediumFont = love.graphics.newFont("flappy.ttf", 14)
	flappyFont = love.graphics.newFont("flappy.ttf", 28)
	hugeFont = love.graphics.newFont("flappy.ttf", 56)

	love.graphics.setFont(flappyFont)

	sounds = {
		["jump"] = love.audio.newSource("jump.wav", "static"),
		["explosion"] = love.audio.newSource("explosion.wav", "static"),
		["hurt"] = love.audio.newSource("hurt.wav", "static"),
		["score"] = love.audio.newSource("score.wav", "static"),

		-- used from https://freesoung.org/people/xsgianni/sounds/388079/
		["music"] = love.audio.newSource("marios_way.mp3", "static"),
	}

	sounds["music"]:setLooping(true)
	sounds["music"]:play()

	push:setupScreen(VIR_WD, VIR_HT, WIN_WD, WIN_HT, {
		vsync = true,
		fullscreen = false,
		resizable = true,
	})

	gStateMachine = StateMachine({
		["title"] = function()
			return TitleScreenState()
		end,
		["play"] = function()
			return PlayState()
		end,
		["score"] = function()
			return ScoreState()
		end,
		["countdown"] = function()
			return CountdownState()
		end,
	})

	gStateMachine:change("title")

	love.keyboard.keysPressed = {}
end

function love.resize(w, d)
	push:resize(w, d)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
	if key == "escape" then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.update(dt)
	bgScroll = (bgScroll + BG_SCROLL_SPEED * dt) % BG_LOOP_POINT

	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIR_WD

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {} -- reset our inp key table
end

function love.draw()
	push:start()

	-- first the bg
	love.graphics.draw(background, -bgScroll, 0)

	-- then the pipes (this before ground to make them look like they are sticking out of the ground)
	--
	gStateMachine:render()
	-- then the ground
	love.graphics.draw(ground, -groundScroll, VIR_HT - 16)

	push:finish()
end
