class('Spark').extends(Move)

function Spark:init()
	Spark.super.init(self, "Spark")
end

function Spark:use(owner, target)
	addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
	addScript(MoveAttackScript(owner, self, target))
end