local COMBAT_MOVE_PANEL_STARTX <const> = 5
local COMBAT_MOVE_PANEL_DESCRIPTION_WIDTH <const> = 295
local COMBAT_MOVE_PANEL_DESCRIPTION_HEIGHT <const> = 45

local ENEMY_MONSTER_INFO_DRAWX <const> = 275
local ENEMY_MONSTER_INFO_DRAWY <const> = 10

local PLAYER_MONSTER_INFO_DRAWX <const> = 15
local PLAYER_MONSTER_INFO_DRAWY <const> = 10

local MONSTER_INFO_HPBAR_WIDTH <const> = 60
local MONSTER_INFO_HPBAR_HEIGHT <const> = 12

combatMenuChoices = {"Moves", "Bag", "Swap", "Run"}

combatTextBoxPosY = 190
combatTextBoxHeight = 240 - combatTextBoxPosY - GLOBAL_BEZEL

local tissueMenuX <const> = 120
local tissueMenuRestY <const> = 40
local tissueMenuWidth <const> = 150
local tissueMenuHeight <const> = 240 - tissueMenuRestY - combatTextBoxHeight - 10
tissueMenuY = combatTextBoxPosY

local tissueShowHideTimer <const> = 10

local combatMenuOptionsStartX <const> = 50
local combatMenuOptionsStartY <const> = combatTextBoxPosY + 5
local combatMenuOptionsHorizDist <const> = 200
local combatMenuOptionsVertDist <const> = 20

enemyMonsterStartX = -100
enemyMonsterEndX = 285
local enemyMonsterY <const> = 85

local playerImgWidth <const> = 100
local playerImgStartX1 <const> = 400
local playerImgEndX1 <const> = 25
local playerImgEndX2 <const> = -playerImgWidth

playerMonsterStartX = -100
PLAYER_MONSTER_X = 15
local playerMonsterY <const> = 85

local postKOChoices <const> = {"Swap", "Flee"}

combatIntroAnimTimers = {40, 12, 15, 0, 40, 15}

playerCombatImg = gfx.image.new("img/combat/combatPlayer")

combatSubmenuChosen = 0
combatPrevSubmenu = -1
tissueTimer = 0
tissueMenuShown = false

combatMenuChoiceY = combatMenuOptionsStartY
combatInfoPanY = 240
turnExecuting = false
combatIsEnding = false

enemyMonsters = {}

enemyEncounters = json.decodeFile("data/combats.json")

trainerImgs = {}

function addEffect(effect)
	table.insert(curEffects, effect)
end

function loadCombat(encounter)
	clear(enemyMonsters)
	local newEncounter = enemyEncounters[encounter]
	for i=1, 4 do
		if newEncounter[i .. ""] ~= nil then
			local nextMonster = Monster(newEncounter[i .. ""])
			table.insert(enemyMonsters, nextMonster)
		end
	end
	curTrainerName = newEncounter["name"]
	local imgWanted = newEncounter["img"]
	if (containsKey(trainerImgs, imgWanted)) then
		curTrainerImg = trainerImgs[imgWanted]
	else
		trainerImgs[imgWanted] = gfx.image.new("img/combat/trainers/" .. imgWanted)
		curTrainerImg = trainerImgs[imgWanted]
	end
end

function wildEncounter(species, levelRange)
	clear(enemyMonsters)
	table.insert(enemyMonsters, randomEncounterMonster(species, levelRange))
end

function moveHorizInCombatChoice()
	if combatMenuChoiceIdx == 1 then
		combatMenuChoiceIdx = 2
	elseif combatMenuChoiceIdx == 2 then
		combatMenuChoiceIdx = 1
	elseif combatMenuChoiceIdx == 3 then
		combatMenuChoiceIdx = 4
	elseif combatMenuChoiceIdx == 4 then
		combatMenuChoiceIdx = 3
	end
end

function moveVertInCombatChoice()
	if combatMenuChoiceIdx == 1 then
		combatMenuChoiceIdx = 3
	elseif combatMenuChoiceIdx == 2 then
		combatMenuChoiceIdx = 4
	elseif combatMenuChoiceIdx == 3 then
		combatMenuChoiceIdx = 1
	elseif combatMenuChoiceIdx == 4 then
		combatMenuChoiceIdx = 2
	end
