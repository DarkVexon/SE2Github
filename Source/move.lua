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

local sameTypeAsUserBonus <const> = 1.1

function Move:calculateDamage(owner, target)
	printIfDebug("Using move " .. self.name .. ".")
	return manualCalculateDamage(owner, target, self.basePower, self.type)
end

function manualCalculateDamage(owner, target, power, type)
	local output = power
	printIfDebug("Using " .. "move" .. " with base power " .. power .. ".")
	local ownerAttack = owner:getCalculatedAttack()
	local targetDefense = target:getCalculatedDefense()
	printIfDebug("Owner attack is " .. owner.attack .. ", target defense is " .. target.defense .. ".")
	print("Multiplying by (" .. ownerAttack .. "/" .. targetDefense ..").")
	output *= (ownerAttack / targetDefense)
	printIfDebug("Power after modification: " .. output)
	if contains(owner.types, type) then
		printIfDebug("Applying same type damage bonus.")
		output *= sameTypeAsUserBonus
		printIfDebug("New value: " .. output)
	end
	local typeMatchupOutcome = totalMult(type, target.types)
	printIfDebug("Applying type bonuses.")
	printIfDebug("Multiplier from type damage bonus: " .. typeMatchupOutcome)
	if typeMatchupOutcome >= 2 then
		addScript(TextScript("It's super effective!"))
	elseif typeMatchupOutcome < 1 and typeMatchupOutcome > 0 then
		addScript(TextScript("It's not very effective..."))
	elseif typeMatchupOutcome == 0 then
		addScript(TextScript("It had no effect!"))
	end
	output *= typeMatchupOutcome
	local critChance = 0
	if owner.mark ~= nil then
		critChance = owner.mark:modifyOutgoingCrit(critChance)
	end
	local critRoll = math.random(100)
	if critRoll <= critChance then
		printIfDebug("Rolled a crit! Doubling damage.")
		addScript(TextScript("Critical Hit!!!"))
		output *= 2
		printIfDebug("New total: " .. output)
	end
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

function Move:checkMiss(owner, target)
	local missChance = 0
	missChance = target.ability:modifyIncomingMiss(missChance)
	if target.mark ~= nil then
		missChance = target.mark:modifyIncomingMiss(missChance)
	end
	local result = math.random(0, 100)
	if result <= missChance then
		addScript(TextScript("But it missed!"))
		return false
	else
		return true
	end
end

-- import

import "moves/nibble"
import "moves/ember"
import "moves/spark"
import "moves/mysterybox"
import "moves/peck"
import "moves/meditate"
import "moves/watergun"

function getMoveByName(name)
	if name == "Nibble" then
		return Nibble()
	elseif name == "Ember" then
		return Ember()
	elseif name == "Spark" then
		return Spark()
	elseif name == "Mystery Box" then
		return MysteryBox()
	elseif name == "Peck" then
		return Peck()
	elseif name == "Meditate" then
		return Meditate()
	elseif name == "Water Gun" then
		return WaterGun()
	end
end

function randomMove()
	local keys = getTableKeys(moveInfo)
	return getMoveByName(keys[math.random(#keys)])
end