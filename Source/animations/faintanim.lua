class('FaintAnim').extends(Animation)

function FaintAnim:init(isEnemy)
	FaintAnim.super.init(self)
	self.isEnemy = isEnemy
	self.totalTime = 20
	self.time = self.totalTime
end

function FaintAnim:update()
	self.time -= 1
	if self.isEnemy then
		enemyMonsterPosY += 6
	else
		playerMonsterPosY += 6
	end
	if self.time == 0 then
		self.isDone = true
	end
end