end

-- UPDATE COMBAT TURN EXECUTION
-- If something in combat causes ANY delay,
-- we get BACK to the script queue here.
-- Additionally, the "global buffer" allows
-- for a little extra time before script resume.

local AFTER_ANIM_CONCLUDE_WAIT <const> = 1
curAnim = nil

curEffects = {}

function updateCombatTurnExecution()
	if globalBuffer > 0 then
		globalBuffer -= 1
		if globalBuffer <= 0 then
			nextScript()
		end
	else
		if curAnim ~= nil then
			curAnim:update()
			if curAnim.isDone then
				curAnim = nil
				globalBuffer = AFTER_ANIM_CONCLUDE_WAIT
			end
		end
	end
end

-- COMBAT PHASES
-- [choices]
-- Save player choice and enemy choice.
--> 0. ENEMY MAKES DECISIONS
--> 1. PLAYER SWITCH MONSTER
--> 2. ENEMY SWITCH MONSTER
--> 3. PLAYER USE ITEM
--> 4. ENEMY USE ITEM
--> 5. FASTER USE MOVE
--> 6. SLOWER USE MOVE
--> 7. PLAYER END TURN
--> 8. ENEMY END TURN
--> 9. END ROUND

-- COMBAT PHASE SKIPS
-- If you are KOd:
--    Swap into next monster, THEN...
--         Immediate phase 7.
-- If enemy is KOd:
--    Swap into next monster, THEN...
--         Immediate phase 7.

local turnExecutionFirstPhase <const> = 0

turnExecutionPhase = turnExecutionFirstPhase
playerChosenSwap = nil
playerChosenItem = nil
playerChosenMove = nil
enemyChosenSwap = nil
enemyChosenItem = nil
enemyChosenMove = nil

function playerMonsterMoveCheck()
	if playerChosenMove ~= nil then
		playerMonster:useMove(playerChosenMove, enemyMonster)
		playerChosenMove = nil
		nextScript()
	else
		nextScript()
	end
end

function enemyMonsterMoveCheck()
	if enemyChosenMove ~= nil then
		enemyMonster:useMove(enemyChosenMove, playerMonster)
		enemyChosenMove = nil
		nextScript()
	else
		nextScript()
	end
end

function sendInMonster(monster)
	clear(monster.statuses)
	monster.dispHp = monster.curHp
	if playerDex[monster.speciesName] == 0 then
		playerDex[monster.speciesName] = 1
	end
end

function nextScript()
	print("Getting next script!")
	if #scriptStack == 0 then
		print("No scripts to call.")
		if preEnemyCombatStart then
			print("Next, we instead call enemy at combat start!")
			preEnemyCombatStart = false
			enemyMonster.ability:onEnterCombat()
			nextScript()
		else
			if turnExecuting and curScreen == 3 then
				getNextCombatActions()
			end
		end
	else
		local nextFound = table.remove(scriptStack, 1)
		print("SCRIPT EXECUTING: " .. nextFound.name)
		print()
		nextFound:execute()
	end
end

function swapMonsters(newMonster)
	if playerMonster.curHp > 0 then
		addScript(TextScript("Switch out, " .. playerMonster.name .. "!"))
	end
	addScript(StartAnimScript(MoveOffOrOnAnim(false, false)))
	addScript(SwapMonsterScript(newMonster, false))
	addScript(StartAnimScript(MoveOffOrOnAnim(false, true)))
	addScript(TextScript("Let's go, " .. newMonster.name .. "!"))
end

function swapEnemyMonsters(newMonster)
	if enemyMonster.curHp > 0 then
		addScript(TextScript(curTrainerName .. " withdrew " .. enemyMonster.name .. "!"))
	end
	addScript(StartAnimScript(MoveOffOrOnAnim(true, false)))
	addScript(SwapMonsterScript(newMonster, true))
	addScript(StartAnimScript(MoveOffOrOnAnim(true, true)))
	addScript(TextScript(curTrainerName .. " sent out " .. newMonster.name .. "!"))
end

