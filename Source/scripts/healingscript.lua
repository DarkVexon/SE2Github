class('HealingScript').extends(GameScript)

function HealingScript:init(amount, target)
	self.amount = amount
	self.target = target
end

function HealingScript:execute()
	self.target:heal(self.amount)
	nextScript()
end