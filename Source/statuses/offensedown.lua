class("OffenseDown").extends(Status)

function OffenseDown:init()
	OffenseDown.super.init(self, "Offense Down", 0)
end

function OffenseDown:modifyAttack()
	return 0.9
end