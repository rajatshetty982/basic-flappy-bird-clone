Bird = Class({})

local GRAVITY = 9

function Bird:init()
	self.image = love.graphics.newImage("bird.png")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = VIR_WD / 2 - (self.width / 2)
	self.y = VIR_HT / 2 - (self.height / 2)

	self.dy = 0

	-- NOTE: added a little lag in birds falling action as it was feeling a bit sudden and annoying
	-- now it kinda feels like the bird is stuck, a bit awkward, maybe a better idea is to render
	-- the bird even in the title screen
	self.waiting = true
	self.waitTimer = 0
	self.waitUntil = 0.4
end

function Bird:render()
	love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
	if self.waiting then
		if self.waitTimer < self.waitUntil then
			self.waitTimer = self.waitTimer + dt
		else
			self.waiting = not self.waiting
		end
		return
	end
	self.dy = self.dy + GRAVITY * dt

	if love.keyboard.wasPressed("space") then
		self.dy = -2
		sounds["jump"]:play()
	end

	self.y = self.y + self.dy
end

function Bird:collide(pipe)
	-- with some shrinking of the bounding box to make it a little forgiving for the player. x/y is shifted to the right and width/height is reduced
	-- So its two inches less on both side
	if self.x <= pipe.x + pipe.width and (self.x + 2) + (self.width - 4) >= pipe.x then
		if self.y < pipe.y + pipe.height and (self.y + 3) + (self.height - 6) >= pipe.y then
			return true
		end
	end
	return false
end
