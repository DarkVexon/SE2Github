local STORAGE_MENU_PARTY_STARTX <const> = 5
local STORAGE_MENU_PARTY_STARTY <const> = 5

local STORAGE_MENU_PARTY_BLURB_WIDTH <const> = 54
local STORAGE_MENU_PARTY_BLURB_HEIGHT <const> = 54
local STORAGE_MENU_PARTY_BLURB_DISTBETWEEN <const> = 58

local STORAGE_MENU_DIVLINE_X <const> = 70

local STORAGE_NUM_PAGES <const> = 3
local STORAGE_PER_ROW <const> = 5
local STORAGE_PER_BOX <const> = 15

local STORAGE_PAGENAME_X <const> = 100
local STORAGE_PAGENAME_Y <const> = 15
local STORAGE_PAGENAME_WIDTH <const> = 270
local STORAGE_PAGENAME_HEIGHT <const> = 25

local STORAGE_PAGE_X <const> = 80
local STORAGE_PAGE_Y <const> = 50
local STORAGE_PAGE_WIDTH <const> = 300
local STORAGE_PAGE_HEIGHT <const> = 175
local STORAGE_PAGE_MONSTER_STARTX <const> = 80
local STORAGE_PAGE_MONSTER_STARTY <const> = 30
local STORAGE_PAGE_MONSTER_OFFX <const> = 60
local STORAGE_PAGE_ROW_OFFY <const> = 60

local DOWN_CURSOR_IMG <const> = gfx.image.new("img/ui/downCursor")
local HEART_IMG <const> = gfx.image.new("img/ui/heart")

playerStoragePageNames = {"Storage 1", "Storage 2", "Storage 3"}
storageCurPage = 1
storagePrevSelectionIdx = -1
storageSelectionIdx = -1
storageCurrentlySelectedMonster = nil

function openStorageView()
	curScreen = 9
end

function updateStorageView()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		menuClicky()
		if storageSelectionIdx < 0 then
			storageSelectionIdx += 1
			if storageSelectionIdx == 0 then
				storageSelectionIdx = -#playerMonsters
			end
		else
			storageSelectionIdx -= STORAGE_PER_ROW
			if storageSelectionIdx < 0 then
				storageSelectionIdx += (STORAGE_PER_ROW * 3)
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		menuClicky()
		if storageSelectionIdx < 0 then
			storageSelectionIdx -= 1
			if storageSelectionIdx < -#playerMonsters then
				storageSelectionIdx = -1
			end
		else
			storageSelectionIdx += STORAGE_PER_ROW
			if storageSelectionIdx > STORAGE_PER_ROW * 3 then
				storageSelectionIdx -= (STORAGE_PER_ROW * 3)
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		menuClicky()
		if storageSelectionIdx < 0 then
			if storageSelectionIdx == -1 or storageSelectionIdx == -2 then
				storageSelectionIdx = 5
			else
				storageSelectionIdx = 5 + STORAGE_PER_ROW
			end
		else
			storageSelectionIdx -= 1
			if storageSelectionIdx % STORAGE_PER_ROW == 0 then
				storageSelectionIdx = -1
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		menuClicky()
		if storageSelectionIdx < 0 then
			if storageSelectionIdx == -1 or storageSelectionIdx == -2 then
				storageSelectionIdx = 1
			else
				storageSelectionIdx = 1 + STORAGE_PER_ROW
			end
		else
			storageSelectionIdx += 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		menuClicky()
		if storageCurrentlySelectedMonster ~= nil then
			if storageSelectionIdx < 0 then
				if selectedFromPc then
					-- PC to party
					local stored = playerMonsters[storageSelectionIdx * -1]
					playerMonsters[storageSelectionIdx * -1] = storageCurrentlySelectedMonster
					playerMonsterStorage[storageCurSelectionIdx] = stored
				else
					-- party to party
					local stored = playerMonsters[storageSelectionIdx * -1]
					playerMonsters[storageSelectionIdx * -1] = storageCurrentlySelectedMonster
					playerMonsters[storageCurSelectionIdx * -1] = stored
				end
			else
				if selectedFromPc then
					-- PC to PC
					local stored = playerMonsterStorage[storageSelectionIdx]
					playerMonsterStorage[storageSelectionIdx] = storageCurrentlySelectedMonster
					playerMonsterStorage[storageCurSelectionIdx] = stored
				else
					-- Party to PC
					local stored = playerMonsterStorage[storageSelectionIdx]
					if stored ~= nil or #playerMonsters > 1 then
						playerMonsterStorage[storageSelectionIdx] = storageCurrentlySelectedMonster
						if stored ~= nil then
							playerMonsters[storageCurSelectionIdx * -1] = stored
						else
							removeFromParty(playerMonsters[storageCurSelectionIdx * -1])
						end
					end
				end
			end
			storageCurrentlySelectedMonster = nil
			storageCurSelectionIdx = 0
		else
			if storageSelectionIdx <= #playerMonsterStorage then
				setupPopupMenu(getCursorX(storageSelectionIdx), getCursorY(storageSelectionIdx), {"Move", "Summary", "Heart"}, {
					function () 
						if storageSelectionIdx < 0 then
							storageCurrentlySelectedMonster = playerMonsters[storageSelectionIdx * -1]
							storageCurSelectionIdx = storageSelectionIdx
							selectedFromPc = false
						else
							storageCurrentlySelectedMonster = playerMonsterStorage[storageSelectionIdx]
							storageCurSelectionIdx = storageSelectionIdx
							selectedFromPc = true
						end
					end,

					function ()
						fromStorageView = true
						if storageSelectionIdx < 0 then
							singleViewMonster = playerMonsters[storageSelectionIdx * -1]
						else
							singleViewMonster = playerMonsterStorage[storageSelectionIdx]
						end
						startFade(openSingleMonsterView)
					end,

					function ()
						if storageSelectionIdx < 0 then
							playerMonsters[storageSelectionIdx * -1].heart = not playerMonsters[storageSelectionIdx * -1].heart
						else
							playerMonsterStorage[storageSelectionIdx].heart = not playerMonsterStorage[storageSelectionIdx].heart
						end
					end
				}, true)
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonB) then
		startFade(openMainScreen)
	end
