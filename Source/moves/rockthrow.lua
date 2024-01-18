class('RockThrow').extends(Move)

function RockThrow:init()
	RockThrow.super.init(self, "Rock Throw")
end

function RockThrow:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end