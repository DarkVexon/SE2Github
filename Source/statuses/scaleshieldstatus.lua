class('ScaleshieldStatus').extends(Status)

function ScaleshieldStatus:init()
	ScaleshieldStatus.super.init(self, "ScaleshieldStatus", 1)
end

function ScaleshieldStatus:modifyIncomingDamage(damage, damageType)
	if damageType == 0 then
		return damage - (damage * 0.3)
	end
	return damage
end