class('RoboFist').extends(Move)

function RoboFist:init()
	RoboFist.super.init(self, "Robo-Fist")
end

function RoboFist:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
		addScript(TextScript(owner:messageBoxName() .. "'s ATK was raised!"))
		addScript(ApplyStatusScript(owner, AttackUp(owner)))
	end
end