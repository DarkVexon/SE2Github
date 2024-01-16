class('OrbitingStatus').extends(Status)

local ORBIT_RADIUS <const> = 75
local TIME_TO_AROUND <const> = 150
local Y_SQUASH <const> = 0.2

statusImgs = {}

function OrbitingStatus:loadImg(imgName)
	if (containsKey(statusImgs, imgName)) then
		self.img = statusImgs[imgName]
	else
		statusImgs[imgName] = gfx.image.new("img/combat/status/" .. imgName)
		self.img = statusImgs[imgName]
	end
end

function OrbitingStatus:init(name, type, owner)
	OrbitingStatus.super.init(self, name, type, owner)
	self.isFriendly = owner:isFriendly()
	self.posX = 50 + math.random(-5, 5)
	self.posY = 50 + math.random(-25, 25)
	self.centerX = self.posX
	self.centerY = self.posY
	self.speed = randomFloat(0.75, 1.25)
	self.rads = randomFloat(0, math.pi * 2)
	self.renderBehind = false
	self:loadImg(name)
end

function OrbitingStatus:update()
	self.rads -= math.pi / TIME_TO_AROUND * self.speed
	if self.rads < 0 then
		self.rads += math.pi * 2
	end
	if self.rads < math.pi then
		self.renderBehind = false
	else
		self.renderBehind = true
	end
	self.posX = self.centerX + ORBIT_RADIUS * math.cos(self.rads)
	self.posY = self.centerY + ORBIT_RADIUS * math.sin(self.rads) * Y_SQUASH

	if self.isFriendly then
		self.posX += playerMonsterPosX
		self.posY += playerMonsterPosY
	else
		self.posX += enemyMonsterPosX
		self.posY += enemyMonsterPosY
	end
end

function OrbitingStatus:render()
	self.img:draw(self.posX, self.posY)
end
