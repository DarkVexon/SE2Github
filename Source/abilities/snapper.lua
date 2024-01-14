class('Snapper').extends(Ability)

function Snapper:init(owner)
	Snapper.super.init(self, "Snapper", owner)
end

function Snapper:onEnterCombat()
	local toHit = self.owner:getFoe()
	self:displaySelf()
	turnExecuting = true
	addScript(StartAnimScript(AttackAnim(self.owner ~= playerMonster)))
	addScript(CalculatedDamageScript(self.owner, 10, "plant", toHit))
	addScript(LambdaScript("add turn execution to bot", function() if not combatIsEnding then addScript(LambdaScript("turn off execution", function() turnExecuting = false end)) end nextScript() end))
	nextScript()
end