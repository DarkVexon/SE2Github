class('Nibble').extends(Move)

function Nibble:init()
	Nibble.super.init(self, "Nibble")
end

function Nibble:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end