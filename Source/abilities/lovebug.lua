class('Lovebug').extends(MonsterAbility)

function Lovebug:init()
	Lovebug.super.init(self, "Lovebug")
end

function Lovebug:whenHit(damage, type, attacker)
	self:displaySelf()
	-- TODO: Apply power action to attacker
end