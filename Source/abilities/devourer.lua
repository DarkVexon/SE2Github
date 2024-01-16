class('Devourer').extends(Ability)

function Devourer:init(owner)
	Devourer.super.init(self, "Devourer", owner)
end

function Devourer:modifyAttack(attack)
	local toHit = self.owner:getFoe()
	if toHit.curHp < toHit.maxHp/2 then
		self:displaySelf()
		return attack + (self.owner.attack * 0.5)
	end
	return attack
end