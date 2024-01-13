class('MoveCapturedMonsterAnim').extends(Animation)

function MoveCapturedMonsterAnim:init(isOn)
	MoveCapturedMonsterAnim.super.init(self)
	self.totalTime = 20
	self.time = self.totalTime
	self.isOn = isOn
end

function MoveCapturedMonsterAnim:update()
	self.time -= 1
	if self.isOn then
		postCaptureMonsterPosX = playdate.math.lerp(CAPTURED_MONSTER_POS_X, KEYBOARD_MONSTER_POS_X, timeLeft(self.time, self.totalTime))
	else
		postCaptureMonsterPosX = playdate.math.lerp(KEYBOARD_MONSTER_POS_X, CAPTURED_MONSTER_POS_X, timeLeft(self.time, self.totalTime))
	end
	if self.time == 0 then
		self.isDone = true
	end
end