local DEX_IMG_POS_X <const> = 275
local DEX_IMG_POS_Y <const> = (240/2) - 100

local DEX_DESCRIPTION_POS_X <const> = 15
local DEX_DESCRIPTION_POS_Y <const> = 130
local DEX_DESCRIPTION_BOX_WIDTH <const> = 370
local DEX_DESCRIPTION_BOX_HEIGHT <const> = 150
local DEX_DESCRIPTION_BOX_BUFFER <const> = 3

local DEX_BASICINFO_X <const> = 20
local DEX_BASICINFO_Y <const> = 15
local DEX_BASICINFO_WIDTH <const> = 180
local DEX_BASICINFO_HEIGHT <const> = 20
local DEX_BASICINFO_STOPX <const> = DEX_IMG_POS_X - 10
local DEX_BASICINFO_STOPY <const> = DEX_IMG_POS_Y + 25
local DEX_TYPEINFO_OFFSETY <const> = 25

local DEX_ABILITY_X <const> = 20
local DEX_ABILITY_Y <const> = 70

local DEX_LOCATION_X <const> = 20
local DEX_LOCATION_Y <const> = 100

local DEX_MAX_SCROLL <const> = 50

dexSingleScrollAmt = 0

function openDexSingleView()
	curScreen = 8
	dexSingleScrollAmt = 0
	gfx.setDrawOffset(0, 0)
end

function updateDexSingleView()
	if playdate.buttonJustPressed(playdate.kButtonB) then
		menuClicky()
		startFade(openDexMenu)
		gfx.setDrawOffset(0, 0)
	end
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		if dexSelectedIdx > 1 then
			menuClicky()
			dexSelectedIdx -= 1
			dexSelectedSpecies = dexItems[dexSelectedIdx]
			gfx.setDrawOffset(0, 0)
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		if dexSelectedIdx < #dexItems then
			menuClicky()
			dexSelectedIdx += 1
			dexSelectedSpecies = dexItems[dexSelectedIdx]
			gfx.setDrawOffset(0, 0)
		end
	end
	local change, accel = playdate.getCrankChange()
	if change ~= 0 then
		dexSingleScrollAmt += change
		if dexSingleScrollAmt < 0 then
			dexSingleScrollAmt = 0
		end
		if dexSingleScrollAmt > DEX_MAX_SCROLL then
			dexSingleScrollAmt = DEX_MAX_SCROLL
		end
		gfx.setDrawOffset(0, -dexSingleScrollAmt)
	end
end

function drawDexSingleView()
	gfx.drawText("#" .. dexSelectedIdx .. " " .. dexSelectedSpecies, DEX_BASICINFO_X, DEX_BASICINFO_Y)

	gfx.drawLine(DEX_BASICINFO_X, DEX_BASICINFO_Y + DEX_BASICINFO_HEIGHT, DEX_BASICINFO_X + DEX_BASICINFO_WIDTH, DEX_BASICINFO_Y + DEX_BASICINFO_HEIGHT)
	gfx.drawLine(DEX_BASICINFO_X + DEX_BASICINFO_WIDTH, DEX_BASICINFO_Y + DEX_BASICINFO_HEIGHT, DEX_BASICINFO_STOPX, DEX_BASICINFO_STOPY)

	renderTypesHoriz(getDefaultTypes(dexSelectedSpecies), DEX_BASICINFO_X, DEX_BASICINFO_Y + DEX_TYPEINFO_OFFSETY)

	if playerDex[dexSelectedSpecies] == 2 then
		gfx.drawText("Ability: " .. getDefaultAbility(dexSelectedSpecies), DEX_ABILITY_X, DEX_ABILITY_Y)
	else
		gfx.drawText("Ability: ???", DEX_ABILITY_X, DEX_ABILITY_Y)
	end

	if playerDex[dexSelectedSpecies] == 2 then
		gfx.drawText("Found in " .. monsterInfo[dexSelectedSpecies].location .. ".", DEX_LOCATION_X, DEX_LOCATION_Y)
	else
		gfx.drawText("Spotted in " .. monsterInfo[dexSelectedSpecies].locationHint .. ".", DEX_LOCATION_X, DEX_LOCATION_Y)
	end

	monsterImgs[dexSelectedSpecies]:draw(DEX_IMG_POS_X, DEX_IMG_POS_Y)


	drawNiceRect(DEX_DESCRIPTION_POS_X, DEX_DESCRIPTION_POS_Y, DEX_DESCRIPTION_BOX_WIDTH, DEX_DESCRIPTION_BOX_HEIGHT)
	
	if playerDex[dexSelectedSpecies] == 2 then
		gfx.drawTextInRect(monsterInfo[dexSelectedSpecies].description, DEX_DESCRIPTION_POS_X + DEX_DESCRIPTION_BOX_BUFFER, DEX_DESCRIPTION_POS_Y + DEX_DESCRIPTION_BOX_BUFFER, DEX_DESCRIPTION_BOX_WIDTH - (DEX_DESCRIPTION_BOX_BUFFER*2), DEX_DESCRIPTION_BOX_HEIGHT- (DEX_DESCRIPTION_BOX_BUFFER*2))
	else
		gfx.drawTextAligned("???", DEX_DESCRIPTION_POS_X + DEX_DESCRIPTION_BOX_BUFFER + (DEX_DESCRIPTION_BOX_WIDTH / 2), DEX_DESCRIPTION_POS_Y + DEX_DESCRIPTION_BOX_BUFFER*2, kTextAlignment.center)
	end
end