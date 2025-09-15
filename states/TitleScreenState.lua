TitleScreenState = Class({ __includes = BaseState })

function TitleScreenState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gStateMachine:change("play")
	end
end
function TitleScreenState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("Basic Flappy Bird clone", 0, 64, VIR_WD, "center")

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Press Enter", 0, 100, VIR_WD, "center")
end
