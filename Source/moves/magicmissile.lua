class('MagicMissile').extends(Move)

function MagicMissile:init()
	MagicMissile.super.init(self, "Magic Missile")
end

function MagicMissile:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(StartAnimScript(LaunchBoltAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end