end

function drawStoragePartyBox(monster, x, y)
	drawNiceRect(x, y, STORAGE_MENU_PARTY_BLURB_WIDTH, STORAGE_MENU_PARTY_BLURB_HEIGHT)
	monster.img:drawScaled(x + 2, y + 2, 0.5)
	if monster.heart then
		HEART_IMG:draw(x + 8, y + 8)
	end
	if storageCurrentlySelectedMonster == monster then
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillRoundRect(x + (BOX_OUTLINE_SIZE/2), y + (BOX_OUTLINE_SIZE/2), STORAGE_MENU_PARTY_BLURB_WIDTH - BOX_OUTLINE_SIZE, STORAGE_MENU_PARTY_BLURB_HEIGHT - BOX_OUTLINE_SIZE, BOX_OUTLINE_SIZE)
		gfx.setColor(gfx.kColorBlack)
	end
end

function getCursorX(index)
	if index < 0 then
		return STORAGE_MENU_PARTY_STARTX + 10
	else
		return STORAGE_PAGE_MONSTER_STARTX + ((STORAGE_PAGE_MONSTER_OFFX * (((index-1) % STORAGE_PER_ROW+1)))) - 50
	end
end

function getCursorY(index)
	if index < 0 then
		return STORAGE_MENU_PARTY_STARTY + (((index * -1) -1) * (STORAGE_MENU_PARTY_BLURB_DISTBETWEEN)) - 10 + (math.sin(bobTime))
	else
		return STORAGE_PAGE_MONSTER_STARTY + (STORAGE_PAGE_ROW_OFFY * math.floor((index-1) / STORAGE_PER_ROW)) + 12 + (math.sin(bobTime))
	end
end

function getStorageXPos(index)
	return STORAGE_PAGE_MONSTER_STARTX + (((index-1) % STORAGE_PER_ROW)) * STORAGE_PAGE_MONSTER_OFFX + 5
end

function getStorageYPos(index)
	return STORAGE_PAGE_MONSTER_STARTY + (math.floor((index-1)/STORAGE_PER_ROW)) * STORAGE_PAGE_ROW_OFFY + 25
end

function drawStorageView()
	for i=1, 4 do
		if i <= #playerMonsters then
			local boxY = STORAGE_MENU_PARTY_STARTY + (i-1) * STORAGE_MENU_PARTY_BLURB_DISTBETWEEN
			drawStoragePartyBox(playerMonsters[i], STORAGE_MENU_PARTY_STARTX, boxY)
		end
	end

	gfx.drawLine(STORAGE_MENU_DIVLINE_X, 0, STORAGE_MENU_DIVLINE_X, 240)

	drawNiceRect(STORAGE_PAGENAME_X, STORAGE_PAGENAME_Y, STORAGE_PAGENAME_WIDTH, STORAGE_PAGENAME_HEIGHT)
	gfx.drawTextAligned(playerStoragePageNames[storageCurPage], STORAGE_PAGENAME_X + (STORAGE_PAGENAME_WIDTH/2), STORAGE_PAGENAME_Y + 5, kTextAlignment.center)

	drawNiceRect(STORAGE_PAGE_X, STORAGE_PAGE_Y, STORAGE_PAGE_WIDTH, STORAGE_PAGE_HEIGHT)
	for i=((storageCurPage-1) * STORAGE_PER_BOX) + 1, (storageCurPage * STORAGE_PER_BOX) + 1 do
		if playerMonsterStorage[i] ~= nil then
			local monX = getStorageXPos(i % STORAGE_PER_BOX)
			local monY = getStorageYPos(i % STORAGE_PER_BOX)
			playerMonsterStorage[i].img:drawScaled(monX, monY, 0.5)
			if playerMonsterStorage[i].heart then
				HEART_IMG:draw(monX + 6, monY + 6)
			end
			if storageCurrentlySelectedMonster == playerMonsterStorage[i] then
				gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
				gfx.fillRoundRect(monX + (BOX_OUTLINE_SIZE/2), monY + (BOX_OUTLINE_SIZE/2), 50 - BOX_OUTLINE_SIZE, 50 - BOX_OUTLINE_SIZE, BOX_OUTLINE_SIZE)
				gfx.setColor(gfx.kColorBlack)
			end
		end
	end

	local posX = getCursorX(storageSelectionIdx)
	local posY = getCursorY(storageSelectionIdx)
	if storagePrevSelectionIdx ~= storageSelectionIdx then
		local tarX = (posX + getCursorX(storagePrevSelectionIdx)) / 2
		local tarY = (posY + getCursorY(storagePrevSelectionIdx)) / 2
		DOWN_CURSOR_IMG:draw(tarX, tarY)
		storagePrevSelectionIdx = storageSelectionIdx
	else
		DOWN_CURSOR_IMG:draw(posX, posY)
	end

	drawBackButton()
end
