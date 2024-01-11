import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/math"

gfx = playdate.graphics
sfx = playdate.sound

gameFont = gfx.font.new("font/Sasser Slab/Sasser-Slab-Bold")
gfx.setFont(gameFont)

import "helpers"
import "gameobject"
import "gamescript"
import "npcs"
import "maps"
import "monster"
import "type"
import "monstermark"
import "ability"
import "move"

-- CORE --
local gridSize <const> = 40
local gridWidth <const> = 400/40
local gridHeight <const> = 240/40

-- STUFF THAT ALWAYS IMPORTANT

guyImgN = gfx.image.new("img/guy-n")
guyImgE = gfx.image.new("img/guy-e")
guyImgS = gfx.image.new("img/guy-s")
guyImgW = gfx.image.new("img/guy-w")
globalBack = gfx.image.new("img/globalBack")

tilesets = {}
tileInfo = {}
overworldTiles = gfx.tilemap.new()
overworldTable = gfx.imagetable.new("img/overworld-table-40-40")
overworldTiles:setImageTable(overworldTable)
tilesets["overworld"] = overworldTiles
tileInfo["overworld"] = {3}
objs = {}

isCrankUp = false
isMenuUp = false
menuTimer = 0
showingMenu = false

local cameraHorizBuffer <const> = 6
local cameraVertBuffer <const> = 3
camWidth = 400/40
camHeight = 240/40

playerRenderPosX = 200
playerRenderPosY = 80
playerDestRenderPosX = playerRenderPosX
playerDestRenderPosY = playerRenderPosY

menuItems = {"Save", "Creatures", "Creaturedex", "Bag", "ID"}
local menuStartIndex <const> = 2
menuIcons = {}
menuIcons["Save"] = gfx.image.new("img/saveMenuIcon")
menuIcons["Creatures"] = gfx.image.new("img/creaturesMenuIcon")
menuIcons["Creaturedex"] = gfx.image.new("img/creaturedexMenuIcon")
menuIcons["Bag"] = gfx.image.new("img/bagMenuIcon")
menuIcons["ID"] = gfx.image.new("img/idCardMenuIcon")

local postKOChoices <const> = {"Swap", "Flee"}

function hardSetupCameraOffsets()
	cameraOffsetGridX = math.max(0, math.min(mapWidth - camWidth, playerX - cameraHorizBuffer))
	cameraOffsetGridY = math.max(0, math.min(mapHeight - camHeight, playerY - cameraVertBuffer))
	cameraOffsetX = cameraOffsetGridX * -40
	cameraOffsetY = cameraOffsetGridY * -40
	cameraDestOffsetX = cameraOffsetX
	cameraDestOffsetY = cameraOffsetY
	if (playerX < cameraHorizBuffer) then
		playerDestRenderPosX = (playerX-1) * 40
	elseif playerX > (mapWidth - (camWidth - cameraHorizBuffer)) then
		playerDestRenderPosX = (playerX - mapWidth + (camWidth) - 1) * 40
	else
		playerDestRenderPosX = (cameraHorizBuffer - 1) * 40
	end
	playerRenderPosX = playerDestRenderPosX

	if (playerY < cameraVertBuffer) then
		playerDestRenderPosY = (playerY - 1) * 40
	elseif playerY > (mapHeight - (camHeight - cameraVertBuffer)) then
		playerDestRenderPosY = (playerY - mapHeight + (camHeight) - 1) * 40
	else
		playerDestRenderPosY = (cameraVertBuffer- 1) * 40
	end
	playerRenderPosY = playerDestRenderPosY
end

function setupCameraOffset()
	if (playerX < cameraHorizBuffer or (playerX == cameraHorizBuffer and playerFacing == 1)) then
		playerDestRenderPosX = (playerX-1) * 40
	elseif playerX > (mapWidth - (camWidth - cameraHorizBuffer)) or (playerX == (mapWidth - (camWidth - cameraHorizBuffer)) and playerFacing == 3) then
		playerDestRenderPosX = (playerX - mapWidth + (camWidth) - 1) * 40
	else
		cameraOffsetGridX = (playerX - cameraHorizBuffer)
		cameraDestOffsetX = cameraOffsetGridX * -40
	end


	if (playerY < cameraVertBuffer or (playerY == cameraVertBuffer and playerFacing == 2)) then
		playerDestRenderPosY = (playerY - 1) * 40
	elseif playerY > (mapHeight - (camHeight - cameraVertBuffer)) or (playerY == (mapHeight - (camHeight - cameraVertBuffer)) and playerFacing == 0) then
		playerDestRenderPosY = (playerY - mapHeight + (camHeight) - 1) * 40
	else
		cameraOffsetGridY = (playerY - cameraVertBuffer)
		cameraDestOffsetY = cameraOffsetGridY * -40
	end

	movingCam = true
end

function setPlayerFacing(facing)
	playerFacing = facing
	if facing == 0 then
		playerImg = guyImgN
	elseif facing == 1 then
		playerImg = guyImgE
	elseif facing == 2 then
		playerImg = guyImgS
	elseif facing == 3 then
		playerImg = guyImgW
	end
end

-- VARIABLES THAT ALWAYS IMPORTANT
playerMonsters = {randomEncounterMonster("Palpillar"), randomEncounterMonster("Dubldraker")}
playerItems = {}

movingCam = false

textBoxText = ""
textBoxShown = false
textBoxScrollDone = false
textBoxTotalTime = 0
fadeOutTimer = 0
fadeInTimer = 0
fadeDest = 0
-- 1: Map
-- 2: Monsters Screen
-- 3: Individual Monster Screen
-- 4: Combat Screen

local lineThickness <const> = 2

scriptStack = {}

function nextScript()
	if #scriptStack == 0 then
		if movesExecuting then
			movesExecuting = false
		end
	else
		local nextFound = table.remove(scriptStack, 1)
		nextFound:execute()
	end
end

textBoxTimer = 0

function showTextBox(text)
	textBoxText = text
	textBoxDisplayedText = ""
	textBoxShown = true
	textBoxScrollDone = false
	textBoxLetterIndex = 0
end

function showTimedTextBox(text, time)
	showTextBox(text)
	textBoxTimer = time
end

local queryDropdownX <const> = 300
local queryDropdownY <const> = 100

