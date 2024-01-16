local OPTIONS_MENU_X <const> = 15
local OPTIONS_MENU_Y <const> = 40
local OPTIONS_MENU_DISTBETWEEN <const> = 25



fastMode = false
isDebug = false

function getDebugMode()
	return isDebug
end

function getFastMode()
	return fastMode
end

function setFastMode()
	fastMode = not fastMode
	if newFastMode then
		transitionTimer = 6
	else
		transitionTimer = 15
	end
end

function setDebugMode()
	isDebug = not isDebug
end

MENU_OPTIONS = {
["Fast Mode"] = {getFastMode, setFastMode}, ["Debug Mode"] = {getDebugMode, setDebugMode}
}

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
		valueAtIndex(MENU_OPTIONS, optionsMenuSelectionIdx)[2]()
	elseif playdate.buttonJustPressed(playdate.kButtonB) then
		startFade(openMainScreen)
	end
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		optionsMenuSelectionIdx -= 1
		if optionsMenuSelectionIdx == 0 then
			optionsMenuSelectionIdx = numKeys(MENU_OPTIONS)
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		optionsMenuSelectionIdx += 1
		if optionsMenuSelectionIdx > numKeys(MENU_OPTIONS) then
			optionsMenuSelectionIdx = 1
		end
	end
end

function drawOptionsMenu()
	gfx.drawTextAligned("OPTIONS", 400/2, 10, kTextAlignment.center)

	local index = 1
	for k, v in pairs(MENU_OPTIONS) do
		local result = v[1]
		gfx.drawText(k .. ": " .. onOrOff(result()), OPTIONS_MENU_X, OPTIONS_MENU_Y + (index-1) * (OPTIONS_MENU_DISTBETWEEN))
		if optionsMenuSelectionIdx == index then
			gfx.setColor(gfx.kColorXOR)
			gfx.fillRoundRect(OPTIONS_MENU_X - 5, OPTIONS_MENU_Y + (index-1) * (OPTIONS_MENU_DISTBETWEEN) - 2, 200, 20, 2)
			gfx.setColor(gfx.kColorBlack)
		end
		index += 1
	end

	drawBackButton()
end