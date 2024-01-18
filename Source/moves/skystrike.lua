class('Skystrike').extends(Move)

function Skystrike:init()
	Skystrike.super.init(self, "Skystrike")
end

function Skystrike:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end

function Skystrike:calculatePower(owner, target)
	if target.curHp == target.maxHp then
		return self.basePower * 2
	end
	return self.basePower
end