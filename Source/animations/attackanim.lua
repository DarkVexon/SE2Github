class('AttackAnim').extends(Animation)

function AttackAnim:init(isEnemy)
	AttackAnim.super.init(self)
	self.isEnemy = isEnemy
	self.totalTime = 10
	self.time = self.totalTime
end

function AttackAnim:update()
	self.time -= 1
	if self.isEnemy then
		if self.time > self.totalTime/2 then
			enemyMonsterPosX = playdate.math.lerp(enemyMonsterEndX, enemyMonsterEndX - 30, timeLeft(self.time - (self.totalTime/2), self.totalTime/2))
		else
			enemyMonsterPosX = playdate.math.lerp(enemyMonsterEndX - 30, enemyMonsterEndX, timeLeft(self.time, self.totalTime/2))
		end
	else
		if self.time > self.totalTime/2 then
			playerMonsterPosX = playdate.math.lerp(PLAYER_MONSTER_X, PLAYER_MONSTER_X + 30, timeLeft(self.time - (self.totalTime/2), self.totalTime/2))
		else
			playerMonsterPosX = playdate.math.lerp(PLAYER_MONSTER_X + 30, PLAYER_MONSTER_X, timeLeft(self.time, self.totalTime/2))
		end
	end
	if self.time == 0 then
		self.isDone = true
	end
end