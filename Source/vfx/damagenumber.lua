class('DamageNumber').extends(VFX)

function DamageNumber:init(x, y, number, invert)
	DamageNumber.super.init(self)
	self.lifetime = 60
	self.posX = x
	self.posY = y
	self.speedX = math.random(1, 4)
	if invert then
		self.speedX *= -1
	end
	self.speedY = math.random(8, 12)
	self.number = number
end

function DamageNumber:update()
	self.lifetime -= 1
	self.posX += self.speedX
	self.posY -= self.speedY
	self.speedY -= 1
	if self.lifetime == 0 then
		self.isDone = true
	end
end

function DamageNumber:render()
	--gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	gfx.drawText(self.number, self.posX, self.posY)
	--gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	--smallerFont:drawText(self.number, self.posX, self.posY)
end