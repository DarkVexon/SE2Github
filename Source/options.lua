local OPTIONS_MENU_FASTMODE_X <const> = 15
local OPTIONS_MENU_FASTMODE_Y <const> = 40
local NUMBER_OF_OPTIONS <const> = 1

fastMode = false

function setFastMode(newFastMode)
	fastMode = newFastMode
	if newFastMode then
		transitionTimer = 6
	else
		transitionTimer = 15
	end
end

function onOrOff(input)
	if input then
		return "ON"
	else
		return "OFF"
	end
end

function openOptionsMenu()
	curScreen = 6
	optionsMenuSelectionIdx = 1
end

function updateOptionsMenu()
	if playdate.buttonJustPressed(playdate.kButtonA) then
		if optionsMenuSelectionIdx == 1 then
			setFastMode(not fastMode)
		end
	elseif playdate.buttonJustPressed(playdate.kButtonB) then
		startFade(openMainScreen)
	end
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		optionsMenuSelectionIdx -= 1
		if optionsMenuSelectionIdx == 0 then
			optionsMenuSelectionIdx = NUMBER_OF_OPTIONS
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		optionsMenuSelectionIdx += 1
		if optionsMenuSelectionIdx > NUMBER_OF_OPTIONS then
			optionsMenuSelectionIdx = 1
		end
	end
end

function drawOptionsMenu()
	gfx.drawTextAligned("OPTIONS", 400/2, 10, kTextAlignment.center)

	gfx.drawText("Fast Mode: " .. onOrOff(fastMode), OPTIONS_MENU_FASTMODE_X, OPTIONS_MENU_FASTMODE_Y)
	if optionsMenuSelectionIdx == 1 then
		gfx.setColor(gfx.kColorXOR)
		gfx.fillRoundRect(OPTIONS_MENU_FASTMODE_X - 5, OPTIONS_MENU_FASTMODE_Y - 2, 153, 20, 2)
		gfx.setColor(gfx.kColorBlack)
	end

	drawBackButton()
end