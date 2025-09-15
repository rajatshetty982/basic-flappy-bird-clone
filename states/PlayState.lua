PlayState = Class({ __includes = BaseState })

PIPE_SCROLL = 60
PIPE_HT = 288
PIPE_WD = 70

BIRD_WD = 38
BIRD_WD = 24

function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0

	self.score = 0

	-- init the "last recorded" Y for the gap placement for pipes onwards
	self.lastY = -PIPE_HT + math.random(80) + 20
end

function PlayState:update(dt)
	self.timer = self.timer + dt

	-- spawn a pipe every 2 seconds
	if self.timer > 2 then
		-- randomise the pipe positions
		gapHt = math.random(90, 110)
		local y = math.max(-PIPE_HT + 10, math.min(self.lastY + math.random(-40, 40), VIR_HT - gapHt - PIPE_HT)) -- Make gap_ht a random value
		lastY = y

		table.insert(self.pipePairs, PipePair(y, gapHt)) -- feed the ran gap here

		self.timer = 0 -- reset the timer
	end

	for key, pair in pairs(self.pipePairs) do
		if not pair.scored then
			if self.bird.x > pair.x + PIPE_WD then
				self.score = self.score + 1
				pair.scored = true
			end
		end

		-- for every pipe in the scene, update the pos
		pair:update(dt)
	end

	-- remove pipes which have remove as true
	for key, pipe in pairs(self.pipePairs) do
		if pipe.remove then
			table.remove(self.pipePairs, key)
		end
	end

	self.bird:update(dt)

	-- check collision and set back to title if collided
	for key, pair in pairs(self.pipePairs) do
		for n, pipe in pairs(pair.pipes) do
			if self.bird:collide(pipe) then
				gStateMachine:change("score", {
					score = self.score,
				})
			end
		end
	end

	-- if bird goes beyond ground
	if self.bird.y > VIR_HT - 15 then
		gStateMachine:change("title")
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	self.bird:render()
end
