class('BackForSeconds').extends(Ability)

function BackForSeconds:init(owner)
	BackForSeconds.super.init(self, "Back for Seconds", owner)
	self.canTrigger = true
end

function BackForSeconds:onUseMove(move, target)
	if move.basePower > 0 and self.canTrigger then
		self.canTrigger = false
		self:displaySelf()
		local dupe = move:getCopy()
		dupe.basePower *= 0.3
		dupe.name = "Mini-" .. dupe.name
		self.owner:useMove(dupe, target)
		self.canTrigger = true
	end
end