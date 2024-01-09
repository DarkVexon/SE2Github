class('GameObject').extends()

objectImgs = {}

function GameObject:init(name, x, y)
	self.name = name
	if (containsKey(objectImgs, name)) then
		self.img = objectImgs[name]
	else
		objectImgs[name] = gfx.image.new("img/" .. name)
		self.img = objectImgs[name]
	end
	self.posX = x
	self.startX = x
	self.posY = y
	self.startY = y
	self.visDestX = (self.posX-1) * 40
	self.visDestY = (self.posY-1) * 40
	self.visX = self.visDestX
	self.visY = self.visDestY
	self.speed = 4
end

function GameObject:updateVisualMotion()
	if self.visX ~= self.visDestX then
		if self.visX < self.visDestX then
			self.visX += self.speed
		elseif self.visX > self.visDestX then
			self.visX -= self.speed
		end
	end
	if self.visY ~= self.visDestY then
		if self.visY < self.visDestY then
			self.visY += self.speed
		elseif self.visY > self.visDestY then
			self.visY -= self.speed
		end
	end
end

function GameObject:moveBy(x, y)
	if (x ~= 0 or y ~= 0) then
		self.posX += x
		self.posX += y
		self.visDestX = (self.posX-1) * 40
		self.visDestY = (self.posY-1) * 40
	end
end

function GameObject:update()
	self:updateVisualMotion()
end

function GameObject:render()
	if (cameraOffsetGridX <= self.posX+1 and cameraOffsetGridX + camWidth >= self.posX-1 and cameraOffsetGridY <= self.posY+1 and cameraOffsetGridY + camHeight >= self.posY-1) then
		self.img:draw(self.visX + cameraOffsetX, self.visY + cameraOffsetY)
	end
end

function GameObject:canMoveHere()
	return false
end

function GameObject:onInteract()

end

function GameObject:onOverlap()

end

function GameObject:allowImmediateMovementAfterStep()
	return true
end