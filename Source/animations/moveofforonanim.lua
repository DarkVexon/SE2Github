class('MoveOffOrOnAnim').extends(Animation)

function MoveOffOrOnAnim:init(isEnemy, isOn)
	MoveOffOrOnAnim.super.init(self)
	self.isEnemy = isEnemy
	self.totalTime = 20
	self.time = self.totalTime
	self.isOn = isOn
end

function MoveOffOrOnAnim:update()
	if self.time == self.totalTime and self.isOn then
		if isEnemy then
			enemyMonsterPosY = enemyMonsterY
		else
			playerMonsterPosY = playerMonsterY
		end
	end
	self.time -= 1
	if self.isEnemy then
		if self.isOn then
			enemyMonsterPosX = playdate.math.lerp(enemyMonsterStartX, enemyMonsterEndX, timeLeft(self.time, self.totalTime))
		else
			enemyMonsterPosX = playdate.math.lerp(enemyMonsterEndX, enemyMonsterStartX, timeLeft(self.time, self.totalTime))
		end
	else
		if self.isOn then
			playerMonsterPosX = playdate.math.lerp(playerMonsterStartX, PLAYER_MONSTER_X, timeLeft(self.time, self.totalTime))
		else
			playerMonsterPosX = playdate.math.lerp(PLAYER_MONSTER_X, playerMonsterStartX, timeLeft(self.time, self.totalTime))
		end
	end
	if self.time == 0 then
		self.isDone = true
	end
end