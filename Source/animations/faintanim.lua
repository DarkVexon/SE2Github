class('FaintAnim').extends(Animation)

function FaintAnim:init(isEnemy)
	FaintAnim.super.init(self)
	self.isEnemy = isEnemy
	self.totalTime = 30
	self.time = self.totalTime
end

function FaintAnim:update()
	self.time -= 1
	if self.isEnemy then
		enemyMonsterPosX += 4
	else
		playerMonsterPosX -= 4
	end
	if self.time == 0 then
		self.isDone = true
	end
end