class('Ember').extends(Move)

function Ember:init()
	Ember.super.init(self, "Ember")
end

function Ember:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
end