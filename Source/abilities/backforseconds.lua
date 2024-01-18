class('BackForSeconds').extends(Ability)

function BackForSeconds:init(owner)
	BackForSeconds.super.init(self, "Back for Seconds", owner)
	self.canTrigger = true
end

function BackForSeconds:onUseMove(move, target)
	if self.canTrigger and move.basePower > 0 and not isCombatEnding then
		self.canTrigger = false
		addScript(LambdaScript("dubldraker followup", 
			function()
				if not isCombatEnding then
					self:displaySelf()
					local dupe = move:getCopy()
					dupe.basePower *= 0.3
					dupe.name = "Mini-" .. dupe.name
					self.owner:useMove(dupe, target)
					self.canTrigger = true
				end
				nextScript()
			end
			))
	end
end