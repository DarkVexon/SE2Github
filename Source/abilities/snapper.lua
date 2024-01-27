class('Snapper').extends(Ability)

function Snapper:init(owner)
	Snapper.super.init(self, "Snapper", owner)
end

function Snapper:onEnterCombat()
	local toHit = self.owner:getFoe()
	self:displaySelf()
	addScript(StartAnimScript(AttackAnim(self.owner ~= playerMonster)))
	addScript(CalculatedDamageScript(self.owner, 30, "plant", toHit))
end