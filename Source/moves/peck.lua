class('Peck').extends(Move)

function Peck:init()
	Peck.super.init(self, "Peck")
end

function Peck:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end