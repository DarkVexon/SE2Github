class('Explosive').extends(Ability)

function Explosive:init(owner)
	Explosive.super.init(self, "Explosive", owner)
end

function Explosive:onDeath()
	local toHit = self.owner:getFoe()
	if not toHit.isFainting then
		self:displaySelf()
		addScript(DamageScript((toHit.maxHp) * 0.4, toHit, 1, self.owner))
	end
end