function getNextCombatActions()
	print("Getting next combat actions at phase " .. turnExecutionPhase)
	if turnExecutionPhase == 0 then
		turnExecutionPhase += 1
		--TODO: Better AI
		enemyChosenMove = enemyMonster:chooseMove()
		nextScript()
	elseif turnExecutionPhase == 1 then
		turnExecutionPhase += 1
		if playerChosenSwap ~= nil then
			swapMonsters(playerChosenSwap)
			playerChosenSwap = nil
			nextScript()
		else
			nextScript()
		end
	elseif turnExecutionPhase == 2 then
		turnExecutionPhase += 1
		if enemyChosenSwap ~= nil then
			-- TODO: Enemy swaps creatures
		else
			nextScript()
		end
	elseif turnExecutionPhase == 3 then
		turnExecutionPhase += 1
		if playerChosenItem ~= nil then
			playerChosenItem:use()
			playerChosenItem = nil
			nextScript()
		else
			nextScript()
		end
	elseif turnExecutionPhase == 4 then
		turnExecutionPhase += 1
		if enemyChosenItem ~= nil then
			-- TODO: Enemy uses item
		else
			nextScript()
		end
	elseif turnExecutionPhase == 5 then
		turnExecutionPhase += 1
		if enemyMonster:getCalculatedSpeed() > playerMonster:getCalculatedSpeed() then
			enemyMonsterMoveCheck()
		else
			playerMonsterMoveCheck()
		end
	elseif turnExecutionPhase == 6 then
		turnExecutionPhase += 1
		if enemyMonster:getCalculatedSpeed() > playerMonster:getCalculatedSpeed() then
			playerMonsterMoveCheck()
		else
			enemyMonsterMoveCheck()
		end
	elseif turnExecutionPhase == 7 then
		turnExecutionPhase += 1
		playerMonster.ability:atEndOfTurn()
		nextScript()
	elseif turnExecutionPhase == 8 then
		turnExecutionPhase += 1
		enemyMonster.ability:atEndOfTurn()
		nextScript()
	elseif turnExecutionPhase == 9 then
		turnExecuting = false
		turnExecutionPhase = turnExecutionFirstPhase
	end
end

function getNextMonster(monsters)
	for i, v in ipairs(monsters) do
		if v.curHp > 0 then
			return v
		end
	end
end

function beginNextCombat()
	beginCombat(curCombat)
end

function beginCombat(combat)
	isTrainerBattle = true
	loadCombat(combat)
	resetCombat()
end

showPlayerMonster = true
showEnemyMonster = true

function resetCombat()
	curScreen = 3
	if isTrainerBattle then
		combatIntroPhase = 5
	else
		combatIntroPhase = 1
	end
	enemyMonster = getNextMonster(enemyMonsters)
	playerMonster = getNextMonster(playerMonsters)
	sendInMonster(playerMonster)
	playerMonsterPosX = playerMonsterStartX
	playerMonsterPosY = playerMonsterY
	sendInMonster(enemyMonster)
	enemyMonsterPosX = enemyMonsterStartX
	enemyMonsterPosY = enemyMonsterY
	playerImgPosX = playerImgStartX1
	enemyTrainerPosX = enemyMonsterStartX
	combatIntroAnimTimer = combatIntroAnimTimers[combatIntroPhase]
	showPlayerMonster = true
	showEnemyMonster = true

	combatSubmenuChosen = 0
	combatPrevSubmenu = -1
	tissueTimer = 0
	tissueMenuShown = false

	combatMenuChoiceY = combatMenuOptionsStartY
	combatInfoPanY = 240
	turnExecuting = false
	combatIsEnding = false
	swapToExecution = false
	turnExecutionPhase = turnExecutionFirstPhase
	globalBuffer = 0
end

function beginWildBattle()
	beginWildCombat(wildSpecies, wildLevelRange)
end

function beginWildCombat(curSpecies, curLevelRange)
	isTrainerBattle = false
	wildEncounter(curSpecies, curLevelRange)
	resetCombat()
end

function hideTissue()
	combatPrevSubmenu = combatSubmenuChosen
	combatSubmenuChosen = 0
	tissueTimer = tissueShowHideTimer
end

