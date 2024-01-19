class('Whiskers').extends(Ability)

function Whiskers:init(owner)
	Whiskers.super.init(self, "Whiskers", owner)
	self.willTrigger = false
end

function Whiskers:willMiss()
	self:displaySelf()
	addScript(TextScript("Attack crits instead of missing!"))
	self.willTrigger = true
	return false
end

function Whiskers:modifyOutgoingCrit(critChance)
	if self.willTrigger then
		self.willTrigger = false
		return 100
	end
	return critChance
end