class("OffenseDown").extends(Status)

function OffenseDown:init(target)
	OffenseDown.super.init(self, "Offense Down", 0, target)
end

function OffenseDown:modifyAttack(attack)
	return attack - (self.owner.attack * 0.1)
end