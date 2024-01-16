class('Sharp').extends(Mark)

function Sharp:init()
	Sharp.super.init(self, "Sharp")
end

function Sharp:modifyOutgoingCrit(critChance)
	return critChance + 5
end