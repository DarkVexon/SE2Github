class('Move').extends()

moveInfo = json.decodeFile("data/moves.json")

function Move:init(name)
	local targetMoveInfo = moveInfo[name]
	self.id = name
	self.name = targetMoveInfo["moveName"]
	self.type = targetMoveInfo["type"]
	self.basePower = targetMoveInfo["basePower"]
	self.description = targetMoveInfo["description"]
	self.contact = targetMoveInfo["contact"]
	self.targetsFoe = targetMoveInfo["targetsFoe"]
	if targetMoveInfo["priority"] == nil then
		self.priority = 0
	else
		self.priority = targetMoveInfo["priority"]
	end
	if targetMoveInfo["missChance"] == nil then
		self.missChance = 0
	else
		self.missChance = targetMoveInfo["missChance"]
	end
end

local sameTypeAsUserBonus <const> = 1.1

function Move:calculateDamage(owner, target)
	printIfDebug("Using move " .. self.name .. ".")
	return manualCalculateDamage(owner, target, self:calculatePower(owner, target), self.type)
end

function Move:calculatePower(owner, target)
	return self.basePower
end

function manualCalculateDamage(owner, target, power, type)
	local output = power
	printIfDebug("Using " .. "move" .. " with base power " .. power .. ".")
	local ownerAttack = owner:getCalculatedAttack()
	local targetDefense = target:getCalculatedDefense()
	printIfDebug("Owner attack is " .. owner.attack .. ", target defense is " .. target.defense .. ".")
	printIfDebug("Multiplying by (" .. ownerAttack .. "/" .. targetDefense ..").")
	output *= (ownerAttack / targetDefense)
	printIfDebug("Power after modification: " .. output)
	if contains(owner.types, type) then
		printIfDebug("Applying same type damage bonus.")
		output *= sameTypeAsUserBonus
		printIfDebug("New value: " .. output)
	end
	local typeMatchupOutcome = totalMult(type, target.types)
	typeMatchupOutcome *= target.ability:modifyTypeMatchup(type)
	printIfDebug("Applying type bonuses.")
	printIfDebug("Multiplier from type damage bonus: " .. typeMatchupOutcome)
	if typeMatchupOutcome >= 2 then
		addScriptTop(TextScript("It's super effective!"))
	elseif typeMatchupOutcome < 1 and typeMatchupOutcome > 0 then
		addScriptTop(TextScript("It's not very effective..."))
	elseif typeMatchupOutcome == 0 then
		addScriptTop(TextScript("It had no effect!"))
	end
	if target.item ~= nil then
		typeMatchupOutcome = target.item:receiveTypeMatchupOutcome(typeMatchupOutcome)
	end
	output *= typeMatchupOutcome
	local critChance = 0
	critChance = owner.ability:modifyOutgoingCrit(critChance)
	if owner.mark ~= nil then
		critChance = owner.mark:modifyOutgoingCrit(critChance)
	end
	local critRoll = math.random(100)
	if critRoll <= critChance then
		printIfDebug("Rolled a crit! Doubling damage.")
		table.insert(scriptStack, TextScript("Critical Hit!!!"))
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
	local missChance = self.missChance
	missChance = target.ability:modifyIncomingMiss(missChance)
	if target.mark ~= nil then
		missChance = target.mark:modifyIncomingMiss(missChance)
	end
	missChance = target.ability:modifyOutgoingMiss(missChance)
	local result = math.random(0, 100)
	if result <= missChance then
		addScript(TextScript("The attack missed!"))
		if owner.ability:willMiss() then
			return false
		else
			return true
		end
	else
		return true
	end
end

function moveRandom(min, max)
	return math.random(min, max)
end

-- import

import "moves/nibble"
import "moves/ember"
import "moves/spark"
import "moves/mysterybox"
import "moves/peck"
import "moves/meditate"
import "moves/watergun"
import "moves/slash"
import "moves/purifyingflame"
import "moves/dineanddash"
import "moves/prayer"
import "moves/hydraulics"
import "moves/rootslap"
import "moves/warble"
import "moves/jumpscare"
import "moves/robofist"
import "moves/scaleshield"
import "moves/snowball"
import "moves/stinger"
import "moves/nomnomnom"
import "moves/skystrike"
import "moves/gaseousgaze"
import "moves/magicmissile"
import "moves/rockthrow"
import "moves/aquaslam"

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
	elseif name == "Slash" then
		return Slash()
	elseif name == "Purifying Flame" then
		return PurifyingFlame()
	elseif name == "Dine and Dash" then
		return DineAndDash()
	elseif name == "Prayer" then
		return Prayer()
	elseif name == "Hydraulics" then
		return Hydraulics()
	elseif name == "Rootslap" then
		return Rootslap()
	elseif name == "Warble" then
		return Warble()
	elseif name == "Jumpscare" then
		return Jumpscare()
	elseif name == "Robo-Fist" then
		return RoboFist()
	elseif name == "Scaleshield" then
		return Scaleshield()
	elseif name == "Snowball" then
		return Snowball()
	elseif name == "Stinger" then
		return Stinger()
	elseif name == "Nom Nom Nom" then
		return NomNomNom()
	elseif name == "Skystrike" then
		return Skystrike()
	elseif name == "Gaseous Gaze" then
		return GaseousGaze()
	elseif name == "Magic Missile" then
		return MagicMissile()
	elseif name == "Rock Throw" then
		return RockThrow()
	elseif name == "Aqua Slam" then
		return AquaSlam()
	end
	print("ERR! INCORRECT MOVE NAME: " .. name)
end

function randomMove()
	local keys = getTableKeys(moveInfo)
	return getMoveByName(keys[math.random(#keys)])
end