class("AttackDown").extends(OrbitingStatus)

function AttackDown:init(target)
	AttackDown.super.init(self, "Attack Down", 0, target)
end

function AttackDown:modifyAttack(attack)
	return attack - (self.owner.attack * 0.1)
end