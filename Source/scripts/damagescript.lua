class('DamageScript').extends(GameScript)

function DamageScript:init(amount, target)
	self.amount = amount
	self.target = target
end

function DamageScript:execute()
	self.target:takeDamage(self.amount)
end