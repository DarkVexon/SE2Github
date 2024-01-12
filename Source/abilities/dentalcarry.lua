class('DentalCarry').extends(Ability)

function DentalCarry:init(owner)
	DentalCarry.super.init(self, "Dental Carry", owner)
end

function DentalCarry:onEnterCombat()
	self.activated = false
end

function DentalCarry:modifyIncomingDamage(damage, damageType)
	if damageType == 0 and not self.activated then
		self.activated = true
		self:displaySelfTop()
		return 1
	end
	return damage
end