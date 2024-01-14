class('CalculatedDamageScript').extends(Script)

-- DAMAGE TYPES
-- 0: Normal
-- 1: Special

function CalculatedDamageScript:init(owner, power, type, target)
	CalculatedDamageScript.super.init(self, owner.name .. " attacks " .. target.name .. " for " .. power .. " " .. type .. ".")
	self.owner = owner
	self.power = power
	self.type = type
	self.target = target
end

function CalculatedDamageScript:execute()
	self.target:takeDamage(manualCalculateDamage(self.owner, self.target, self.power, self.type), 0, self.owner)
	nextScript()
end