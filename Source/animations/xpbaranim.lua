class('XPBarAnim').extends(Animation)

function XPBarAnim:init(monster, startXP, endXP, maxXP)
	XPBarAnim.super.init(self)
	self.monster = monster
	self.startXP = startXP
	self.dispXP = self.startXP
	self.endXP = endXP
	self.maxXP = maxXP
	self.totalTime = ((endXP - startXP) / maxXP) * 125
	self.curTime = self.totalTime
	self.bufferTime = 10
	self.isFriendly = monster:isFriendly()
end

function XPBarAnim:update()
	if self.bufferTime > 0 then
		self.bufferTime -= 1
		if self.bufferTime == 0 and self.curTime == 0 then
			self.isDone = true
		end
	elseif self.curTime > 0 then
		self.curTime -= 1
		self.dispXP = playdate.math.lerp(self.startXP, self.endXP, timeLeft(self.curTime, self.totalTime))
		if self.curTime == 0 then
			self.bufferTime = 20
		end
	else
		self.isDone = true
	end
end

function XPBarAnim:render()
	if self.isFriendly then
		drawBar(playerMonsterPosX + 15, playerMonsterPosY + 4, 66, 10, self.dispXP, self.maxXP)
	else
		drawBar(enemyMonsterPosX + 15, enemyMonsterPosY + 4, 66, 10, self.dispXP, self.maxXP)
	end
end