function showTissue(submenu)
	combatSubmenuChosen = submenu
	tissueTimer = tissueShowHideTimer
	tissueSelectionIdx = 1
	tissueIndexOffset = 0
end

function fleeCombat()
	for k, v in pairs(playerMonsters) do
		v.ability = getAbilityByName(monsterInfo[v.species].ability, v)
	end
	addScript(TextScript("You flee!"))
	addScript(TransitionScript(openMainScreen))
	turnExecuting = true
	nextScript()
end

function updateMoveSelect()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		tissueSelectionIdx -= 1
		if tissueSelectionIdx == 0 then
			tissueSelectionIdx = #playerMonster.moves
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		tissueSelectionIdx += 1
		if tissueSelectionIdx > #playerMonster.moves then
			tissueSelectionIdx = 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		playerChosenMove = playerMonster.moves[tissueSelectionIdx]
		hideTissue()
		turnExecutionPhase = turnExecutionFirstPhase
		swapToExecution = true
	end
	if playdate.buttonJustPressed(playdate.kButtonB) then
		hideTissue()
	end
end

function updateLearnMoveSelect()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		tissueSelectionIdx -= 1
		if tissueSelectionIdx == 0 then
			tissueSelectionIdx = #playerMonster.moves+1
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		tissueSelectionIdx += 1
		if tissueSelectionIdx > #playerMonster.moves+1 then
			tissueSelectionIdx = 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		if tissueSelectionIdx <= #playerMonster.moves then
			addScriptTop(TextScript(playerMonster.name .. " forgot " .. playerMonster.moves[tissueSelectionIdx].name .. " and learned " .. learningMove.name .. "!"))
			playerMonster.moves[tissueSelectionIdx] = learningMove
		else

		end
		hideTissue()
		swapToExecution = true
	end
end


function updateSwapSelect()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		tissueSelectionIdx -= 1
		if tissueSelectionIdx == 0 then
			tissueSelectionIdx = #playerMonsters
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		tissueSelectionIdx += 1
		if tissueSelectionIdx > #playerMonsters then
			tissueSelectionIdx = 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local targetMonster = playerMonsters[tissueSelectionIdx]
		if targetMonster ~= playerMonster and targetMonster.curHp > 0 then
			if playerMonster.curHp == 0 then
				swapMonsters(targetMonster)
				hideTissue()
				swapToExecution = true
				turnExecutionPhase = 7
			else
				playerChosenSwap = targetMonster
				hideTissue()
				swapToExecution = true
				turnExecutionPhase = turnExecutionFirstPhase
			end
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonB) and playerMonster.curHp > 0 then
		hideTissue()
	end
end


function updateItemSelect()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		tissueSelectionIdx -= 1
		if tissueSelectionIdx == 0 then
			tissueSelectionIdx = numKeys(playerItems)
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		tissueSelectionIdx += 1
		if tissueSelectionIdx > numKeys(playerItems) then
			tissueSelectionIdx = 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) and numKeys(playerItems) > 0 then
		local targetItem = keyAtIndex(playerItems, tissueSelectionIdx + tissueIndexOffset)
		if targetItem:canUse() then
			playerChosenItem = targetItem
			hideTissue()
			swapToExecution = true
			turnExecutionPhase = turnExecutionFirstPhase
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonB) and playerMonster.curHp > 0 then
		hideTissue()
	end
end


