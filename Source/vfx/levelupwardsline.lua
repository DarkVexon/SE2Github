class('LevelUpwardsLine').extends(VFX)

function LevelUpwardsLine:init(x, y)
	LevelUpwardsLine.super.init(self)
	self.posX = x
	self.posY = y
	local radians = toRadians(math.random(360))
	self.xMult = math.cos(radians)
	self.yMult = randomFloat(-1, -0.5)
	self.speed = math.random(3, 8)
	self.lifeLeft = math.random(20, 25)
	self.length = math.random(8, 10)
end

function LevelUpwardsLine:update()
	self.lifeLeft -= 1
	self.posX += self.speed * self.xMult
	self.posY += self.speed * self.yMult
	if self.lifeLeft <= 0 then
		self.isDone = true
	end
end

function LevelUpwardsLine:render()
	--gfx.setColor(gfx.kColorXOR)
	gfx.drawLine(self.posX, self.posY, self.posX + (self.length * self.xMult), self.posY + (self.length * self.yMult))
	--gfx.setColor(gfx.kColorBlack)
end