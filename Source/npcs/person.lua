class('Person').extends(GameObject)

function Person:init(name, x, y, text)
	Person.super.init(self, name, x, y)
	self.startX = x
	self.startY = y
	self.walkTimer = 90
end

function Person:update()
	Person.super.update(self)
	self.walkTimer -= 1
	if (self.walkTimer <= 0) then
		self.walkTimer = 90
		self:walkToRandomNearby()
	end
end

function Person:walkToRandomNearby()
	--TODO: Walls respect plus don't wander off too far
	self:moveBy(1, 0)
end