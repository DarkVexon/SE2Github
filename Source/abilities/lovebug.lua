class('Lovebug').extends(Ability)

function Lovebug:init(owner)
	Lovebug.super.init(self, "Lovebug", owner)
end

function Lovebug:whenHit(damage, type)
	if type == 0 then
		local toHit = self.owner:getFoe()
		self:displaySelf()
		addScript(ApplyStatusScript(toHit, AttackDown(toHit)))
		addScript(TextScript(toHit:messageBoxName() .. "'s ATK was reduced!"))
	end
end