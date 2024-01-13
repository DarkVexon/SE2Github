local DEX_SINGLE_MONSTER_IMG_POS_X <const> = 275
local DEX_SINGLE_MONSTER_IMG_POS_Y <const> = (240/2) - 50

local DEX_DESCRIPTION_POS_X <const> = 15
local DEX_DESCRIPTION_POS_Y <const> = 100
local DEX_DESCRIPTION_BOX_WIDTH <const> = 300
local DEX_DESCRIPTION_BOX_HEIGHT <const> = 50

dexSingleScrollAmt = 0

function openDexSingleView()
	curScreen = 8
	dexSingleScrollAmt = 0
end

function updateDexSingleView()
	if textBoxShown then
		updateTextBox()
	else
		if dexFromCapture then
			if playdate.buttonJustPressed(playdate.kButtonA) then
				dexFromCapture = false
				nextScript()
			end
		else
			if playdate.buttonJustPressed(playdate.kButtonB) then
				startFade(openDexMenu)
			end
		end
	end
end

function drawDexSingleView()
	monsterImgs[dexSelectedSpecies]:draw(DEX_SINGLE_MONSTER_IMG_POS_X, DEX_SINGLE_MONSTER_IMG_POS_Y)
	gfx.drawInRect(monsterInfo[dexSelectedSpecies].description, DEX_DESCRIPTION_POS_X, DEX_DESCRIPTION_POS_Y, DEX_DESCRIPTION_BOX_WIDTH, DEX_DESCRIPTION_BOX_HEIGHT)
	if textBoxShown then
		drawTextBox()
	end
end