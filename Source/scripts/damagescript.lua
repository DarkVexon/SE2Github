class('DamageScript').extends(Script)

-- DAMAGE TYPES
-- 0: Normal
-- 1: Special
-- 2: HP Loss

function DamageScript:init(amount, target, damageType, source)
	DamageScript.super.init(self, source.name .. " deals " .. amount .. " " .. damageType .. " damage to " .. target.name)
	self.amount = amount
	self.target = target
	self.damageType = damageType
	self.source = source
end

function DamageScript:execute()
	self.target:takeDamage(self.amount, self.damageType, self.source)
	nextScript()
end