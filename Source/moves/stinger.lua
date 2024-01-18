class('Stinger').extends(Move)

function Stinger:init()
	Stinger.super.init(self, "Stinger")
end

function Stinger:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
		addScript(TextScript(owner:messageBoxName() .. " loses HP!"))
		addScript(DamageScript(owner.maxHp * 0.2, owner, 2, owner))
	end
end