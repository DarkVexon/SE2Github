class('Snowball').extends(Move)

function Snowball:init()
	Snowball.super.init(self, "Snowball")
end

function Snowball:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(StartAnimScript(LaunchBoltAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
		if moveRandom(0, 5) == 0 then
			addScript(TextScript(target:messageBoxName() .. "'s SPD was lowered!"))
			addScript(ApplyStatusScript(target, SpeedDown(target)))
		end
	end
end