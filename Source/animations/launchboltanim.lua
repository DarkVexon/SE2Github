class('LaunchBoltAnim').extends(Animation)

local boltImg <const> = gfx.image.new("img/combat/vfx/bolt")

function LaunchBoltAnim:init(isEnemy)
	LaunchBoltAnim.super.init(self)
	if isEnemy then
		self.flipMode = gfx.kImageFlippedX
	else
		self.flipMode = gfx.kImageUnflipped
	end
	self.totalTime = 10
	self.time = self.totalTime
	if isEnemy then
		self.boltX = enemyMonsterPosX - 15 - 30
		self.boltY = enemyMonsterPosY + 50 - 15
		self.startX = self.boltX
		self.startY = self.boltY
		self.endX = playerMonsterPosX + 50 - 30
		self.endY = playerMonsterPosY + 50 - 15
	else
		self.boltX = playerMonsterPosX + 115 - 30
		self.boltY = playerMonsterPosY + 50 - 15
		self.startX = self.boltX
		self.startY = self.boltY
		self.endX = enemyMonsterPosX + 50 - 30
		self.endY = enemyMonsterPosY + 50 - 15
	end
end

function LaunchBoltAnim:update()
	self.time -= 1
	self.boltX = playdate.math.lerp(self.startX, self.endX, timeLeft(self.time, self.totalTime))
	self.boltY = playdate.math.lerp(self.startY, self.endY, timeLeft(self.time, self.totalTime))
	if self.time == 0 then
		self.isDone = true
	end
end

function LaunchBoltAnim:render()
	boltImg:draw(self.boltX, self.boltY, self.flipMode)
end