class('Charmed').extends(OrbitingStatus)

function Charmed:init(target)
	Charmed.super.init(self, "Charmed", 0, target)
end

function Charmed:modifyOutgoingDamage(damage, damageType)
	return damage - 1
end

