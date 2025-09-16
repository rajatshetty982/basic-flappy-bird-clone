ScoreState = Class({ __includes = BaseState })

function ScoreState:enter(params)
	self.score = params.score
end

function ScoreState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gStateMachine:change("countdown")
	end
end

function ScoreState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("YOU DIED! lol", 0, 64, VIR_WD, "center")

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Score: " .. tostring(self.score), 0, 100, VIR_WD, "center")

	love.graphics.printf("Press Enter To Play Again", 0, 160, VIR_WD, "center")
end
