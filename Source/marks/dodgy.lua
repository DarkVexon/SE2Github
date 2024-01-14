class('Dodgy').extends(Mark)

function Dodgy:init()
	Dodgy.super.init(self, "Dodgy")
end

function Dodgy:modifyIncomingMiss(missChance)
	return missChance + 5
end