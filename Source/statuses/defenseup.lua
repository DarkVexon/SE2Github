class("DefenseUp").extends(OrbitingStatus)

function DefenseUp:init(target)
	DefenseUp.super.init(self, "Defense Up", 1, target)
end

function DefenseUp:modifyDefense(defense)
	return defense + (self.owner.defense * 0.2)
end