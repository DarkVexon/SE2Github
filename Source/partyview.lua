local monsterMenuOuterBuffer <const> = 3
local monsterInfoBoxWidth <const> = 195
local monsterInfoBoxHeight <const> = 110
local partyMenuHealthBarWidth <const> = 50
local partyMenuHealthBarHeight <const> = 12

monsterScreenSelectionIdx = 1

local monsterMenuPopupOptions <const> = {"Info", "Swap"}

function onSelectMonsterInfoPopup()
	startFade(openSingleMonsterView)
end

function onSelectMonsterSwapPopup()
	selectedMonsterSwapIndex = monsterScreenSelectionIdx
end

function openMonsterScreen()
	if curScreen == 0 then
		monsterScreenSelectionIdx = 1
	end
	if #playerMonsters == 0 then
		monsterScreenSelectionIdx = 0
	end
	curScreen = 1
end

function moveVertInPartyView()
	if monsterScreenSelectionIdx == 1 then
		if #playerMonsters >= 3 then
			menuClicky()
			monsterScreenSelectionIdx = 3
		end
	elseif monsterScreenSelectionIdx == 2 then
		if #playerMonsters >= 4 then
			menuClicky()
			monsterScreenSelectionIdx = 4
		end
	elseif monsterScreenSelectionIdx == 3 then
		menuClicky()
		monsterScreenSelectionIdx = 1
	elseif monsterScreenSelectionIdx == 4 then
		menuClicky()
		monsterScreenSelectionIdx = 2
	end
end

function moveHorizInPartyView()
	if monsterScreenSelectionIdx == 1 then
		if #playerMonsters >= 2 then
			menuClicky()
			monsterScreenSelectionIdx = 2
		end
	elseif monsterScreenSelectionIdx == 2 then
		menuClicky()
		monsterScreenSelectionIdx = 1
	elseif monsterScreenSelectionIdx == 3 then
		if #playerMonsters >= 4 then
			menuClicky()
			monsterScreenSelectionIdx = 4
		end
	elseif monsterScreenSelectionIdx == 4 then
		menuClicky()
		monsterScreenSelectionIdx = 3
	end
end

function drawMonsterInfoBox(monster, x, y, selected)
	if selected then
		drawSelectedRect(x, y, monsterInfoBoxWidth, monsterInfoBoxHeight)
	else
		drawNiceRect(x, y, monsterInfoBoxWidth, monsterInfoBoxHeight)
	end
	if monster ~= nil then
		monster.img:draw(x+5, y+5)
		gfx.drawText(monster.name, x + 105, y + 5)
		gfx.drawText("LV. " .. monster.level, x + 125, y+25)
		drawHealthBar(x + 105, y + 45, partyMenuHealthBarWidth, partyMenuHealthBarHeight, monster.curHp, monster.maxHp)
		drawXpBar(x + 105, y + 80, partyMenuHealthBarWidth, partyMenuHealthBarHeight, monster:curXpProgress(), monster:xpForNext())
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

	if textBoxShown then
		drawTextBox()
	end
end

function updatePartyViewMenu()
	if textBoxShown then
		updateTextBox()
	else
		if playdate.buttonJustPressed(playdate.kButtonB) then
			if invItemToUseOnMonster ~= nil then
				startFade(openBag)
				invItemToUseOnMonster = nil
			else
				startFade(openMainScreen)
			end
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
		if playdate.buttonJustPressed(playdate.kButtonA) and #playerMonsters > 0 then
			if invItemToUseOnMonster ~= nil then
				if invItemToUseOnMonster:canUseOnTarget(playerMonsters[monsterScreenSelectionIdx]) then
					invItemToUseOnMonster:useOutsideCombat(playerMonsters[monsterScreenSelectionIdx])
					invItemToUseOnMonster = nil
				end
			else
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
					if #playerMonsters == 1 then
						fromStorageView = false
						startFade(openSingleMonsterView)
					else
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
		end
	end
end
