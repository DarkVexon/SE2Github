class('SteelSoul').extends(Ability)

function SteelSoul:init(owner)
	SteelSoul.super.init(self, "Steel Soul", owner)
end

function SteelSoul:modifyIncomingDamage(damage, damageType)
	if damage > self.owner.maxHp * 0.4 then
		self:displaySelf()
		damage = self.owner.maxHp * 0.4
	end
	return damage
end