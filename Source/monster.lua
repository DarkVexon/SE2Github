class('Monster').extends()

monsterInfo = json.decodeFile("data/monsters.json")

numMonsters = 0
monsterImgs = {}
for k, v in pairs(monsterInfo) do
	numMonsters += 1
	monsterImgs[k] = gfx.image.new("img/monster/" .. k)
end

unknownMonsterImg = gfx.image.new("img/monster/Unknown")

local natureMultPerPoint <const> = 0.2

local levelCap <const> = 99

natures = {
	["Lucky"] = {1, 1, 1, 1},
	["Bored"] = {0, 0, 0, 0},
	["Happy"] = {0, 0, 0, 0},
	["Curious"] = {0, 0, 0, 0},
	["Thoughtful"] = {0, 0, 0, 0},
	["Cute"] = {0, 0, 0, 0},
	["Rude"] = {0, 0, 0, 0},
	["Wiggly"] = {0, 0, 0, 0},
	["Playful"] = {0, 0, 0, 0},
	["Caring"] = {1, -1, 0, 0},
	["Quiet"] = {1, 0, -1, 0},
	["Sleepy"] = {1, 0, 0, -1},
	["Angsty"] = {-1, 1, 0, 0},
	["Reckless"] = {0, 1, -1, 0},
	["Precise"] = {0, 1, 0, -1},
	["Shy"] = {-1, 0, 1, 0},
	["Hungry"] = {0, -1, 1, 0},
	["Smart"] = {0, 0, 1, -1},
	["Impulsive"] = {-1, 0, 0, 1},
	["Evil"] = {0, -1, 0, 1},
	["Crazed"] = {0, 0, -1, 1},
	["Unlucky"] = {-1, -1, -1, -1}
}

function glitchMonsterImg()
	local glitcherImg = gfx.image.new(100, 100)
	gfx.pushContext(glitcherImg)
	for x=0, 1 do
		for y=0, 1 do
			local tarSpecies = randomSpecies()
			local tarImg = monsterImgs[tarSpecies]
			tarImg:draw(-50 + 100*x, -50 + 100*y)
		end
	end
	gfx.popContext()
	return glitcherImg
end

function randomSpecies()
	local keys = getTableKeys(monsterInfo)
	return keys[math.random(#keys)]
end

function Monster:init(data)
	if data["randomNum"] == nil then
		self.randomnum = 1
	else
		self.randomnum = data["randomNum"]
	end
	self.species = data["species"]

	self.speciesName = monsterInfo[self.species]["speciesName"]
	self.img = monsterImgs[self.species]
	if data["name"] == nil then
		self.name = self.speciesName
	else
		self.name = data["name"]
	end
	self.level = data["level"]
	if data["exp"] == nil then
		self.exp = xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level)
	else
		self.exp = data["exp"] + xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level)
	end
	self.moves = {}
	for k, v in pairs(data["moves"]) do
		local move = getMoveByName(v)
		table.insert(self.moves, move)
	end
	if data["nature"] == nil then
		self.nature = randomKey(natures)
	else
		self.nature = data["nature"]
	end
	
	self.mark = data["mark"]
	self.item = data["item"]
	self.curStatus = data["curStatus"]

	self:loadSpeciesData()

	if (data["curHp"] == nil) then
		self.curHp = self.maxHp
	else
		self.curHp = data["curHp"]
	end

	self.statuses = {}
end

function hpFromLevelFunc(base, level)
	return math.floor((base * level) / levelCap) + 10
end

function otherStatFromLevelFunc(base, level)
	return math.floor((base*level) / levelCap) + 5
end

function getStats(species, level, nature, mark)
	local stats = monsterInfo[species]["stats"]
	local results = {
		hpFromLevelFunc(stats[1], level), 
		otherStatFromLevelFunc(stats[2], level), 
		otherStatFromLevelFunc(stats[3], level), 
		otherStatFromLevelFunc(stats[4], level)
	}

	local natureModifiers = natures[nature]
	for i=1, 4 do
		local nextMod = natureModifiers[i] * natureMultPerPoint
		results[i] = results[i] + results[i] * nextMod
	end

	if mark ~= nil then
		mark:applyToStats(results)
	end

	for k, v in pairs(results) do
		results[k] = math.floor(results[k])
	end
	return results[1], results[2], results[3], results[4]
end

function Monster:reloadStats()
	local hp, attack, defense, speed = getStats(self.species, self.level, self.nature, self.mark)
	self.maxHp = hp
	self.attack = attack
	self.defense = defense
	self.speed = speed
end

function Monster:loadSpeciesData()
	self.types = monsterInfo[self.species]["types"]
	self.ability = getAbilityByName(monsterInfo[self.species]["ability"], self)
	self:reloadStats()
end

function xpNeededForLevel(xpCurve, level)
	if xpCurve == "normal" then
		return level^3
	end
end

