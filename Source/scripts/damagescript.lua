class('DamageScript').extends(GameScript)

-- DAMAGE TYPES
-- 0: Normal
-- 1: Special

function DamageScript:init(amount, target, damageType, source)
	self.amount = amount
	self.target = target
	self.damageType = damageType
	self.source = source
end

function DamageScript:execute()
	self.target:takeDamage(self.amount, self.damageType, self.source)
	nextScript()
end