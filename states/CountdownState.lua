CountdownState = Class({ __includes = BaseState })

COUNTDOWN_TIME = 0.75

function CountdownState:init()
	self.count = 3
	self.timer = 0
end

function CountdownState:update(dt)
	self.timer = self.timer + dt -- add time passed in each frame
	if self.count > 0 then
		if self.timer >= COUNTDOWN_TIME then
			self.count = self.count - 1
			self.timer = self.timer % COUNTDOWN_TIME -- for smoother time tracking
			print(self.timer)
		end
	else
		gStateMachine:change("play")
	end
end

function CountdownState:render()
	love.graphics.setFont(hugeFont)
	love.graphics.printf(tostring(self.count), 0, 120, VIR_WD, "center")
end
