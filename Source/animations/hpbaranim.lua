class('HpBarAnim').extends(Animation)

function HpBarAnim:init(monster)
	HpBarAnim.super.init(self)
	self.monster = monster
end

function HpBarAnim:update()
	if self.monster.dispHp > self.monster.curHp then
		self.monster.dispHp -= 1
		if self.monster.dispHp == self.monster.curHp then
			self.isDone = true
		end
	elseif self.monster.dispHp < self.monster.curHp then
		self.monster.dispHp += 1
		if self.monster.dispHp == self.monster.curHp then
			self.isDone = true
		end
	else
		self.isDone = true
	end
end