class('MysteryBox').extends(Move)

function MysteryBox:init()
	MysteryBox.super.init(self, "Mystery Box")
end

function MysteryBox:use(owner, target)
	local newMove = randomMove()
	addScript(TextScript(owner:messageBoxName() .. " pulled " .. newMove.name .. " from the mystery box!"))
	owner:useMove(newMove, target)
end