class('Slash').extends(Move)

function Slash:init()
	Slash.super.init(self, "Slash")
end

function Slash:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end