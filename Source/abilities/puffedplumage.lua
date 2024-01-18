class('PuffedPlumage').extends(Ability)

function PuffedPlumage:init(owner)
	PuffedPlumage.super.init(self, "Puffed Plumage", owner)
end

function PuffedPlumage:onUseMove(move, target)
	if move.type == "wing" and not target.isFainting then
		self:displaySelf()
		addScript(TextScript(target:messageBoxName() .. " got 2 Charmed!"))
		for i=1, 2 do
			addScript(ApplyStatusScript(target, Charmed(target)))
		end
	end
end