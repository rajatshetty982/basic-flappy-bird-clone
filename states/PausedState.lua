PausedState = Class({ __includes = BaseState })

function PausedState:update(dt)
	if love.keyboard.wasPressed("p") then
		gStateMachine:change("play", {
			playState = self.playState,
		})
	end
end

function PausedState:enter(params)
	self.playState = params.playState
end

function PausedState:render()
	self.playState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("Game Paused..", 0, 64, VIR_WD, "center") -- FIXME: eyeballed this!!!

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Press p to unpause", 0, 100, VIR_WD, "center")
end
