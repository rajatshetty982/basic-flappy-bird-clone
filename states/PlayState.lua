PlayState = Class({ __includes = BaseState })

PIPE_HT = 288
PIPE_WD = 70

BIRD_WD = 38
BIRD_WD = 24

gPipeSpeed = 80

function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0

	self.score = 0

	-- init the "last recorded" Y for the gap placement for pipes onwards
	self.lastY = -PIPE_HT + math.random(80) + 20

	self.pipeSpawnTime = 2.0
end

function PlayState:update(dt)
	self.timer = self.timer + dt

	-- spawn a pipe every 2 seconds
	if self.timer > self.pipeSpawnTime then
		-- randomise the pipe positions
		gapHt = math.random(90, 110)
		local y = math.max(-PIPE_HT + 10, math.min(self.lastY + math.random(-40, 40), VIR_HT - gapHt - PIPE_HT)) -- Make gap_ht a random value
		lastY = y

		table.insert(self.pipePairs, PipePair(y, gapHt)) -- feed the ran gap here

		self.timer = 0 -- reset the timer
	end

	-- scoring system
	for key, pair in pairs(self.pipePairs) do
		if not pair.scored then
			if self.bird.x > pair.x + PIPE_WD then
				self.score = self.score + 1
				pair.scored = true
				sounds["score"]:play()

				-- increasing difficulty difficulty
				if self.score > 0 and self.score % 1 == 0 then
					oldspeed = gPipeSpeed
					print("speed time before: " .. gPipeSpeed)
					pair:increaseSpeed(5)
					print("speed time after: " .. gPipeSpeed)
					print("Spawn time before: " .. self.pipeSpawnTime)
					if self.pipeSpawnTime > 1 then
						self.pipeSpawnTime = self.pipeSpawnTime - (0.06 * (oldspeed / gPipeSpeed))
						print("Spawn time after: " .. self.pipeSpawnTime)
					end
				end
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
				sounds["explosion"]:play()
				sounds["hurt"]:play()

				gStateMachine:change("score", {
					score = self.score,
				})
			end
		end
	end

	-- if bird goes beyond ground
	if self.bird.y > VIR_HT - 15 then
		sounds["explosion"]:play()
		sounds["hurt"]:play()
		gStateMachine:change("score", {
			score = self.score,
		})
	end

	-- NOTE: For the pause state.
	if love.keyboard.wasPressed("p") then
		gStateMachine:change("pause", {
			playState = self,
		})
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print("Score: " .. tostring(self.score), 8, 8)

	self.bird:render()
end

function PlayState:enter(params)
	if params and params.playState then
		local old = params.playState

		self.bird = old.bird
		self.pipePairs = old.pipePairs
		self.timer = old.timer

		self.score = old.score

		self.lastY = old.lastY
	else
		self:init()
	end
end