function showQueryTextBox(text, options, funcs)
	showTextBox(text)
	followTextBoxWithPopup = true
	textBoxFollowUpOptions = options
	textBoxFollowUpFuncs = funcs
end

function hideTextBox()
	textBoxShown = false
	nextScript()
end

function updateTextBox()
	if textBoxScrollDone then
		if textBoxTimer > 0 then
			textBoxTimer -= 1
			if textBoxTimer == 0 then
				hideTextBox()
			end
		elseif followTextBoxWithPopup then
			setupPopupMenu(queryDropdownX, queryDropdownY, textBoxFollowUpOptions, textBoxFollowUpFuncs, false)
		else
			if playdate.buttonJustPressed(playdate.kButtonA) then
				hideTextBox()
			end
		end
	else
		if playdate.buttonJustPressed(playdate.kButtonB) and textBoxTimer == 0 then
			textBoxDisplayedText = textBoxText
			textBoxScrollDone = true
		else
			local numLettersToAdd
			if playdate.buttonIsPressed(playdate.kButtonA) then
				numLettersToAdd = 2
			else
				numLettersToAdd = 1
			end
			for i=1, numLettersToAdd do
				textBoxDisplayedText = textBoxDisplayedText .. string.sub(textBoxText, textBoxLetterIndex, textBoxLetterIndex)
				textBoxLetterIndex += 1
				if textBoxLetterIndex > #textBoxText then
					textBoxScrollDone = true
				end
			end
		end
	end
end

function initialize()
	gfx.setLineWidth(lineThickness)
	loadMap("testtown", 1)
end

local textBoxOuterBuffer <const> = 10
local textBoxPosY <const> = 165
boxOutlineSize = 2
local textBoxTextBufferSize <const> = 4
local textBoxWidth <const> = 400 - (textBoxOuterBuffer * 2)
local textBoxHeight <const> = 240 - textBoxPosY - (textBoxOuterBuffer)

menuIdx = menuStartIndex
menuAngle = 0
local baseMenuItemOffset <const> = 180
local menuDistBetween <const> = (180/3)
local menuCrankDistBetween <const> = menuDistBetween/2
local offsetPerMenuItem <const> = menuDistBetween * -1
menuAngleToNext = 0
menuAngleToPrev = 0
local menuMaxAngle <const> = #menuItems * menuDistBetween - 35
local menuCircRadius <const> = 115
local numMenuPaddingFrames <const> = 5
menuPaddingFrames = 0

function resetMenu()
	menuAngle = menuDistBetween * (menuIdx-1)
	menuAngleToNext = 0
	menuAngleToPrev = 0
	menuPaddingFrames = 0
end

curScreen = 0
-- 0: main gameplay
-- 1: monster screen
-- 2: individual monster screen
-- 3: combat screen


monsterScreenSelectionIdx = 1

function openMonsterScreen()
	if curScreen == 0 then
		monsterScreenSelectionIdx = 1
	end
	curScreen = 1
end

function openMainScreen()
	curScreen = 0
end

