class('PurifyingFlame').extends(Move)

function PurifyingFlame:init()
	PurifyingFlame.super.init(self, "Purifying Flame")
end

function PurifyingFlame:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
	addScript(RemoveDebuffsScript(self))
end