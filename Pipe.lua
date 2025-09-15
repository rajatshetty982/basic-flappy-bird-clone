Pipe = Class({})

local PIPE_IMG = love.graphics.newImage("pipe.png")

function Pipe:init(orientation, y)
	self.x = VIR_WD

	self.y = y

	self.width = PIPE_IMG:getWidth()
	self.height = PIPE_HT
	self.orientation = orientation
end

function Pipe:update(dt) end

function Pipe:render()
	love.graphics.draw(
		PIPE_IMG,
		self.x,
		(self.orientation == "top" and self.y + PIPE_HT or self.y), -- if flipped we need to compensate for the height
		0, -- radians offset
		1, -- scale in x dir
		self.orientation == "top" and -1 or 1 -- scale in y (flips the sprite if -1)
	)
end
