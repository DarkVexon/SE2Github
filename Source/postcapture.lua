function openPostCaptureScreen()
	curScreen = 5
	setupPostCapturePrompts()
	nextScript()
end

function openKeyboardMode()
	playdate.keyboard.show(caughtMonster.name)
	keyboardShown = true
end

function postNicknameChoice()
	if #playerMonsters < 4 then
		addScript(GameScript(function() table.insert(playerMonsters, caughtMonster) nextScript() end))
		addScript(TextScript("Welcome to the team, " .. caughtMonster.name .. "!"))
	else
		addScript(GameScript(function() table.insert(playerMonsterStorage, caughtMonster) nextScript() end))
		addScript(TextScript(caughtMonster.name .. " was sent to the DOUBLE SHADOW GOVERNMENT!"))
	end
	addScript(OneParamScript(screenChangeScript, openMainScreen))
	nextScript()
end

function setupPostCapturePrompts()
	addScript(QueryScript("Want to nickname the caught " .. caughtMonster.name .. "?", {"Yes", "No"}, {openKeyboardMode, postNicknameChoice}))
end

function updatePostCaptureScreen()
	if textBoxShown then
		updateTextBox()
	else
		
	end
end

function onKbHide()
	keyboardShown = false
	caughtMonster.name = playdate.keyboard.text
	postNicknameChoice()
end

playdate.keyboard.keyboardDidHideCallback = onKbHide

function drawPostCaptureScreen()
	caughtMonster.img:draw((400/2)-50, (200/2)-50)
	if keyboardShown then
		gfx.drawText(playdate.keyboard.text, 75, 175)
	end
	if textBoxShown then
		drawTextBox()
	end
end