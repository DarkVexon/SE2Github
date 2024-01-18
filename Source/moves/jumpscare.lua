class('Jumpscare').extends(Move)

function Jumpscare:init()
	Jumpscare.super.init(self, "Jumpscare")
end

function Jumpscare:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end