function updateCombatChoicePhase()
	if tissueTimer > 0 then
		tissueTimer -= 1
		if tissueMenuShown then
			tissueMenuY = playdate.math.lerp(tissueMenuRestY, combatTextBoxPosY, timeLeft(tissueTimer, tissueShowHideTimer))
			if tissueTimer > tissueShowHideTimer/2 then
				combatInfoPanY = playdate.math.lerp(combatMenuOptionsStartY, 260, timeLeft(tissueTimer - (tissueShowHideTimer/2), tissueShowHideTimer/2))
			else
				combatMenuChoiceY = playdate.math.lerp(260, combatMenuOptionsStartY, timeLeft(tissueTimer, tissueShowHideTimer/2))
			end
		else
			tissueMenuY = playdate.math.lerp(combatTextBoxPosY, tissueMenuRestY, timeLeft(tissueTimer, tissueShowHideTimer))
			if tissueTimer > tissueShowHideTimer/2 then
				combatMenuChoiceY = playdate.math.lerp(combatMenuOptionsStartY, 260, timeLeft(tissueTimer - (tissueShowHideTimer/2), tissueShowHideTimer/2))
			else
				combatInfoPanY = playdate.math.lerp(260, combatMenuOptionsStartY, timeLeft(tissueTimer, tissueShowHideTimer/2))
			end
		end
		if tissueTimer == 0 then
			tissueMenuShown = not tissueMenuShown
			if swapToExecution then
				swapToExecution = false
				turnExecuting = true
				nextScript()
			end
		end
	else
		if not tissueMenuShown then
			if playdate.buttonJustPressed(playdate.kButtonUp) then
				moveVertInCombatChoice()
			elseif playdate.buttonJustPressed(playdate.kButtonRight) then
				moveHorizInCombatChoice()
			elseif playdate.buttonJustPressed(playdate.kButtonDown) then
				moveVertInCombatChoice()
			elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
				moveHorizInCombatChoice()
			end
			if playdate.buttonJustPressed(playdate.kButtonA) then
				if combatMenuChoiceIdx == 4 then
					if isTrainerBattle then
						showTextBox("You can't flee from a battle with someone else!")
					else
						fleeCombat()
					end
				else
					showTissue(combatMenuChoiceIdx)
				end
			end
		else
			if combatSubmenuChosen == 1 then
				updateMoveSelect()
			elseif combatSubmenuChosen == 2 then
				updateItemSelect()
			elseif combatSubmenuChosen == 3 then
				updateSwapSelect()
			elseif combatSubmenuChosen == 5 then
				if playdate.buttonJustPressed(playdate.kButtonA) then
					hideTissue()
					swapToExecution = true
				end
			elseif combatSubmenuChosen == 6 then
				updateLearnMoveSelect()
			end
		end
	end
end

globalBuffer = 0

function remainingMonsters(monsterList)
	local result = 0
	for k, v in pairs(monsterList) do
		if v.curHp > 0 then
			result += 1
		end
	end
	return result
end

function promptForLastResort()
	addScript(QueryScript("Swap to another Monster?", postKOChoices, {openLastResortMenu, exitBattleViaLoss}))
end

function openLastResortMenu()
	turnExecuting = false
	showTissue(3)
end

function exitBattleViaLoss()
	for k, v in pairs(playerMonsters) do
		v.ability = getAbilityByName(monsterInfo[v.species].ability, v)
	end
	clear(returnScripts)
	addScript(TextScript("You lose the battle!"))
	if isTrainerBattle and playerMoney > 0 then
		local moneyPaid = playerMoney * 0.25
		addScript(TextScript("You pay out $" .. moneyPaid .. " to " .. curTrainerName .. "!"))
		playerMoney -= moneyMade
	end
	addScript(MapChangeScript(playerRetreatMap, 1))
	addScript(LambdaScript("post loss heal", function () fullyRestoreMonsters() nextScript() end))
	addScript(TextScript("Having rushed away, you restore your team's energy."))
	isCombatEnding = false
end

function exitBattleViaVictory()
	for k, v in pairs(playerMonsters) do
		v.ability = getAbilityByName(monsterInfo[v.species].ability, v)
	end
	if playerMonster.curHp == 0 then
		clear(returnScripts)
		addScript(MapChangeScript(playerRetreatMap, 1))
		addScript(LambdaScript("post loss heal", function () fullyRestoreMonsters() nextScript() end))
		addScript(TextScript("Having rushed away, you restore your team's energy."))
	else
		addScript(TextScript("You won the battle!"))
		if isTrainerBattle then
			local moneyMade = enemyEncounters[curCombat]["payout"]
			addScript(TextScript(curTrainerName .. " pays out $" .. moneyMade .. "!"))
			playerMoney += moneyMade
		end
		addScript(TransitionScript(openMainScreen))
	end
	isCombatEnding = false
end

-- COMBAT INTRO PHASES
-- 1: Player monster slide in, wild battle
-- 2: Player slide offscreen
-- 3: Send out player monster
-- 4: Actual combat
-- 5: Enemy trainer slide in
-- 6: Enemy trainer sends out X, -> 2

