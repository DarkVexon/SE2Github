class('LoseHpAnim').extends(Animation)

function LoseHpAnim:init(monster)
	LoseHpAnim.super.init(self)
	self.monster = monster
end

function LoseHpAnim:update()
	self.monster.dispHp -= 1
	if self.monster.dispHp == self.monster.curHp then
		self.isDone = true
	end
end