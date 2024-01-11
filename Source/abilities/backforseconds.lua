class('BackForSeconds').extends(MonsterAbility)

function BackForSeconds:init()
	BackForSeconds.super.init(self, "Back for Seconds")
end

function BackForSeconds:onUseMove(move)
	if move.basePower > 0 then
		self:displaySelf()
		local dupe = move:getCopy()
		dupe.basePower *= 0.3
		-- TODO: Use the duplicated move
	end
end