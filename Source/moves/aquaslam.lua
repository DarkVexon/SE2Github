class('AquaSlam').extends(Move)

function AquaSlam:init()
	AquaSlam.super.init(self, "Aqua Slam")
end

function AquaSlam:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end