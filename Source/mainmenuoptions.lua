local MAIN_MENU_OPTIONS_X <const> = 15
local MAIN_MENU_OPTIONS_Y <const> = 15
local MAIN_MENU_OPTIONS <const> = {"New Game", "Continue", "Quick Battle"}
local MAIN_MENU_OPTIONS_WIDTH <const> = 135
local MAIN_MENU_OPTIONS_HEIGHT <const> = 20

function openMainMenuOptions()
	curScreen = 11
	mainMenuOptionsSelectedIdx = 2
end

function drawMainMenuOption(option, x, y, selected)
	gfx.drawText(option, x, y)
	local width = gfx.getTextSize(option) + 6
	if selected then
		gfx.setColor(gfx.kColorXOR)
		gfx.fillRoundRect(x - 3, y - 2, width, 22, 2)
		gfx.setColor(gfx.kColorBlack)
	end
end

function updateMainMenuOptionScreen()
	if textBoxShown then
		updateTextBox()
	else
		if playdate.buttonJustPressed(playdate.kButtonA) then
			if mainMenuOptionsSelectedIdx == 1 then
				newGame()
			elseif mainMenuOptionsSelectedIdx == 2 then
				loadSave()
			elseif mainMenuOptionsSelectedIdx == 3 then
				quickBattle()
			end
		elseif playdate.buttonJustPressed(playdate.kButtonUp) then
			mainMenuOptionsSelectedIdx -= 1
			if mainMenuOptionsSelectedIdx == 0 then
				mainMenuOptionsSelectedIdx = #MAIN_MENU_OPTIONS
			end
		elseif playdate.buttonJustPressed(playdate.kButtonDown) then
			mainMenuOptionsSelectedIdx += 1
			if mainMenuOptionsSelectedIdx > #MAIN_MENU_OPTIONS then
				mainMenuOptionsSelectedIdx = 1
			end
		end
	end
end

function drawMainMenuOptionScreen()
	drawNiceRect(MAIN_MENU_OPTIONS_X, MAIN_MENU_OPTIONS_Y, MAIN_MENU_OPTIONS_WIDTH, MAIN_MENU_OPTIONS_HEIGHT + (#MAIN_MENU_OPTIONS * 25))
	--TODO: If save exists
	for i, v in ipairs(MAIN_MENU_OPTIONS) do
		drawMainMenuOption(MAIN_MENU_OPTIONS[i], MAIN_MENU_OPTIONS_X + 10, MAIN_MENU_OPTIONS_Y + (i-1) * 30 + 10, mainMenuOptionsSelectedIdx == i)
	end

	if textBoxShown then
		drawTextBox()
	end
end