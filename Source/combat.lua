local combatMoveInfoPanelStartX <const> = 5
local combatMoveInfoPanelDescWidth <const> = 295
local combatMoveInfoPanelDescHeight <const> = 45

local enemyMonsterPanelDrawX <const> = 275
local enemyMonsterPanelDrawY <const> = 10

local playerMonsterPanelDrawX <const> = 15
local playerMonsterPanelDrawY <const> = 10

local monsterPanelHpBarWidth <const> = 60
local monsterPanelHpBarHeight <const> = 12

combatMenuChoices = {"Moves", "Bag", "Swap", "Run"}

local combatTextBoxPosY = 190
local combatTextBoxHeight = 240 - combatTextBoxPosY - GLOBAL_BEZEL

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

local postKOChoices <const> = {"Swap", "Flee"}

combatIntroAnimTimers = {40, 12, 15}

playerCombatImg = gfx.image.new("img/combatPlayer")


combatSubmenuChosen = 0
combatPrevSubmenu = -1
tissueTimer = 0
tissueMenuShown = false

combatMenuChoiceY = combatMenuOptionsStartY
combatInfoPanY = 240
movesExecuting = false

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

function hideTissue()
	combatPrevSubmenu = combatSubmenuChosen
	combatSubmenuChosen = 0
	tissueTimer = tissueShowHideTimer
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
					hideTissue()
					swapToExecution = true
					if playerMonster.speed > enemyMonster.speed then
						playerMonster:useMove(playerMonster.moves[tissueSelectionIdx], enemyMonster)
						enemyIncomingMove = enemyMonster:chooseMove()
						addScript(GameScript(
							function()
								if enemyMonster.curHp > 0 then
									enemyMonster:useMove(enemyIncomingMove, playerMonster)
								end
								nextScript()
							end
							)
						)
					elseif enemyMonster.speed > playerMonster.speed then
						playerIncomingMove = playerMonster.moves[tissueSelectionIdx]
						enemyMonster:useMove(enemyMonster:chooseMove(), playerMonster)
						addScript(GameScript(
							function()
								if playerMonster.curHp > 0 then
									playerMonster:useMove(playerIncomingMove, enemyMonster)
								end
								nextScript()
							end
							)
						)
					else
						if math.random(0, 1) == 0 then
							playerMonster:useMove(playerMonster.moves[tissueSelectionIdx], enemyMonster)
							enemyIncomingMove = enemyMonster:chooseMove()
							addScript(GameScript(
								function()
									if enemyMonster.curHp > 0 then
										enemyMonster:useMove(enemyIncomingMove, playerMonster)
									end
									nextScript()
								end
								)
							)
						else
							playerIncomingMove = playerMonster.moves[tissueSelectionIdx]
							enemyMonster:useMove(enemyMonster:chooseMove(), playerMonster)
							addScript(GameScript(
								function()
									if playerMonster.curHp > 0 then
										playerMonster:useMove(playerIncomingMove, enemyMonster)
									end
									nextScript()
								end
								)
							)
						end
					end

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

function drawCombatMonsterData(x, y, monster)
	gfx.drawText(monster.name, x, y)
	gfx.drawText("LV. " .. monster.level, x + 15, y + 20)
	drawHealthBar(x + 5, y + 40, monsterPanelHpBarWidth, monsterPanelHpBarHeight, monster.dispHp, monster.maxHp)
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


function drawFullMoveInfo(move, x, y)
	renderType(move.type, x, y + 8)
	gfx.drawTextInRect(move.description, x + typeImgWidth + 5, y, combatMoveInfoPanelDescWidth, combatMoveInfoPanelDescHeight)
	if move.basePower ~= nil then
		gfx.drawText("" .. move.basePower, x + typeImgWidth + 5 + combatMoveInfoPanelDescWidth - 8, y + 12)
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