class('Spark').extends(Move)

function Spark:init()
	Spark.super.init(self, "Spark")
end

function Spark:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(StartAnimScript(LaunchBoltAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end