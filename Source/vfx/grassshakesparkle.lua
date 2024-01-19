class('GrassShakeSparkle').extends(VFX)

local SPARKLE_VFX_IMG <const> = gfx.image.new("img/overworld/vfx/sparkle")
local SPARKLE_FURTHEST_DIST <const> = 90

function GrassShakeSparkle:init(x, y, landY, speedX, speedY, invert)
	GrassShakeSparkle.super.init(self)
	self.posX = x
	self.posY = y
	self.speedX = speedX
	self.lifetime = SPARKLE_FURTHEST_DIST / speedX
	if invert then
		self.speedX *= -1
	end
	self.speedY = speedY
	self.landY = landY
	self.hasBounced = false
end

function GrassShakeSparkle:update()
	self.lifetime -= 1
	self.posX += self.speedX
	if self.speedX > 0 then
		self.speedX -= 0.1
	elseif self.speedX < 0 then
		self.speedX += 0.1
	end
	if self.posY < self.landY or self.speedY < 0 then
		self.posY += self.speedY
		self.speedY += 0.8
	end
	if self.posY >= self.landY then
		if not self.hasBounced then
			self.hasBounced = true
			self.speedY = -2
		end
	end
	if self.lifetime <= 0 then
		self.isDone = true
	end
end

function GrassShakeSparkle:render()
	if self.lifetime <= 15 then
		SPARKLE_VFX_IMG:drawScaled(projectX(self.posX), projectY(self.posY), playdate.math.lerp(1, 0, timeLeft(self.lifetime, 15)))
	else
		SPARKLE_VFX_IMG:draw(projectX(self.posX), projectY(self.posY))
	end
end