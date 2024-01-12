class('MoveAttackScript').extends(GameScript)

-- DAMAGE TYPES
-- 0: Normal
-- 1: Special

function MoveAttackScript:init(owner, move, target)
	self.owner = owner
	self.move = move
	self.target = target
end

function MoveAttackScript:execute()
	self.target:takeDamage(self.move:calculateDamage(self.owner, self.target), 0, self.owner)
	nextScript()
end