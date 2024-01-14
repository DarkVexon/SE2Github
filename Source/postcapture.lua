CAPTURED_MONSTER_POS_X = (400/2) - 50
KEYBOARD_MONSTER_POS_X = CAPTURED_MONSTER_POS_X - 100
local CAUGHT_MONSTER_POS_Y <const> = (200/2)-50
local MARK_OFFSET_FROM_MONSTER_X <const> = -150
local MARK_OFFSET_FROM_MONSTER_Y <const> = -25
postCaptureMonsterPosX = CAPTURED_MONSTER_POS_X

function openPostCaptureScreen()
	curScreen = 5
	setupPostCapturePrompts()
	nextScript()
end

function openKeyboardMode()
	addScript(StartAnimScript(MoveCapturedMonsterAnim(true)))
	addScript(GameScript(function() playdate.keyboard.show(caughtMonster.name) keyboardShown = true end))
	addScript(StartAnimScript(MoveCapturedMonsterAnim(false)))
	nextScript()
end

function postNicknameChoice()
	if #playerMonsters < 4 then
		addScript(GameScript(function() table.insert(playerMonsters, caughtMonster) nextScript() end))
		addScript(TextScript("Welcome to the team, " .. caughtMonster.name .. "!"))
	else
		addScript(GameScript(function() table.insert(playerMonsterStorage, caughtMonster) nextScript() end))
		addScript(TextScript(caughtMonster.name .. " was sent to the DOUBLE SHADOW GOVERNMENT!"))
	end
	addScript(OneParamScript(TransitionScript, openMainScreen))
	nextScript()
end

function setupPostCapturePrompts()
	addScript(QueryScript("Want to nickname the caught " .. caughtMonster.name .. "?", {"Yes", "No"}, {openKeyboardMode, postNicknameChoice}))
end

function updatePostCaptureScreen()
	if textBoxShown then
		updateTextBox()
	else
		if curAnim ~= nil then
			curAnim:update()
			if curAnim.isDone then
				curAnim = nil
				nextScript()
			end
		end
	end
end

function onKbHide()
	keyboardShown = false
	caughtMonster.name = playdate.keyboard.text
	postNicknameChoice()
end

playdate.keyboard.keyboardDidHideCallback = onKbHide

function drawPostCaptureScreen()
	caughtMonster.img:draw(postCaptureMonsterPosX, CAUGHT_MONSTER_POS_Y)
	if caughtMonster.mark ~= nil then
		caughtMonster.mark.img:draw(postCaptureMonsterPosX + MARK_OFFSET_FROM_MONSTER_X, CAUGHT_MONSTER_POS_Y + MARK_OFFSET_FROM_MONSTER_Y)
		gfx.drawText(caughtMonster.mark.name .. ": " .. caughtMonster.mark.description, postCaptureMonsterPosX + MARK_OFFSET_FROM_MONSTER_X + singleViewMarkImgWidth + singleViewMarkDistBetweenImgAndExplanation, CAUGHT_MONSTER_POS_Y + MARK_OFFSET_FROM_MONSTER_Y)
	end
	if keyboardShown then
		gfx.drawText(playdate.keyboard.text, 75, 175)
	end
	if textBoxShown then
		drawTextBox()
	end
end