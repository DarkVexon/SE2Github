class('Person').extends(NPC)

local TIME_TO_MOVE <const> = 8

function Person:loadImg(imgName)
	if (containsKey(objectImgs, imgName)) then
		self.imgs = objectImgs[imgName]
	else
		self.imgs = {}
		for i=1, 10 do
			table.insert(self.imgs, gfx.image.new("img/overworld/npc/" .. imgName .. "/" .. i))
		end
		objectImgs[imgName] = self.imgs
	end
end

function Person:swapFooting()
	if self.footing == 1 then
		self.footing = 2
	else
		self.footing = 1
	end
end

function Person:setFacing(facing)
	self:swapFooting()
	self.facing = facing
	local newImgIndex = 1
	if facing == 0 then
		newImgIndex = 1 + self.footing
	elseif facing == 1 then
		newImgIndex = 4
	elseif facing == 2 then
		newImgIndex = 5 + self.footing
	elseif facing == 3 then
		newImgIndex = 9
	end
	newImgIndex += 1
	self.imgIndex = newImgIndex
end

function Person:init(name, x, y, facing)
	Person.super.init(self, name, x, y)
	self:loadImg(name)
	self.footing = 1
	self.imgIndex = 1
	self:setFacing(facing)
	self.moveTime = 0
	self.callScriptAfterMove = false
end

function Person:render()
	if self:shouldRender() then
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillEllipseInRect(self.visX + cameraOffsetX, self.visY + cameraOffsetY + 40 - 13, 40, 10)
		gfx.setColor(gfx.kColorBlack)
		self.imgs[self.imgIndex]:draw(self.visX + cameraOffsetX, self.visY + cameraOffsetY - 8)
	end
end

function Person:attemptMoveUp()
	if (self:canMoveThere(self.posX, self.posY-1)) then
		self:moveBy(0, -1)
		return
	end
end

function Person:attemptMoveDown()
	if (self:canMoveThere(self.posX, self.posY+1)) then
		self:moveBy(0, 1)
		return
	end
end

function Person:attemptMoveLeft()
	if (self:canMoveThere(self.posX - 1, self.posY)) then
		self:moveBy(-1, 0)
		return
	end
end

function Person:attemptMoveRight()
	if (self:canMoveThere(self.posX + 1, self.posY)) then
		self:moveBy(1, 0)
		return
	end
end

function Person:canMoveThere(x, y)
	if playerX == x and playerY == y then
		return false
	end
	return canMoveThere(x, y)
end

function Person:updateVisualMotion()
	if self.moveTime > 0 then
		self.moveTime -= 1
		if self.visX ~= self.visDestX then
			self.visX = playdate.math.lerp(self.prevVisX, self.visDestX, timeLeft(self.moveTime, TIME_TO_MOVE))
		end
		if self.visY ~= self.visDestY then
			self.visY = playdate.math.lerp(self.prevVisY, self.visDestY, timeLeft(self.moveTime, TIME_TO_MOVE))
		end

		if self.moveTime == 4 then
			self.imgIndex -= 1
		end

		if self.moveTime == 0 then
			self:onMoveEnd()
		end
	end
end

function Person:onMoveEnd()
	if self.callScriptAfterMove then
		self.callScriptAfterMove = false
		nextScript()
	end
end

function Person:moveBy(x, y)
	if (x ~= 0 or y ~= 0) then
		if x > 0 then
			self:setFacing(1)
		elseif x < 0 then
			self:setFacing(3)
		elseif y > 0 then 
			self:setFacing(2)
		elseif y < 0 then
			self:setFacing(0)
		end
		--print("Cur pos x: " .. self.posX .. ", cur pos y: " .. self.posY)
		--print("Cur vis x: " .. self.visX .. ", cur vis y: " .. self.visY)
		self.prevVisX = self.visX
		self.prevVisY = self.visY
		self.posX += x
		self.posY += y
		self.visDestX = (self.posX-1) * 40
		self.visDestY = (self.posY-1) * 40
		self.moveTime = TIME_TO_MOVE
		--print("New pos x: " .. self.posX .. ", new pos y: " .. self.posY)
		--print("Next vis x: " .. self.visDestX .. ", next vis y: " .. self.visDestY)
	end
end

function Person:update()
	self:updateVisualMotion()
end

function Person:turnToFacePlayer()
	if playerX < self.posX then
		self:setFacing(3)
	elseif playerX > self.posX then
		self:setFacing(1)
	elseif playerY < self.posY then
		self:setFacing(0)
	elseif playerY > self.posY then
		self:setFacing(2)
	end
end

function Person:moveForwards()
	if self.facing == 0 then
		self:attemptMoveUp()
	elseif self.facing == 1 then
		self:attemptMoveRight()
	elseif self.facing == 2 then
		self:attemptMoveDown()
	elseif self.facing == 3 then
		self:attemptMoveLeft()
	end
end