function updateInMenu()
	--print("next: " .. menuCrankDistBetween - menuAngleToNext)
	--print("prev: " .. menuCrankDistBetween - menuAngleToPrev)
	local change = playdate.getCrankChange() / 2
	if (change ~= 0) then
		--print("change: " .. change)
		menuPaddingFrames = numMenuPaddingFrames
		menuAngle += change
		if menuAngle > menuDistBetween * (#menuItems-1) then
			menuAngle = menuDistBetween * (#menuItems-1)
		end
		if menuIdx < #menuItems and not (change < 0 and menuIdx == 1) then
			menuAngleToNext += change
		end
		if menuIdx > 1 and not (change > 0 and menuIdx == #menuItems) then
			menuAngleToPrev -= change
		end
		if (menuAngle < 0) then
			menuAngle = 0
		end
		if menuAngle > menuMaxAngle then
			menuAngle = menuMaxAngle
		end
		if (menuAngleToNext >= menuCrankDistBetween) then
			if (menuIdx < #menuItems) then
				--print("moved next")
				menuIdx += 1
				menuAngleToNext = 0
				menuAngleToPrev = 0
			end
		elseif menuAngleToPrev >= menuCrankDistBetween then
			if menuIdx > 1 then
				--print("moved prev")
				menuIdx -= 1
				menuAngleToNext = 0
				menuAngleToPrev = 0
			end
		end
	else
		if menuPaddingFrames > 0 then
			menuPaddingFrames -= 1
		else
			local destAngle = menuDistBetween * (menuIdx-1)
			if (menuAngle > destAngle) then
				menuAngle -= 2
				menuAngleToNext -= 2
				menuAngleToPrev += 2
				if (menuAngle <= destAngle) then
					menuAngle = destAngle
					menuAngleToNext = 0
					menuAngleToPrev = 0
				end
			elseif menuAngle < menuDistBetween * (menuIdx-1) then
				menuAngle += 2
				menuAngleToNext += 2
				menuAngleToPrev -= 2
				if menuAngle >= destAngle then
					menuAngle = destAngle
					menuAngleToNext = 0
					menuAngleToPrev = 0
				end
			end
		end
	end
	if playdate.isCrankDocked() and isCrankUp then
		isCrankUp = false
		closeMenu()
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local target = menuItems[menuIdx]
		if target == "Creatures" then
			fadeOutTimer = 15
			fadeDest = 2
		end
	end
end

function openSingleMonsterView()
	curScreen = 2
	monsterSingleViewSelection = 1
	singleViewScrollAmt = 0
end

local enemyMonsterStartX <const> = -100
local enemyMonsterEndX <const> = 285
local enemyMonsterY <const> = 85

local playerImgWidth <const> = 100
local playerImgStartX1 <const> = 400
local playerImgEndX1 <const> = 25
local playerImgEndX2 <const> = -playerImgWidth

local playerMonsterStartX <const> = -100
local playerMonsterX <const> = 15
local playerMonsterY <const> = 85

combatIntroAnimTimers = {40, 12, 20}

playerCombatImg = gfx.image.new("img/combatPlayer")

function getNextMonster(combat)
	if startsWith(combat, "WildEncounter") then
		return randomEncounterMonster(string.sub(combat, 14, string.len(combat)))
	end
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

local combatTextBoxPosY = 190
local combatTextBoxHeight = 240 - combatTextBoxPosY - textBoxOuterBuffer

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

combatSubmenuChosen = 0
combatPrevSubmenu = -1
tissueTimer = 0
tissueMenuShown = false

combatMenuChoiceY = combatMenuOptionsStartY
combatInfoPanY = 240
movesExecuting = false

function beginCombat()
	curScreen = 3
	combatIntroPhase = 1
	enemyMonster = getNextMonster(curCombat)
	enemyMonsterPosX = enemyMonsterStartX
	enemyMonsterPosY = enemyMonsterY
	enemyMonster.dispHp = enemyMonster.curHp
	playerMonster = playerMonsters[1]
	playerMonsterPosX = playerMonsterStartX
	playerMonsterPosY = playerMonsterY
	playerImgPosX = playerImgStartX1
	playerMonster.dispHp = playerMonster.curHp
	combatIntroAnimTimer = combatIntroAnimTimers[combatIntroPhase]

	combatSubmenuChosen = 0
	combatPrevSubmenu = -1
	tissueTimer = 0
	tissueMenuShown = false

	combatMenuChoiceY = combatMenuOptionsStartY
	combatInfoPanY = 240
	movesExecuting = false
	swapToExecution = false
	globalBuffer = 0
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
				movesExecuting = true
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
					addScript(OneParamScript(textScript, "You flee!"))
					addScript(OneParamScript(screenChangeScript, 0))
					movesExecuting = true
					nextScript()
				else
					combatSubmenuChosen = combatMenuChoiceIdx
					tissueTimer = tissueShowHideTimer
					tissueSelectionIdx = 1
				end
			end
		else
			if combatSubmenuChosen == 1 then
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
					combatPrevSubmenu = combatSubmenuChosen
					combatSubmenuChosen = 0
					tissueTimer = tissueShowHideTimer
					swapToExecution = true
					playerMonster:useMove(playerMonster.moves[tissueSelectionIdx], enemyMonster)
					enemyIncomingMove = enemyMonster:chooseMove()
					addScript(GameScript(
						function()
							enemyMonster:useMove(enemyIncomingMove, playerMonster)
							nextScript()
						end
						)
					)
				end
				if playdate.buttonJustPressed(playdate.kButtonB) then
					combatPrevSubmenu = combatSubmenuChosen
					combatSubmenuChosen = 0
					tissueTimer = tissueShowHideTimer
				end
			elseif combatSubmenuChosen == 2 then
				
			elseif combatSubmenuChosen == 3 then
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
						combatPrevSubmenu = combatSubmenuChosen
						combatSubmenuChosen = 0
						tissueTimer = tissueShowHideTimer
						swapToExecution = true
						addScript(OneParamScript(textScript, "Switch out, " .. playerMonster.name .. "!"))
						addScript(GameScript(
								function()
									targetMonster.dispHp = targetMonster.curHp
									playerMonster = targetMonster
									nextScript()
								end
							)
						)
						addScript(OneParamScript(textScript, "Let's go, " .. targetMonster.name .. "!"))
						enemyIncomingMove = enemyMonster:chooseMove()
						addScript(GameScript(
							function()
								enemyMonster:useMove(enemyIncomingMove, playerMonster)
								nextScript()
							end
							)
						)
					end
				end
				if playdate.buttonJustPressed(playdate.kButtonB) and playerMonster.curHp > 0 then
					combatPrevSubmenu = combatSubmenuChosen
					combatSubmenuChosen = 0
					tissueTimer = tissueShowHideTimer
				end
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

function openLastResortMenu()
	combatSubmenuChosen = 3
	tissueTimer = tissueShowHideTimer
	tissueSelectionIdx = 1
end

function exitBattleViaLoss()
	addScript(OneParamScript(textScript, "You lose the battle!"))
	addScript(OneParamScript(screenChangeScript, 0))
	addScript(GameScript(healMonstersToOne))
end

function updateCombatTiming()
	if globalBuffer > 0 then
		globalBuffer -= 1
		if globalBuffer == 0 then
			nextScript()
		end
	else
		if playerMonster.dispHp ~= playerMonster.curHp or enemyMonster.disppHp ~= enemyMonster.curHp then
			if playerMonster.dispHp ~= playerMonster.curHp then
				playerMonster.dispHp -= 1
				if playerMonster.curHp == playerMonster.dispHp and enemyMonster.dispHp == enemyMonster.curHp then
					globalBuffer = 10
					if playerMonster.curHp == 0 then
						addScript(OneParamScript(textScript, playerMonster.name .. " is KOed!"))
						if remainingMonsters(playerMonsters) > 0 then
							addScript(QueryScript("Swap to another Monster?", postKOChoices, {openLastResortMenu, exitBattleViaLoss}))
						else
							exitBattleViaLoss()
						end
					end
				end
			end
			if enemyMonster.dispHp ~= enemyMonster.curHp then
				enemyMonster.dispHp -= 1
				if playerMonster.curHp == playerMonster.dispHp and enemyMonster.dispHp == enemyMonster.curHp then
					globalBuffer = 10
				end
			end
		end
	end
end

function updateInCombat()
	if (textBoxShown) then
		updateTextBox()
	else
		if combatIntroPhase == 1 then
			combatIntroAnimTimer -= 1
			enemyMonsterPosX = playdate.math.lerp(enemyMonsterStartX, enemyMonsterEndX, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
			playerImgPosX = playdate.math.lerp(playerImgStartX1, playerImgEndX1, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
			if combatIntroAnimTimer == 0 then
				table.insert(scriptStack, OneParamScript(textScript, "You encounter a " .. enemyMonster.name .. "!"))
				table.insert(scriptStack, OneParamScript(changeCombatPhaseScript, 2))
				nextScript()
			end
		elseif combatIntroPhase == 2 then
			combatIntroAnimTimer -= 1
			playerImgPosX = playdate.math.lerp(playerImgEndX1, playerImgEndX2, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
			if combatIntroAnimTimer == 0 then
				table.insert(scriptStack, TwoParamScript(timedTextScript, "Go, " .. playerMonsters[1].name .. "!", 15))
				table.insert(scriptStack, OneParamScript(changeCombatPhaseScript, 3))
				nextScript()
			end
		elseif combatIntroPhase == 3 then
			combatIntroAnimTimer -= 1
			playerMonsterPosX = playdate.math.lerp(playerMonsterStartX, playerMonsterX, ((combatIntroAnimTimers[combatIntroPhase] - combatIntroAnimTimer) /combatIntroAnimTimers[combatIntroPhase]))
			if combatIntroAnimTimer == 0 then
				combatMenuChoiceIdx = 1
				table.insert(scriptStack, OneParamScript(changeCombatPhaseScript, 4))
				nextScript()
			end
		elseif combatIntroPhase == 4 then
			if movesExecuting then
				updateCombatTiming()
			else
				updateCombatChoicePhase()
			end
		end
	end
end

local enemyMonsterPanelDrawX <const> = 275
local enemyMonsterPanelDrawY <const> = 10

local playerMonsterPanelDrawX <const> = 15
local playerMonsterPanelDrawY <const> = 10

local monsterPanelHpBarWidth <const> = 60
local monsterPanelHpBarHeight <const> = 12

function drawCombatMonsterData(x, y, monster)
	gfx.drawText(monster.name, x, y)
	gfx.drawText("LV. " .. monster.level, x + 15, y + 20)
	drawHealthBar(x + 5, y + 40, monsterPanelHpBarWidth, monsterPanelHpBarHeight, monster.dispHp, monster.maxHp)
end

combatMenuChoices = {"Moves", "Bag", "Swap", "Run"}

function drawCombatSwapMonsterRow(monster, x, y, selected)
	if selected then
		gfx.fillTriangle(x, y, x + 15, y + 8, x, y + 16)
	end
	gfx.drawText(monster.name, x + 20, y)
	if monster == playerMonster or monster.curHp == 0 then
		gfx.drawLine(x + 18, y + 8, x + 100, y + 8)
	end
end

function drawTissueMenu()
	drawNiceRect(tissueMenuX, tissueMenuY, tissueMenuWidth, tissueMenuHeight)

	if combatSubmenuChosen == 1 or (tissueTimer>0 and tissueMenuShown and combatPrevSubmenu==1) then
		gfx.drawTextAligned("MOVES", tissueMenuX + (tissueMenuWidth/2), tissueMenuY + 10, kTextAlignment.center)
		for i=1, 4 do
			if i <= #playerMonster.moves then
				drawCombatMenuChoice(playerMonster.moves[i].name, tissueMenuX + 10, tissueMenuY + 10 + ((i)*25), tissueSelectionIdx == i and tissueTimer == 0)
			end
		end
	elseif combatSubmenuChosen == 3 or (tissueTimer > 0 and tissueMenuShown and combatPrevSubmenu == 3) then
		gfx.drawTextAligned("MONSTERS", tissueMenuX + (tissueMenuWidth/2), tissueMenuY + 10, kTextAlignment.center)
		for i=1, 4 do
			if i <= #playerMonsters then
				drawCombatSwapMonsterRow(playerMonsters[i], tissueMenuX + 10, tissueMenuY + 10 + ((i)*25), tissueSelectionIdx == i and tissueTimer == 0)
			end
		end
	end

	globalBack:draw(tissueMenuX + tissueMenuWidth - backBtnWidth - 2, tissueMenuY + tissueMenuHeight - backBtnHeight - 2)
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

local combatMoveInfoPanelStartX <const> = 5
local combatMoveInfoPanelDescWidth <const> = 295
local combatMoveInfoPanelDescHeight <const> = 45

function drawFullMoveInfo(move, x, y)
	renderType(move.type, x, y + 8)
	gfx.drawTextInRect(move.description, x + 70, y, combatMoveInfoPanelDescWidth, combatMoveInfoPanelDescHeight)
	if move.basePower ~= nil then
		gfx.drawText("" .. move.basePower, x + 70 + combatMoveInfoPanelDescWidth +3, y + 10)
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

	if not movesExecuting then 
		if (tissueTimer > tissueShowHideTimer/2 or combatSubmenuChosen == 0) and not swapToExecution then
			local index = 1
			for y=0, 1 do
				for x=0, 1 do
					drawCombatMenuChoice(combatMenuChoices[index], combatMenuOptionsStartX + (x * combatMenuOptionsHorizDist),  combatMenuChoiceY + (y * combatMenuOptionsVertDist), combatMenuChoiceIdx == index)
					index += 1
				end
			end
		end
		if (tissueTimer > tissueShowHideTimer/2 and combatPrevSubmenu == 1) or combatSubmenuChosen == 1 then
			drawFullMoveInfo(playerMonster.moves[tissueSelectionIdx], combatMoveInfoPanelStartX, combatInfoPanY)
		end
	end

end

function drawInCombat()
	if combatIntroPhase == 1 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		playerCombatImg:draw(playerImgPosX, 65)
	elseif combatIntroPhase == 2 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		drawCombatMonsterData(enemyMonsterPanelDrawX, enemyMonsterPanelDrawY, enemyMonster)
		playerCombatImg:draw(playerImgPosX, 65)
	elseif combatIntroPhase == 3 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		drawCombatMonsterData(enemyMonsterPanelDrawX, enemyMonsterPanelDrawY, enemyMonster)
		playerMonster.img:draw(playerMonsterPosX, playerMonsterPosY, gfx.kImageFlippedX)
	elseif combatIntroPhase == 4 then
		enemyMonster.img:draw(enemyMonsterPosX, enemyMonsterPosY)
		drawCombatMonsterData(enemyMonsterPanelDrawX, enemyMonsterPanelDrawY, enemyMonster)
		playerMonster.img:draw(playerMonsterPosX, playerMonsterPosY, gfx.kImageFlippedX)
		drawCombatMonsterData(playerMonsterPanelDrawX, playerMonsterPanelDrawY, playerMonster)
	end

	if textBoxShown then
		drawCombatTextBox()
	elseif combatIntroPhase == 4 then
		drawCombatChoicePhase()
	end
end

function drawCombatTextBox()
	drawCombatBottomBg()

	gfx.drawTextInRect(textBoxDisplayedText, textBoxOuterBuffer + textBoxTextBufferSize, combatTextBoxPosY + textBoxTextBufferSize, textBoxWidth - (textBoxTextBufferSize*2), combatTextBoxHeight - (textBoxTextBufferSize*2))
	
	if textBoxScrollDone and textBoxTimer == 0 then
		gfx.fillTriangle(400 - (textBoxOuterBuffer * 4), textBoxPosY + (textBoxOuterBuffer * 4), 400 - (textBoxOuterBuffer * 3), textBoxPosY + (textBoxOuterBuffer * 4), 400 - (textBoxOuterBuffer * 3.5), textBoxPosY + (textBoxOuterBuffer * 5))
	end
end

function onEndFadeOut()
	if scriptAfter then
		scriptAfter = false
		nextScript()
	end
	if fadeDest == 0 then
		openMainScreen()
	elseif fadeDest == 1 then
		loadMap(nextMap, nextTransloc)
	elseif fadeDest == 2 then
		openMonsterScreen()
	elseif fadeDest == 3 then
		openSingleMonsterView()
	elseif fadeDest == 4 then
		beginCombat()
	end
end

function moveVertInPartyView()
	if monsterScreenSelectionIdx == 1 then
		if #playerMonsters >= 3 then
			monsterScreenSelectionIdx = 3
		end
	elseif monsterScreenSelectionIdx == 2 then
		if #playerMonsters >= 4 then
			monsterScreenSelectionIdx = 4
		end
	elseif monsterScreenSelectionIdx == 3 then
		monsterScreenSelectionIdx = 1
	elseif monsterScreenSelectionIdx == 4 then
		monsterScreenSelectionIdx = 2
	end
end

function moveHorizInPartyView()
	if monsterScreenSelectionIdx == 1 then
		if #playerMonsters >= 2 then
			monsterScreenSelectionIdx = 2
		end
	elseif monsterScreenSelectionIdx == 2 then
		monsterScreenSelectionIdx = 1
	elseif monsterScreenSelectionIdx == 3 then
		if #playerMonsters >= 4 then
			monsterScreenSelectionIdx = 4
		else
			monsterScreenSelectionIdx = 2
		end
	elseif monsterScreenSelectionIdx == 4 then
		monsterScreenSelectionIdx = 3
	end
end

skipNextRender = false

function updateOverworld()
	if (textBoxShown) then
		updateTextBox()
	else
		for i, v in ipairs(objs) do
			v:update()
		end

		if (movingCam) then
			updateCameraOffset()
		elseif (menuTimer > 0) then
			updateMenuTimer()
		elseif (isMenuUp) then
			updateInMenu()
		else
			checkMovement()
		end
	end
end

function playdate.update()
	if (fadeOutTimer > 0 or fadeInTimer > 0) then
		if fadeOutTimer > 0 then
			fadeOutTimer -= 1
			if fadeOutTimer == 0 then
				onEndFadeOut()
				transitionImg = gfx.image.new(400, 240)
				gfx.pushContext(transitionImg)
				render()
				gfx.popContext()
				fadeInTimer = 15
			end
		elseif fadeInTimer > 0 then
			fadeInTimer -= 1
		end

		renderFade()
	else
		if popupUp then
			updatePopupMenu()
		else
			if curScreen == 0 then
				updateOverworld()
			elseif curScreen == 1 then
				updatePartyViewMenu()
			elseif curScreen == 2 then
				updateSingleMonsterViewMenu()
			elseif curScreen == 3 then
				updateInCombat()
			end
		end

		if skipNextRender then
			skipNextRender = false
		else
			render()
		end
	end
end


function updateMenuTimer()
	menuTimer -= 1
	if (menuTimer == 0) then
		isMenuUp = showingMenu
	end
end

function drawMenu()
	local circRadius
	if menuTimer > 0 then
		if showingMenu then
			circRadius = menuCircRadius * playdate.math.lerp(0, 1, (10-menuTimer)/10)
		else
			circRadius = menuCircRadius * playdate.math.lerp(0, 1, menuTimer/10)
		end
	else
		circRadius = menuCircRadius
	end
	gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
	gfx.fillCircleAtPoint(400, 120, circRadius)

	for i=menuIdx-3, menuIdx+3 do
		if i > 0 and i <= #menuItems then
			local destinationIndex = i-1
			local destDegrees = destinationIndex * offsetPerMenuItem + baseMenuItemOffset + menuAngle
			local destRads = toRadians(destDegrees)
			local menuIconDestX = circRadius * math.cos(destRads) + 400
			local menuIconDestY = circRadius * math.sin(destRads) + 120
			menuIcons[menuItems[i]]:draw(menuIconDestX - 33, menuIconDestY - 33)
		end
	end
	gfx.setColor(gfx.kColorBlack)
end

local monsterMenuOuterBuffer <const> = 3
backBtnWidth, backBtnHeight = globalBack:getSize()
local globalBackX <const> = 400 - backBtnWidth - 1
local globalBackY <const> = 240 - backBtnHeight - 1

function drawBackButton()
	globalBack:drawIgnoringOffset(globalBackX, globalBackY)
end

local monsterInfoBoxWidth <const> = 195
local monsterInfoBoxHeight <const> = 110

local partyMenuHealthBarWidth <const> = 50
local partyMenuHealthBarHeight <const> = 12
local healthBarSquish <const> = 4

local hpText <const> = gfx.imageWithText("HP:", 100, 50)
local hpTextWidth, hpTextHeight = hpText:getSize()

function drawBar(x, y, width, height, cur, max)
	gfx.fillRoundRect(x + healthBarSquish, y, width, height, healthBarSquish)
	if (cur > 0) then
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(x + (healthBarSquish/2) + healthBarSquish, y + (healthBarSquish/2), (width * playdate.math.lerp(0, 1, cur/max)) - healthBarSquish, height - healthBarSquish, healthBarSquish)
		gfx.setColor(gfx.kColorBlack)
	end
end

function drawHealthBar(x, y, width, height, health, max)
	hpText:draw(x, y)
	drawBar(x + hpTextWidth, y + hpTextHeight/6, width, height, health, max)
	gfx.drawText(health .. "/" .. max, x + hpTextWidth + healthBarSquish, y + hpTextHeight)
end

function drawMonsterInfoBox(monster, x, y, selected)
	if selected then
		drawSelectedRect(x, y, monsterInfoBoxWidth, monsterInfoBoxHeight)
	else
		drawNiceRect(x, y, monsterInfoBoxWidth, monsterInfoBoxHeight)
	end
	if monster ~= nil then
		monster.img:draw(x+5, y+5)
		gfx.drawText(monster.name, x + 110, y + 5)
		gfx.drawText("LV. " .. monster.level, x + 125, y+25)
		drawHealthBar(x + 105, y + 50, partyMenuHealthBarWidth, partyMenuHealthBarHeight, monster.curHp, monster.maxHp)
	end
end

local monsterMenuPopupOptions <const> = {"Info", "Swap"}

function onSelectMonsterInfoPopup()
	fadeOutTimer = 15
	fadeDest = 3
end

function onSelectMonsterSwapPopup()
	selectedMonsterSwapIndex = monsterScreenSelectionIdx
end

popupMenuSelectionIdx = 1
local distBetweenPopupOptions <const> = 30
local popupBuffer <const> = 40

function setupPopupMenu(x, y, options, funcs, canCancel)
	popupUp = true
	popupX = x
	popupY = y
	popupWidth = widthOfWidest(options) + popupBuffer
	popupHeight = #options * (gameFont:getHeight() + 16)
	popupOptions = {}
	popupFuncs = {}
	canCancelPopup = canCancel
	for i, v in ipairs(options) do
		popupOptions[i] = v
	end
	for i, v in ipairs(funcs) do
		popupFuncs[i] = v
	end
	popupMenuSelectionIdx = 1
end

function drawPopupMenu()
	drawNiceRect(popupX, popupY, popupWidth, popupHeight)
	for i, v in ipairs(popupOptions) do
		if popupMenuSelectionIdx == i then
			gfx.fillTriangle(popupX + 3, popupY + ((i-1)*distBetweenPopupOptions) + 10, popupX + 18,popupY + 8+ ((i-1)*distBetweenPopupOptions) + 10, popupX + 3, popupY + 16+ ((i-1)*distBetweenPopupOptions) + 10)
		end
		gfx.drawText(v, popupX + 20, popupY + ((i-1)*distBetweenPopupOptions) + 10)
	end
	if canCancel then
		globalBack:draw(popupX + popupWidth - backBtnWidth - 2, popupY + popupHeight - backBtnHeight - 2)
	end
end

function updatePopupMenu()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		popupMenuSelectionIdx -= 1
		if popupMenuSelectionIdx == 0 then
			popupMenuSelectionIdx = #popupOptions
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		popupMenuSelectionIdx += 1
		if popupMenuSelectionIdx > #popupOptions then
			popupMenuSelectionIdx = 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		popupFuncs[popupMenuSelectionIdx]()
		if followTextBoxWithPopup then
			followTextBoxWithPopup = false
			hideTextBox()
		end
		popupUp = false
	elseif playdate.buttonJustPressed(playdate.kButtonB) and canCancel then
		popupUp = false
	end
end

function drawMonsterMenu()
	local index = 1
	for y=0, 1 do
		for x=0, 1 do
			drawMonsterInfoBox(playerMonsters[index],  monsterMenuOuterBuffer + (x * (monsterInfoBoxWidth +  monsterMenuOuterBuffer )),  monsterMenuOuterBuffer  + (y * (monsterInfoBoxHeight +  monsterMenuOuterBuffer )), (monsterScreenSelectionIdx == index or selectedMonsterSwapIndex == index))
			index += 1
		end
	end

	drawBackButton()
end

function updatePartyViewMenu()
	if playdate.buttonJustPressed(playdate.kButtonB) then
		fadeOutTimer = 15
		fadeDest = 0
	end
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		moveVertInPartyView()
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		moveHorizInPartyView()
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		moveVertInPartyView()
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		moveHorizInPartyView()
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		if selectedMonsterSwapIndex ~= nil then
			if selectedMonsterSwapIndex == monsterScreenSelectionIdx then
				selectedMonsterSwapIndex = nil
			else
				local holdingCell = playerMonsters[selectedMonsterSwapIndex]
				playerMonsters[selectedMonsterSwapIndex] = playerMonsters[monsterScreenSelectionIdx]
				playerMonsters[monsterScreenSelectionIdx] = holdingCell
				selectedMonsterSwapIndex = nil
			end
		else
			singleViewMonster = playerMonsters[monsterScreenSelectionIdx]
			local index = 1
			for y=0, 1 do
				for x=0, 1 do
					if index == monsterScreenSelectionIdx then
						setupPopupMenu(monsterMenuOuterBuffer + (x * (monsterInfoBoxWidth +  monsterMenuOuterBuffer )) + 70, monsterMenuOuterBuffer + (y * (monsterInfoBoxHeight +  monsterMenuOuterBuffer )) + 50, monsterMenuPopupOptions, {onSelectMonsterInfoPopup, onSelectMonsterSwapPopup}, true)
					end
					index += 1
				end
			end
		end
	end
end

singleViewScrollAmt = 0

local singleViewImgDrawX <const> = 10
local singleViewImgDrawY <const> = 10

local singleViewNameDrawX <const> = 125
local singleViewNameDrawY <const> = 10

local singleViewLevelDrawX <const> = 125
local singleViewLevelDrawY <const> = 30

local singleViewLevelBarDrawX <const> = 175
local singleViewLevelBarDrawY <const> = 32
local singleViewLevelBarWidth <const> = 60
local singleViewLevelBarHeight <const> = 12

local singleViewHealthDrawX <const> = 125
local singleViewHealthDrawY <const> = 50
local singleViewHealthBarWidth <const> = 80
local singleViewHealthBarHeight <const> = 12

local singleViewTypesDrawX <const> = 250
local singleViewTypesDrawY <const> = 35

local singleViewStatsDrawX <const> = 10
local singleViewStatsDrawY <const> = 125
local singleViewSpaceBetweenStatsVert <const> = 25

local singleViewNatureDrawX <const> = 245
local singleViewNatureDrawY <const> = 65

local singleViewMarkDrawX <const> = 125
local singleViewMarkImgWidth <const> = 60
local singleViewMarkDistBetweenImgAndExplanation = 5
local singleViewMarkDrawY <const> = 90

local singleViewAbilityDrawX <const> = 90
local singleViewAbilityDrawY <const> = 115
local singleViewAbilityBoxWidth <const> = 400 - singleViewAbilityDrawX - textBoxOuterBuffer
local singleViewAbilityBoxHeight <const> = 40

local singleViewMovesDrawX <const> = 95
local singleViewMovesDrawY <const> = 155

local singleViewSingleMoveWidth <const> = 275
local singleViewSingleMoveHeight <const> = 30
local singleViewSingleMoveDistBetween <const> = 5

function drawSingleMonsterViewMove(x, y, move)
	drawNiceRect(x, y, singleViewSingleMoveWidth, singleViewSingleMoveHeight)
	if move ~= nil then
		renderType(move.type, x + 3, y + 3)
		gfx.drawText(move.name, x + 10 + 70, y + 7)
		if move.basePower ~= nil then
			gfx.drawText(move.basePower, x + 230, y + 7)
		else
			gfx.drawText("N/A", x + 230, y + 7)
		end
	end
end

function drawSingleMonsterView()
	singleViewMonster.img:draw(singleViewImgDrawX, singleViewImgDrawY)
	local nameDisplay = singleViewMonster.name
	if singleViewMonster.name ~= singleViewMonster.speciesName then
		nameDisplay = nameDisplay .. " (" .. singleViewMonster.speciesName .. ")"
	end
	gfx.drawText(nameDisplay, singleViewNameDrawX, singleViewNameDrawY)
	gfx.drawText("LV. " .. singleViewMonster.level, singleViewLevelDrawX, singleViewLevelDrawY)
	drawBar(singleViewLevelBarDrawX, singleViewLevelBarDrawY, singleViewLevelBarWidth, singleViewLevelBarHeight, singleViewMonster.exp, xpNeededForLevel(monsterInfo[singleViewMonster.speciesName]["lvlspeed"], singleViewMonster.level+1))
	drawHealthBar(singleViewHealthDrawX, singleViewHealthDrawY, singleViewHealthBarWidth, singleViewHealthBarHeight, singleViewMonster.curHp, singleViewMonster.maxHp)
	renderTypesHoriz(singleViewMonster.types, singleViewTypesDrawX, singleViewTypesDrawY)

	gfx.drawText("ATK: " .. singleViewMonster.attack, singleViewStatsDrawX, singleViewStatsDrawY)
	gfx.drawText("DEF: " .. singleViewMonster.defense, singleViewStatsDrawX, singleViewStatsDrawY + (singleViewSpaceBetweenStatsVert))
	gfx.drawText("SPD: " .. singleViewMonster.speed, singleViewStatsDrawX, singleViewStatsDrawY + (singleViewSpaceBetweenStatsVert*2))

	gfx.drawText("Acts " .. string.lower(singleViewMonster.nature) .. ".", singleViewNatureDrawX, singleViewNatureDrawY)

	if singleViewMonster.mark ~= nil then
		singleViewMonster.mark.img:draw(singleViewMarkDrawX, singleViewMarkDrawY)
		gfx.drawText(singleViewMonster.mark.name .. ": " .. singleViewMonster.mark.description, singleViewMarkDrawX + singleViewMarkImgWidth + singleViewMarkDistBetweenImgAndExplanation, singleViewMarkDrawY)
	end
	
	gfx.drawTextInRect(singleViewMonster.ability.name .. ": " .. singleViewMonster.ability.description, singleViewAbilityDrawX, singleViewAbilityDrawY, singleViewAbilityBoxWidth, singleViewAbilityBoxHeight)

	for i=1, 4 do
		drawSingleMonsterViewMove(singleViewMovesDrawX, singleViewMovesDrawY + ((i-1)*singleViewSingleMoveHeight + (i-1) * singleViewSingleMoveDistBetween), singleViewMonster.moves[i])
	end

	drawBackButton()
end

local singleViewScreenEndScrollAmt <const> = 60

function updateSingleMonsterViewMenu()
	local change, accel = playdate.getCrankChange()
	if change ~= 0 then
		singleViewScrollAmt += change
		if singleViewScrollAmt < 0 then
			singleViewScrollAmt = 0
		end
		if singleViewScrollAmt > singleViewScreenEndScrollAmt then
			singleViewScrollAmt = singleViewScreenEndScrollAmt
		end
		gfx.setDrawOffset(0, -singleViewScrollAmt)
	end
	if playdate.buttonJustPressed(playdate.kButtonB) then
		gfx.setDrawOffset(0, 0)
		skipNextRender = true
		fadeOutTimer = 15
		fadeDest = 2
	end
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		monsterScreenSelectionIdx -= 1
		if monsterScreenSelectionIdx < 1 then
			monsterScreenSelectionIdx = #playerMonsters
		end
		singleViewMonster = playerMonsters[monsterScreenSelectionIdx]
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		monsterScreenSelectionIdx += 1
		if monsterScreenSelectionIdx > #playerMonsters then
			monsterScreenSelectionIdx = 1
		end
		singleViewMonster = playerMonsters[monsterScreenSelectionIdx]
	end
end

function drawTextBox()
	drawNiceRect(textBoxOuterBuffer, textBoxPosY, textBoxWidth, textBoxHeight)
	gfx.drawTextInRect(textBoxDisplayedText, textBoxOuterBuffer + textBoxTextBufferSize, textBoxPosY + textBoxTextBufferSize, textBoxWidth - (textBoxTextBufferSize*2), textBoxHeight - (textBoxTextBufferSize*2))
	
	if textBoxScrollDone and textBoxTimer == 0 and not followTextBoxWithPopup then
		gfx.fillTriangle(400 - (textBoxOuterBuffer * 4), textBoxPosY + (textBoxOuterBuffer * 4), 400 - (textBoxOuterBuffer * 3), textBoxPosY + (textBoxOuterBuffer * 4), 400 - (textBoxOuterBuffer * 3.5), textBoxPosY + (textBoxOuterBuffer * 5))
	end
end

function drawInOverworld()
	overworldTiles:draw(cameraOffsetX, cameraOffsetY)

	for i, v in ipairs(objs) do
		v:render()
	end

	playerImg:draw(playerRenderPosX, playerRenderPosY)

	if menuTimer > 0 or isMenuUp then
		drawMenu()
	end

	if textBoxShown then
		drawTextBox()
	end
end

function render()
	gfx.clear()

	if curScreen == 0 then
		drawInOverworld()
	elseif curScreen == 1 then
		drawMonsterMenu()
	elseif curScreen == 2 then
		drawSingleMonsterView()
	elseif curScreen == 3 then
		drawInCombat()
	end

	if popupUp then
		drawPopupMenu()
	end
end

function canMoveThere(x, y) 
	if x < 1 or y < 1 or x > mapWidth or y > mapHeight then
		return false
	end
	local result = overworldTiles:getTileAtPosition(x, y)
	if (contains(impassables, result)) then
		return false
	end
	for i, v in ipairs(objs) do
		if (v.posX == x and v.posY == y and not v:canMoveHere()) then
			return false
		end
	end
	return true
end

local cameraMoveSpeed <const> = 5

function openMenu()
	menuTimer = 10
	showingMenu = true
	resetMenu()
end

function checkMovement() 
	if (playdate.buttonIsPressed(playdate.kButtonUp)) then
		setPlayerFacing(0)
		if (canMoveThere(playerX, playerY-1)) then
			playerMoveBy(0, -1)
			return
		end
	end
	if (playdate.buttonIsPressed(playdate.kButtonDown)) then
		setPlayerFacing(2)
		if (canMoveThere(playerX, playerY+1)) then
			playerMoveBy(0, 1)
			return
		end
	end
	if (playdate.buttonIsPressed(playdate.kButtonLeft)) then
		setPlayerFacing(3)
		if (canMoveThere(playerX - 1, playerY)) then
			playerMoveBy(-1, 0)
			return
		end
	end
	if (playdate.buttonIsPressed(playdate.kButtonRight)) then
		setPlayerFacing(1)
		if (canMoveThere(playerX + 1, playerY)) then
			playerMoveBy(1, 0)
			return
		end
	end
	if (playdate.buttonJustPressed(playdate.kButtonA)) then
		local tarX, tarY = getPlayerPointCoord()
		for i, v in ipairs(objs) do
			if (v.posX == tarX and v.posY == tarY) then
				v:onInteract()
			end
		end
	end
	if not playdate.isCrankDocked() and not isCrankUp then
		isCrankUp = true
		openMenu()
	end
end

function closeMenu()
	menuTimer = 10
	showingMenu = false
end

function playerMoveBy(x, y)
	if (x ~= 0 or y ~= 0) then
		playerX += x
		playerY += y
		setupCameraOffset()
	end
end

function getPlayerPointCoord()
	if (playerFacing == 0) then
		return playerX, playerY-1
	elseif (playerFacing == 1) then
		return playerX+1, playerY
	elseif (playerFacing == 2) then
		return playerX, playerY+1
	elseif (playerFacing == 3) then
		return playerX-1, playerY
	end
	return playerX, playerY-1
end

function updateCameraOffset()
	if playerRenderPosX == playerDestRenderPosX and playerRenderPosY == playerDestRenderPosY then
		if (cameraOffsetX > cameraDestOffsetX) then
			cameraOffsetX -= cameraMoveSpeed
			if (cameraOffsetX < cameraDestOffsetX) then
				cameraOffsetX = cameraDestOffsetX
			end
		elseif (cameraOffsetX < cameraDestOffsetX) then
			cameraOffsetX += cameraMoveSpeed
			if (cameraOffsetX > cameraDestOffsetX) then
				cameraOffsetX = cameraDestOffsetX
			end
		end
		if (cameraOffsetY > cameraDestOffsetY) then
			cameraOffsetY -= cameraMoveSpeed
			if (cameraOffsetY < cameraDestOffsetY) then
				cameraOffsetY = cameraDestOffsetY
			end
		elseif (cameraOffsetY < cameraDestOffsetY) then
			cameraOffsetY += cameraMoveSpeed
			if (cameraOffsetY > cameraDestOffsetY) then
				cameraOffsetY = cameraDestOffsetY
			end
		end
		if (cameraOffsetX == cameraDestOffsetX and cameraOffsetY == cameraDestOffsetY) then
			movingCam = false
			allowImmediateMovementCheck = true
			for k, v in ipairs(objs) do
				if v.posX == playerX and v.posY == playerY then
					v:onOverlap()
					if not v:allowImmediateMovementAfterStep() then
						allowImmediateMovementCheck = false
					end
				end
			end
			if allowImmediateMovementCheck then
				checkMovement()
			end
		end
	end

	if playerRenderPosX ~= playerDestRenderPosX or playerRenderPosY ~= playerDestRenderPosY then
		if (playerRenderPosX > playerDestRenderPosX) then
			playerRenderPosX -= cameraMoveSpeed
			if (playerRenderPosX < playerDestRenderPosX) then
				playerRenderPosX = playerDestRenderPosX
			end
		elseif playerRenderPosX < playerDestRenderPosX then
			playerRenderPosX += cameraMoveSpeed
			if (playerRenderPosX > playerDestRenderPosX) then
				playerRenderPosX = playerDestRenderPosX
			end
		end
		if (playerRenderPosY > playerDestRenderPosY) then
			playerRenderPosY -= cameraMoveSpeed
			if (playerRenderPosY < playerDestRenderPosY) then
				playerRenderPosY = playerDestRenderPosY
			end
		elseif playerRenderPosY < playerDestRenderPosY then
			playerRenderPosY += cameraMoveSpeed
			if (playerRenderPosY > playerDestRenderPosY) then
				playerRenderPosY = playerDestRenderPosY
			end
		end
		if (playerRenderPosX == playerDestRenderPosX and playerRenderPosY == playerDestRenderPosY) then
			movingCam = false
			allowImmediateMovementCheck = true
			for k, v in ipairs(objs) do
				if v.posX == playerX and v.posY == playerY then
					v:onOverlap()
					if not v:allowImmediateMovementAfterStep() then
						allowImmediateMovementCheck = false
					end
				end
			end
			if allowImmediateMovementCheck then
				checkMovement()
			end
		end
	end
end

local fadeCircEndpoint = math.sqrt(400^2 + 240^2)/2

function renderFade()
	if fadeOutTimer > 0 then
		gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(0, 1, ((15-fadeOutTimer)/14)) * fadeCircEndpoint)
	elseif fadeInTimer > 0 then
		gfx.clear()
		transitionImg:draw(0, 0)
		gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(1, 0, ((15-fadeInTimer)/14)) * fadeCircEndpoint)
	end
end

initialize()