class('Crybaby').extends(Ability)

function Crybaby:init(owner)
	Crybaby.super.init(self, "Crybaby", owner)
end

function Crybaby:onEnterCombat()
	local toHit = self.owner:getFoe()
	self:displaySelf()
	addScript(TextScript(toHit:messageBoxName() .. "'s stats were lowered!"))
	addScript(ApplyStatusScript(toHit, AttackDown(toHit)))
	addScript(ApplyStatusScript(toHit, DefenseDown(toHit)))
	addScript(ApplyStatusScript(toHit, SpeedDown(toHit)))
end