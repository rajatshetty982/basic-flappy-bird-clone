Bird = Class({})

local GRAVITY = 9

function Bird:init()
	self.image = love.graphics.newImage("bird.png")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = VIR_WD / 2 - (self.width / 2)
	self.y = VIR_HT / 2 - (self.height / 2)

	self.dy = 0
end

function Bird:render()
	love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
	self.dy = self.dy + GRAVITY * dt

	if love.keyboard.keysPressed["space"] then
		self.dy = -2
	end

	self.y = self.y + self.dy
end

function Bird:collide(pipe)
	-- with some shrinking of the bounding box to make it a little forgiving for the player. x/y is shifted to the right and width/height is reduced
	-- So its two inches less on both side
	if self.x <= pipe.x + pipe.width and (self.x + 2) + (self.width - 4) >= pipe.x then
		if self.y < pipe.y + pipe.height and (self.y + 2) + (self.height - 4) >= pipe.y then
			return true
		end
	end
	return false
end
