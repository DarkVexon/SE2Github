class('HealingScript').extends(Script)

function HealingScript:init(amount, target)
	HealingScript.super.init(self, target.name .. " heals for " .. amount)
	self.amount = amount
	self.target = target
end

function HealingScript:execute()
	self.target:heal(self.amount)
	nextScript()
end