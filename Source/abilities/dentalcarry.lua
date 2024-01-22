
class('DentalCarry').extends(Ability)

function DentalCarry:init(owner)
	DentalCarry.super.init(self, "Dental Carry", owner)
end

function DentalCarry:onEnterCombat()
	self.activated = false
end

function DentalCarry:modifyIncomingDamage(damage, damageType)
	if not self.activated then
		self.activated = true
		self:displaySelf()
		return 1
	end
	return damage
end