function getMostRecentFourMovesAtLevel(species, level)
	local moves = {}
	local targetMonsterLearnset = monsterInfo[species]["learnset"]
	for k, v in pairs(targetMonsterLearnset) do
		if tonumber(k) <= level then
			if #moves == 4 then
				table.remove(moves, 0)
			end
			table.insert(moves, v)
		end
	end
	return moves
end

function randomEncounterMonster(species, levelRange)
	local monsterData = {}
	monsterData["randomNum"] = math.random(1, 10000)
	monsterData["species"] = species
	monsterData["name"] = monsterInfo[species]["speciesName"]
	monsterData["level"] = math.random(levelRange[1], levelRange[2])
	monsterData["moves"] = getMostRecentFourMovesAtLevel(species, monsterData["level"])
	monsterData["exp"] = 0
	monsterData["nature"] = randomKey(natures)
	if math.random(0, 10) == 0 then
	--if true then
		monsterData["mark"] = getMarkByName(randomKey(markInfo))
	else
		monsterData["mark"] = nil
	end
	monsterData["item"] = nil
	monsterData["curHp"] = nil
	monsterData["curStatus"] = nil
	return Monster(monsterData)
end

function Monster:messageBoxName()
	local outputText = self.name
	if self == enemyMonster then
		outputText = "The opposing " .. outputText
	end
	return outputText
end

function Monster:useMove(move, target)
	local outputText = self:messageBoxName() .. " used " .. move.name .. "!"
	addScript(TextScript(outputText))
	local shouldUse = true
	if move.targetsFoe then
		local foe = self:getFoe()
		if foe.isFainting then
			shouldUse = false
		end
	else

	end
	if shouldUse then
		move:use(self, target)
	else
		addScript(TextScript("But it failed!"))
	end
	--addScript(LambdaScript("trigger on use move", function () self.ability:onUseMove(move, target) nextScript() end))
	self.ability:onUseMove(move, target)
end

function Monster:getFoe()
	if self == playerMonster then
		return enemyMonster
	else
		return playerMonster
	end
end

function Monster:levelUp()
	local learnset = monsterInfo[self.species]["learnset"]
	local targetMove = getMoveByName(learnset[self.level+1 .. ""])
	local prevLevel = self.level
	local prevMaxHp = self.maxHp
	local prevAtk = self.attack
	local prevDef = self.defense
	local prevSpeed = self.speed
	self.level += 1
	self:reloadStats()
	if self.curHp > 0 then
		self.curHp += (self.maxHp - prevMaxHp)
		self.dispHp = self.curHp
	end
	local gridRows = {}
	levelHeader = prevLevel .. " -> " .. self.level
	table.insert(gridRows, "HP: " .. prevMaxHp .. " -> " .. self.maxHp)
	table.insert(gridRows, "ATK: " .. prevAtk .. " -> " .. self.attack)
	table.insert(gridRows, "DEF: " .. prevDef .. " -> " .. self.defense)
	table.insert(gridRows, "SPD: " .. prevSpeed .. " -> " .. self.speed)
	levelStats = gridRows
	if targetMove ~= nil then
		if #playerMonster.moves < 4 then
			table.insert(playerMonster.moves, targetMove)
			addScriptTop(TextScript(self.name .. " learned " .. targetMove.name .. "!"))
		else
			learningMove = targetMove
			addScriptTop(LambdaScript("Stop turn execution and popup move menu", function() turnExecuting = false showTissue(6) end))
			addScriptTop(TextScript(self.name .. " wants to learn " .. targetMove.name .. "."))
		end
	end
	addScriptTop(LambdaScript("show level info",
		function()
			turnExecuting = false
			showTissue(5)
		end
		)
	)
	addScriptTop(TextScript(self.name .. " leveled up!"))
end

function Monster:xpToNext()
	return xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level+1)
end

function Monster:curXpProgress()
	return self.exp - xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level)
end

function Monster:xpForNext()
	return xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level+1) - xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level)
end

function Monster:getExp(defeated, wasCaught)
	local output = monsterInfo[defeated.species]["grantedExp"]
	if isTrainerBattle then
		output *= 1.2
	end
	if wasCaught then
		output *= 1.2
	end
	local prevXpProgress = self:curXpProgress()
	local prevXpNeeded = self:xpForNext()
	output *= (defeated.level / self.level)
	output = math.floor(output)
	self.exp += output
	if self.exp > self:xpToNext() and self.level < levelCap then
		addScriptTop(LambdaScript("Level up", function() self:levelUp() nextScript() end))
		addScriptTop(StartAnimScript(XPBarAnim(self, 0, (self.exp - xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level+1)), (xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level+2) - xpNeededForLevel(monsterInfo[self.species]["lvlspeed"], self.level+1)))))
		addScriptTop(LambdaScript("Add visuals for level", function ()
			local myX, myY = self:getCoords()
			for i=1, 10 do
				addEffect(LevelUpwardsLine(myX, myY + math.random(45, 55)))
			end
			nextScript()
		end))
		addScriptTop(StartAnimScript(XPBarAnim(self, prevXpProgress, prevXpNeeded, prevXpNeeded)))
	else
		addScriptTop(StartAnimScript(XPBarAnim(self, prevXpProgress, self:curXpProgress(), self:xpForNext())))
	end
	addScriptTop(TextScript(self.name .. " gained " .. output .. " EXP!"))
