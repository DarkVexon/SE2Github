class('Rootslap').extends(Move)

function Rootslap:init()
	Rootslap.super.init(self, "Rootslap")
end

function Rootslap:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
		addScript(TextScript(target:messageBoxName() .. "'s SPD was lowered!"))
		addScript(ApplyStatusScript(target, SpeedDown(target)))
	end
end