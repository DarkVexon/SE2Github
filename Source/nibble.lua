class('Nibble').extends(MonsterMove)

function Nibble:init()
	Nibble.super.init(self, "Nibble")
end

function Nibble:use(owner, target)
	Nibble.super.use(self, owner, target)
	addScript(DamageScript(self:calculateDamage(owner, target), target))
end