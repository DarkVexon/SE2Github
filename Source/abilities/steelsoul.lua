class('SteelSoul').extends(Ability)

function SteelSoul:init(owner)
	SteelSoul.super.init(self, "Steel Soul", owner)
end

function SteelSoul:modifyIncomingDamage(damage, damageType)
	if damage > self.owner.maxHp * 0.4 and damageType == 0 then
		self:displaySelfTop()
		damage = self.owner.maxHp * 0.4
	end
	return damage
end