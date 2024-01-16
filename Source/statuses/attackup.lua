class("AttackUp").extends(OrbitingStatus)

function AttackUp:init(target)
	AttackUp.super.init(self, "Attack Up", 1, target)
end

function AttackUp:modifyAttack(attack)
	return attack + (self.owner.attack * 0.1)
end