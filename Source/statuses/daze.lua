class('Daze').extends(OrbitingStatus)

function Daze:init(target)
	Daze.super.init(self, "Daze", 0, target)
end

function Daze:preUseMove()
	if math.random(0, 0) == 0 then
		addScript(TextScript(self.owner:messageBoxName() .. " is Dazed and cannot move!"))
		addScript(RemoveStatusScript(self.owner, self))
		return false
	end
	return true
end