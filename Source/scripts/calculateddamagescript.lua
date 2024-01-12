class('CalculatedDamageScript').extends(GameScript)

-- DAMAGE TYPES
-- 0: Normal
-- 1: Special

function CalculatedDamageScript:init(owner, power, type, target)
	self.owner = owner
	self.power = power
	self.type = type
	self.target = target
end

function CalculatedDamageScript:execute()
	self.target:takeDamage(manualCalculateDamage(self.owner, self.target, self.power, self.type), 0, self.owner)
	nextScript()
end