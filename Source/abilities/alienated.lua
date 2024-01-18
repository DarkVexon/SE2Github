class('Alienated').extends(Ability)

function Alienated:init(owner)
	Alienated.super.init(self, "Alienated", owner)
end

function Alienated:whenHit(damage, damageType)
	if damageType == 0 and math.random(0, 2) >= 0 then
		local toHit = self.owner:getFoe()
		self:displaySelf()
		addScript(ApplyStatusScript(toHit, Daze(toHit)))
		addScript(TextScript(toHit:messageBoxName() .. " was Dazed!"))
	end
end