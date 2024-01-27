class('ShowAbilityAnim').extends(Animation)

function ShowAbilityAnim:init(isEnemy)
	ShowAbilityAnim.super.init(self)
	self.isEnemy = isEnemy
	self.totalTime = 15
	self.time = self.totalTime
	self.isOn = true
	self.bufferTime = 0
end

function ShowAbilityAnim:update()
	if self.bufferTime > 0 then
		self.bufferTime -= 1
	else
		self.time -= 1
		if self.isEnemy then
			if self.isOn then
				enemyAbilityPopupX = playdate.math.lerp(ENEMY_POPUP_SYSTEM_STARTX, ENEMY_POPUP_SYSTEM_STARTX - (POPUP_SYSTEM_WIDTH - 20), timeLeft(self.time, self.totalTime))
			else
				enemyAbilityPopupX = playdate.math.lerp(ENEMY_POPUP_SYSTEM_STARTX - (POPUP_SYSTEM_WIDTH - 20), ENEMY_POPUP_SYSTEM_STARTX, timeLeft(self.time, self.totalTime))
			end
		else
			if self.isOn then
				playerAbilityPopupX = playdate.math.lerp(PLAYER_POPUP_SYSTEM_STARTX, PLAYER_POPUP_SYSTEM_STARTX + (POPUP_SYSTEM_WIDTH - 20), timeLeft(self.time, self.totalTime))
			else
				playerAbilityPopupX = playdate.math.lerp(PLAYER_POPUP_SYSTEM_STARTX + (POPUP_SYSTEM_WIDTH - 20), PLAYER_POPUP_SYSTEM_STARTX, timeLeft(self.time, self.totalTime))
			end
		end
		if self.time == 0 then
			if self.isOn then
				self.isOn = false
				self.time = self.totalTime
				self.bufferTime = 15
			else
				self.isDone = true
			end
		end
	end
end