function updateCombatIntro()
	if combatIntroPhase == 1 then
		combatIntroAnimTimer -= 1
		enemyMonsterPosX = playdate.math.lerp(enemyMonsterStartX, enemyMonsterEndX, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		playerImgPosX = playdate.math.lerp(playerImgStartX1, playerImgEndX1, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		if combatIntroAnimTimer == 0 then
			addScript(TextScript("You encounter " .. monsterInfo[enemyMonster.species]["article"] .. enemyMonster.name .. "!"))
			addScript(ChangeCombatIntroPhaseScript(2))
			nextScript()
		end
	elseif combatIntroPhase == 2 then
		combatIntroAnimTimer -= 1
		playerImgPosX = playdate.math.lerp(playerImgEndX1, playerImgEndX2, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		if combatIntroAnimTimer == 0 then
			addScript(TimedTextScript("Go, " .. playerMonsters[1].name .. "!", 15))
			addScript(ChangeCombatIntroPhaseScript(3))
			nextScript()
		end
	elseif combatIntroPhase == 3 then
		combatIntroAnimTimer -= 1
		playerMonsterPosX = playdate.math.lerp(playerMonsterStartX, PLAYER_MONSTER_X, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		if combatIntroAnimTimer == 0 then
			combatMenuChoiceIdx = 1
			combatIntroPhase = 4
			preEnemyCombatStart = true
			playerMonster.ability:onEnterCombat()
			nextScript()
		end
	elseif combatIntroPhase == 5 then
		combatIntroAnimTimer -= 1
		enemyTrainerPosX = playdate.math.lerp(enemyMonsterStartX, enemyMonsterEndX, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		playerImgPosX = playdate.math.lerp(playerImgStartX1, playerImgEndX1, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		if combatIntroAnimTimer == 0 then
			addScript(TextScript(curTrainerName .. " challenges you!"))
			addScript(ChangeCombatIntroPhaseScript(6))
			nextScript()
		end
	elseif combatIntroPhase == 6 then
		combatIntroAnimTimer -= 1
		enemyTrainerPosX = playdate.math.lerp(enemyMonsterEndX, 400, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		enemyMonsterPosX = playdate.math.lerp(400, enemyMonsterEndX, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
		if combatIntroAnimTimer == 0 then
			addScript(TextScript(curTrainerName .. " sent out " .. enemyMonster.name .. "!"))
			addScript(ChangeCombatIntroPhaseScript(2))
			nextScript()
		end
	end
end


function updateInCombat()
	if (textBoxShown) then
		updateTextBox()
	else
		if combatIntroPhase ~= 4 then
			updateCombatIntro()
		elseif combatIntroPhase == 4 then
			if turnExecuting then
				updateCombatTurnExecution()
			else
				updateCombatChoicePhase()
			end
		end
	end

	for i, v in ipairs(playerMonster.statuses) do
		v:update()
	end
	for i, v in ipairs(enemyMonster.statuses) do
		v:update()
	end

	local toRemove = {}
	for i, v in ipairs(curEffects) do
		v:update()
		if v.isDone then
			table.insert(toRemove, v)
		end
	end
	for i, v in ipairs(toRemove) do
		table.remove(curEffects, indexValue(curEffects, v))
	end
end

function drawCombatMonsterData(x, y, monster)
	gfx.drawText(monster.name, x, y)
	gfx.drawText("LV. " .. monster.level, x + 15, y + 20)
	drawHealthBar(x + 5, y + 40, MONSTER_INFO_HPBAR_WIDTH, MONSTER_INFO_HPBAR_HEIGHT, monster.dispHp, monster.maxHp)
end

function drawCombatSwapMonsterRow(monster, x, y, selected)
	if selected then
		gfx.fillTriangle(x, y, x + 15, y + 8, x, y + 16)
	end
	gfx.drawText(monster.name, x + 20, y)
	if monster == playerMonster or monster.curHp == 0 then
		gfx.drawLine(x + 18, y + 8, x + 100, y + 8)
	end
end

tissueIndexOffset = 0

function drawTissueMenu()
	drawNiceRect(tissueMenuX, tissueMenuY, tissueMenuWidth, tissueMenuHeight)

	if combatSubmenuChosen == 1 or (tissueTimer>0 and tissueMenuShown and combatPrevSubmenu==1 and playerMonster.curHp > 0) then
		gfx.drawTextAligned("MOVES", tissueMenuX + (tissueMenuWidth/2), tissueMenuY + 10, kTextAlignment.center)
		for i=1, 4 do
			if i <= #playerMonster.moves then
				drawCombatMenuChoice(playerMonster.moves[i].name, tissueMenuX + 10, tissueMenuY + 10 + ((i)*25), tissueSelectionIdx == i and tissueTimer == 0)
			end
		end
	elseif combatSubmenuChosen == 2 or (tissueTimer > 0 and tissueMenuShown and combatPrevSubmenu == 2 and playerMonster.curHp > 0) then
		gfx.drawTextAligned("ITEMS", tissueMenuX + (tissueMenuWidth/2), tissueMenuY+10, kTextAlignment.center)
		local i = 1
		for k, v in pairs(playerItems) do
			if i >= tissueIndexOffset and i <= tissueIndexOffset+3 and i <= numKeys(playerItems) then
				drawCombatMenuChoice(k.name .. " x" .. v, tissueMenuX + 10, tissueMenuY + 10 + ((i) * 25), tissueSelectionIdx == i and tissueTimer == 0)
				i += 1
			end
		end
	elseif combatSubmenuChosen == 3 or (tissueTimer > 0 and tissueMenuShown and combatPrevSubmenu == 3 and playerMonster.curHp > 0) then
		gfx.drawTextAligned("MONSTERS", tissueMenuX + (tissueMenuWidth/2), tissueMenuY + 10, kTextAlignment.center)
		for i=1, 4 do
			if i <= #playerMonsters then
				drawCombatSwapMonsterRow(playerMonsters[i], tissueMenuX + 10, tissueMenuY + 10 + ((i)*25), tissueSelectionIdx == i and tissueTimer == 0)
			end
		end
	elseif combatSubmenuChosen == 5 or (tissueTimer > 0 and tissueMenuShown and combatPrevSubmenu == 5) then
		gfx.drawTextAligned(levelHeader, tissueMenuX + (tissueMenuWidth/2), tissueMenuY + 10, kTextAlignment.center)
		for i=1, 4 do
			if i <= #levelStats then
				gfx.drawText(levelStats[i], tissueMenuX + 10, tissueMenuY + 10 + ((i) * 25))
			end
		end
	elseif combatSubmenuChosen == 6 then
		for i=1, 5 do
			if i <= #playerMonster.moves then
				drawCombatMenuChoice(playerMonster.moves[i].name, tissueMenuX + 10, tissueMenuY + 10 + ((i)*25), tissueSelectionIdx == i and tissueTimer == 0)
			elseif i == (#playerMonster.moves)+1 then
				drawCombatMenuChoice(learningMove.name, tissueMenuX + 10, tissueMenuY + 10 + ((i)*25), tissueSelectionIdx == i and tissueTimer == 0)
			end
		end
	end

	if playerMonster.curHp > 0 and combatSubmenuChosen < 5 and not (combatPrevSubmenu >= 5 and tissueTimer > 0 and tissueMenuShown) then
		globalBack:draw(tissueMenuX + tissueMenuWidth - BACK_BTN_WIDTH - 2, tissueMenuY + tissueMenuHeight - BACK_BTN_HEIGHT - 2)
	end
end


function drawCombatMenuChoice(text, x, y, selected)
	if selected then
		gfx.fillTriangle(x, y, x + 15, y + 8, x, y + 16)
	end
	if text ~= nil then
		gfx.drawText(text, x + 20, y)
	else
		gfx.drawText("???", x+20, y)
	end
end


function drawFullMoveInfo(move, x, y)
	renderType(move.type, x, y + 8)
	gfx.drawTextInRect(move.description, x + typeImgWidth + 5, y, COMBAT_MOVE_PANEL_DESCRIPTION_WIDTH, COMBAT_MOVE_PANEL_DESCRIPTION_HEIGHT)
	if move.basePower ~= nil then
		gfx.drawText("" .. move.basePower, x + typeImgWidth + 5 + COMBAT_MOVE_PANEL_DESCRIPTION_WIDTH - 8, y + 12)
	end
end

function drawCombatBottomBg()
	gfx.drawLine(0, combatTextBoxPosY, 400, combatTextBoxPosY)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, combatTextBoxPosY + 1, 400, 240 - (combatTextBoxPosY+1))
	gfx.setColor(gfx.kColorBlack)
end

function drawCombatChoicePhase()
	if tissueTimer > 0 or tissueMenuShown then
		drawTissueMenu()
	end

	drawCombatBottomBg()

	if not turnExecuting and playerMonster.curHp > 0 and combatSubmenuChosen < 5 then 
		if (tissueTimer > tissueShowHideTimer/2 or combatSubmenuChosen == 0) and not swapToExecution then
			local index = 1
			for y=0, 1 do
				for x=0, 1 do
					drawCombatMenuChoice(combatMenuChoices[index], combatMenuOptionsStartX + (x * combatMenuOptionsHorizDist),  combatMenuChoiceY + (y * combatMenuOptionsVertDist), combatMenuChoiceIdx == index)
					index += 1
				end
			end
		end
	end

	if (tissueTimer > tissueShowHideTimer/2 and combatPrevSubmenu == 1) or combatSubmenuChosen == 1 then
		drawFullMoveInfo(playerMonster.moves[tissueSelectionIdx], COMBAT_MOVE_PANEL_STARTX, combatInfoPanY)
	end
end

function drawCombatIntro()
	if combatIntroPhase == 1 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		playerCombatImg:draw(playerImgPosX, 65)
	elseif combatIntroPhase == 2 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		drawCombatMonsterData(ENEMY_MONSTER_INFO_DRAWX, ENEMY_MONSTER_INFO_DRAWY, enemyMonster)
		playerCombatImg:draw(playerImgPosX, 65)
	elseif combatIntroPhase == 3 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		drawCombatMonsterData(ENEMY_MONSTER_INFO_DRAWX, ENEMY_MONSTER_INFO_DRAWY, enemyMonster)
		playerMonster.img:draw(playerMonsterPosX, playerMonsterPosY, gfx.kImageFlippedX)
	elseif combatIntroPhase == 5 then
		curTrainerImg:draw(enemyTrainerPosX, enemyMonsterPosY - 50)
		playerCombatImg:draw(playerImgPosX, 65)
	elseif combatIntroPhase == 6 then
		curTrainerImg:draw(enemyTrainerPosX, enemyMonsterPosY- 50)
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		playerCombatImg:draw(playerImgPosX, 65)
	end

	if textBoxShown then
		drawCombatTextBox()
	end
end

function drawCombatInterface()

	for i, v in ipairs(playerMonster.statuses) do
		if v.renderBehind then
			v:render()
		end
	end
	for i, v in ipairs(enemyMonster.statuses) do
		if v.renderBehind then
			v:render()
		end
	end

	if showEnemyMonster then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
	end
	drawCombatMonsterData(ENEMY_MONSTER_INFO_DRAWX, ENEMY_MONSTER_INFO_DRAWY, enemyMonster)
	if showPlayerMonster then
		playerMonster.img:draw(playerMonsterPosX, playerMonsterPosY, gfx.kImageFlippedX)
	end
	drawCombatMonsterData(PLAYER_MONSTER_INFO_DRAWX, PLAYER_MONSTER_INFO_DRAWY, playerMonster)

	for i, v in ipairs(playerMonster.statuses) do
		if not v.renderBehind then
			v:render()
		end
	end
	for i, v in ipairs(enemyMonster.statuses) do
		if not v.renderBehind then
			v:render()
		end
	end
	if curAnim ~= nil then
		curAnim:render()
	end

	for k, v in pairs(curEffects) do
		v:render()
	end

	if textBoxShown then
		if tissueMenuShown then
			drawCombatChoicePhase()
		end
		drawCombatTextBox()
	else
		drawCombatChoicePhase()
	end
end

function drawInCombat()
	if combatIntroPhase ~= 4 then
		drawCombatIntro()
	elseif combatIntroPhase == 4 then
		drawCombatInterface()
	end
end