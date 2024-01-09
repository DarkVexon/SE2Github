class('MonsterMove').extends()

moveInfo = json.decodeFile("data/moves.json")

function MonsterMove:init(name)
	local targetMoveInfo = moveInfo[name]
	self.name = targetMoveInfo["moveName"]
	self.type = targetMoveInfo["type"]
	self.basePower = targetMoveInfo["basePower"]
	self.description = targetMoveInfo["description"]
end