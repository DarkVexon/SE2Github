class('Skitter').extends(Ability)

function Skitter:init(owner)
	Skitter.super.init(self, "Skitter", owner)
end

function Skitter:modifyIncomingMiss(missChance)
	return missChance + 10
end