class('DamageOutwardLine').extends(VFX)

function DamageOutwardLine:init(x, y)
	DamageOutwardLine.super.init(self)
	self.posX = x
	self.posY = y
	local radians = toRadians(math.random(360))
	self.xMult = math.cos(radians)
	self.yMult = math.sin(radians)
	self.speed = math.random(5, 10)
	self.lifeLeft = math.random(10, 15)
	self.length = math.random(8, 10)
end

function DamageOutwardLine:update()
	self.lifeLeft -= 1
	self.speed -= 0.5
	self.posX += self.speed * self.xMult
	self.posY += self.speed * self.yMult
	if self.lifeLeft <= 0 then
		self.isDone = true
	end
end

function DamageOutwardLine:render()
	--gfx.setColor(gfx.kColorXOR)
	gfx.drawLine(self.posX, self.posY, self.posX + (self.length * self.xMult), self.posY + (self.length * self.yMult))
	--gfx.setColor(gfx.kColorBlack)
end