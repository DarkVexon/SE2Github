class('MuffledNeighing').extends(Ability)

function MuffledNeighing:init(owner)
	MuffledNeighing.super.init(self, "Muffled Neighing", owner)
end

function MuffledNeighing:onUseMove(move, target)
	if move.contact and not target.isFainting then
		self:displaySelf()
		addScript(TextScript(target:messageBoxName() .. "'s DEF was lowered!"))
		addScript(ApplyStatusScript(target, DefenseDown(target)))
	end
end