class('WaterGun').extends(Move)

function WaterGun:init()
	WaterGun.super.init(self, "Water Gun")
end

function WaterGun:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end