class('FastAsFire').extends(Ability)

function FastAsFire:init(owner)
	FastAsFire.super.init(self, "Fast as Fire", owner)
end

function FastAsFire:atEndOfTurn()
	self:displaySelf()
	addScript(TextScript(self.owner:messageBoxName() .. "'s SPD increased!"))
	for i=1, 3 do
		addScript(ApplyStatusScript(self.owner, SpeedUp(self.owner)))
	end
end