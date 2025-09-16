PipePair = Class({})

-- GAP_HT = 90

function PipePair:init(y, gapHt) -- also make gap ht a member value here
	self.x = VIR_WD + 32 -- for a little bit of a delay before it pops up in the screen
	self.y = y

	self.pipes = {
		["upper"] = Pipe("top", self.y),
		["lower"] = Pipe("bottom", self.y + PIPE_HT + gapHt),
	}

	-- if pipe goes beyond left side of the screen we can cleanup
	self.remove = false

	-- has this pipe been score
	self.scored = false
end

function PipePair:update(dt)
	if self.x > -PIPE_WD then
		self.x = self.x - gPipeSpeed * dt

		self.pipes["upper"].x = self.x
		self.pipes["lower"].x = self.x
	else
		self.remove = true
	end
end

function PipePair:render()
	for key, pipe in pairs(self.pipes) do
		pipe:render()
	end
end

function PipePair:increaseSpeed(speedToAdd)
	gPipeSpeed = math.min(gPipeSpeed + speedToAdd, 300) -- 300 will be the max speed
end
