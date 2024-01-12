class('Move').extends()

moveInfo = json.decodeFile("data/moves.json")

function Move:init(name)
	local targetMoveInfo = moveInfo[name]
	self.id = name
	self.name = targetMoveInfo["moveName"]
	self.type = targetMoveInfo["type"]
	self.basePower = targetMoveInfo["basePower"]
	self.description = targetMoveInfo["description"]
end

local isDebug <const> = true
local sameTypeAsUserBonus <const> = 1.1

function printIfDebug(values)
	if isDebug then
		print(values)
	end
end

function Move:calculateDamage(owner, target)
	printIfDebug("Using move " .. self.name .. ".")
	return manualCalculateDamage(owner, target, self.basePower, self.type)
end

function manualCalculateDamage(owner, target, power, type)
	local output = power
	printIfDebug("Using " .. "move" .. " with base power " .. power .. ".")
	local ownerAttack = owner.attack
	local targetDefense = target.defense
	printIfDebug("Owner attack is " .. owner.attack .. ", target defense is " .. target.defense .. ".")
	printIfDebug("Applying status effects to these values.")
	for i, v in ipairs(owner.statuses) do
		ownerAttack *= v:modifyAttack()
		print("Status " .. v.name .. " modified attack by " .. v:modifyAttack() .. ". New value is " .. ownerAttack)
	end
	print("Modified attack is " .. ownerAttack .. ", modified defense is " .. targetDefense)
	print("Multiplying by (" .. ownerAttack .. "/" .. targetDefense ..").")
	output *= (ownerAttack / targetDefense)
	printIfDebug("Power after modification: " .. output)
	if contains(owner.types, type) then
		printIfDebug("Applying same type damage bonus.")
		output *= sameTypeAsUserBonus
		printIfDebug("New value: " .. output)
	end
	printIfDebug("Applying type bonuses.")
	printIfDebug("Multiplier from type damage bonus: " .. totalMult(type, target.types))
	output *= totalMult(type, target.types)
	printIfDebug("Output pre-floor: " .. output)
	output = math.floor(output)
	printIfDebug("Final output: " .. output)
	printIfDebug("\n")
	return output
end

function Move:use(owner, target)
	
end

function Move:getCopy()
	return getMoveByName(self.id)
end

-- import

import "moves/nibble"
import "moves/ember"
import "moves/spark"

function getMoveByName(name)
	if name == "Nibble" then
		return Nibble()
	elseif name == "Ember" then
		return Ember()
	elseif name == "Spark" then
		return Spark()
	end
end