end

function Monster:heal(amount)
	amount = math.floor(amount)
	amount = math.min(amount, self.maxHp - self.curHp)
	self.curHp += amount
	if (self.curHp >= self.maxHp) then
		self.curHp = self.maxHp
	end
	if amount ~= 0 then
		addScriptTop(StartAnimScript(HpBarAnim(self)))
	end
end

function Monster:isFriendly()
	return playerMonster == self
end

function Monster:getCoords()
	if self:isFriendly() then
		return playerMonsterPosX + 50, playerMonsterPosY + 50
	else
		return enemyMonsterPosX + 50, enemyMonsterPosY + 50
	end
end

function Monster:takeDamage(amount, damageType, source)
	for k, v in pairs(source.statuses) do
		amount = v:modifyOutgoingDamage(amount, damageType)
	end
	amount = self.ability:modifyIncomingDamage(amount, damageType)

	amount = math.floor(amount)
	amount = math.min(amount, self.curHp)

	if amount > 0 then
		local myX, myY = self:getCoords()
		hitSound()
		addEffect(DamageNumber(math.random(myX-10, myX+10), math.random(myY-10, myY+10), amount, self:isFriendly()))
		self.curHp -= amount
		if self.curHp <= 0 then
			self.curHp = 0
			self.isFainting = true
		end
		source.ability:onDealDamage(amount, damageType)
		self.ability:whenHit(amount, damageType)
		if amount ~= 0 then
			addScriptTop(StartAnimScript(HpBarAnim(self)))
		end

		if self.curHp == 0 then
			addScript(TextScript(self:messageBoxName() .. " is KOed!"))
			self.ability:onDeath()
			addScript(StartAnimScript(FaintAnim(self ~= playerMonster)))
			if self == playerMonster then
				if remainingMonsters(playerMonsters) > 0 then
					if isTrainerBattle then
						addScript(LambdaScript("open last resort menu", function() openLastResortMenu() nextScript() end))
					else
						addScript(LambdaScript("open last resort menu", function() promptForLastResort() nextScript() end))
					end
				else
					if not isCombatEnding then
						isCombatEnding = true
						addScript(LambdaScript("put loss of combat bot", 
							function ()
								exitBattleViaLoss()
								nextScript()
							end
						))
					end
				end
			else
				addScript(LambdaScript("Gain exp", function()
					playerMonster:getExp(self)
					nextScript()
				end))
				if remainingMonsters(enemyMonsters) > 0 then
					swapEnemyMonsters(getNextMonster(enemyMonsters))
					turnExecutionPhase = 7
				else
					if not isCombatEnding then
						isCombatEnding = true
						addScript(LambdaScript("put win of combat bot", 
							function ()
								exitBattleViaVictory()
								nextScript()
							end
						))
					end
				end
			end
		end

		addEffect(DamagePaf(not self:isFriendly()))
		for i=1, 8 do
			addEffect(DamageOutwardLine(myX, myY))
		end
	end
end

function Monster:chooseMove()
	return self.moves[math.random(#self.moves)]
end

function getDefaultTypes(species)
	return monsterInfo[species]["types"]
end

function getDefaultAbility(species)
	return monsterInfo[species]["ability"]
end

function Monster:getCalculatedAttack()
	local retVal = self.attack
	retVal = self.ability:modifyAttack(retVal)
	for i, v in ipairs(self.statuses) do
		retVal = v:modifyAttack(retVal)
		print("Status " .. v.name .. " modified attack. New value is " .. retVal)
	end
	return retVal
end

function Monster:getCalculatedDefense()
	local retVal = self.defense
	retVal = self.ability:modifyDefense(retVal)
	for i, v in ipairs(self.statuses) do
		retVal = v:modifyDefense(retVal)
		print("Status " .. v.name .. " modified defense. New value is " .. retVal)
	end
	return retVal
end

function Monster:getCalculatedSpeed()
	local retVal = self.speed
	retVal = self.ability:modifySpeed(retVal)
	for i, v in ipairs(self.statuses) do
		retVal = v:modifySpeed(retVal)
		print("Status " .. v.name .. " modified speed. New value is " .. retVal)
	end
	return retVal
end

function Monster:removeStatus(status)
	local foundIdx = indexValue(self.statuses, status)
	if foundIdx >= 1 then
		table.remove(self.statuses, foundIdx)
	end
end