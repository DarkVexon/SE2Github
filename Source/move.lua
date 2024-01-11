class('MonsterMove').extends()

moveInfo = json.decodeFile("data/moves.json")

function MonsterMove:init(name)
	local targetMoveInfo = moveInfo[name]
	self.id = name
	self.name = targetMoveInfo["moveName"]
	self.type = targetMoveInfo["type"]
	self.basePower = targetMoveInfo["basePower"]
	self.description = targetMoveInfo["description"]
end

local isDebug <const> = nil
local sameTypeAsUserBonus <const> = 1.1

function printIfDebug(values)
	if isDebug then
		print(values)
	end
end

function MonsterMove:calculateDamage(owner, target)
	local output = self.basePower
	printIfDebug("Using " .. self.name .. " with base power " .. self.basePower .. ".")
	printIfDebug("Owner attack is " .. owner.attack .. ", target defense is " .. target.defense .. ".")
	output *= (owner.attack / target.defense)
	printIfDebug("Power after modification: " .. output)
	if contains(owner.types, self.type) then
		printIfDebug("Applying same type damage bonus.")
		output *= sameTypeAsUserBonus
		printIfDebug("New value: " .. output)
	end
	printIfDebug("Applying type bonuses.")
	printIfDebug("Multiplier from type damage bonus: " .. totalMult(self.type, target.types))
	output *= totalMult(self.type, target.types)
	printIfDebug("Output pre-floor: " .. output)
	output = math.floor(output)
	printIfDebug("Final output: " .. output)
	printIfDebug()
	return output
end

function MonsterMove:use(owner, target)
	
end

function MonsterMove:getCopy()
	return getMoveByName(self.id)
end

-- import

import "moves/nibble"

function getMoveByName(name)
	if name == "Nibble" then
		return Nibble()
	end
end