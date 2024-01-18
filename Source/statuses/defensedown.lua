class("DefenseDown").extends(OrbitingStatus)

function DefenseDown:init(target)
	DefenseDown.super.init(self, "Defense Down", 0, target)
end

function DefenseDown:modifyDefense(defense)
	return defense - (self.owner.defense * 0.2)
end