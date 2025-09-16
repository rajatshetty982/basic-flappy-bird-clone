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
	if self.score < 5 then
		love.graphics.printf("YOU DIED! lol", 0, 94, VIR_WD, "center")
	elseif self.score < 15 then
		love.graphics.draw(self.bronze, self.x, self.y, 0, self.scaleB, self.scaleB)
		love.graphics.printf("Not Bad You Got Bronze", 0, 94, VIR_WD, "center")
	elseif self.score < 35 then
		love.graphics.draw(self.silver, self.x, self.y, 0, self.scaleS, self.scaleS)
		love.graphics.printf("Awesome You Got Silver", 0, 94, VIR_WD, "center")
	else
		love.graphics.draw(self.gold, self.x, self.y, 0, self.scaleG, self.scaleG)
		love.graphics.printf("SUGGEE YOO!! GOLD FOR YOU!", 0, 94, VIR_WD, "center")
	end

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Score: " .. tostring(self.score), 0, 130, VIR_WD, "center")

	love.graphics.printf("Press Enter To Play Again", 0, 190, VIR_WD, "center")
end

function ScoreState:init()
	local targetWidth = 40 -- not needed currenty

	self.bronze = love.graphics.newImage("bronze-medal.png")
	self.bronze:setFilter("linear", "linear")
	self.scaleB = 1
	-- self.scaleB = targetWidth / self.bronze:getWidth()

	self.silver = love.graphics.newImage("silver-medal.png")
	self.silver:setFilter("linear", "linear")
	self.scaleS = 1
	-- self.scaleS = targetWidth / self.silver:getWidth()

	self.gold = love.graphics.newImage("gold-medal.png")
	self.gold:setFilter("linear", "linear")
	self.scaleG = 1
	-- self.scaleG = targetWidth / self.gold:getWidth()

	self.x = VIR_WD / 2 - 25
	self.y = -55
end
