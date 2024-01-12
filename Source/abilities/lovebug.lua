class('Lovebug').extends(Ability)

function Lovebug:init(owner)
	Lovebug.super.init(self, "Lovebug", owner)
end

function Lovebug:whenHit(damage, type)
	if type == 0 then
		local toHit = self.owner:getFoe()
		addScriptTop(ApplyStatusScript(toHit, OffenseDown()))
		addScriptTop(OneParamScript(textScript, toHit:messageBoxName() .. "'s ATK was reduced!"))
		self:displaySelfTop()
	end
end