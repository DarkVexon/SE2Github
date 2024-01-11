local queryDropdownX <const> = 300
local queryDropdownY <const> = 100
local textBoxPosY <const> = 165

local textBoxTextBufferSize <const> = 4
local textBoxWidth <const> = 400 - (GLOBAL_BEZEL * 2)
local textBoxHeight <const> = 240 - textBoxPosY - (GLOBAL_BEZEL)

textBoxTimer = 0
textBoxText = ""
textBoxShown = false
textBoxScrollDone = false
textBoxTotalTime = 0

function showTextBox(text)
	textBoxText = text
	textBoxDisplayedText = ""
	textBoxShown = true
	textBoxScrollDone = false
	textBoxLetterIndex = 0
end

function showTimedTextBox(text, time)
	showTextBox(text)
	textBoxTimer = time
end

function showQueryTextBox(text, options, funcs)
	showTextBox(text)
	followTextBoxWithPopup = true
	textBoxFollowUpOptions = options
	textBoxFollowUpFuncs = funcs
end

function hideTextBox()
	textBoxShown = false
	nextScript()
end

function updateTextBox()
	if textBoxScrollDone then
		if textBoxTimer > 0 then
			textBoxTimer -= 1
			if textBoxTimer == 0 then
				hideTextBox()
			end
		elseif followTextBoxWithPopup then
			setupPopupMenu(queryDropdownX, queryDropdownY, textBoxFollowUpOptions, textBoxFollowUpFuncs, false)
		else
			if playdate.buttonJustPressed(playdate.kButtonA) then
				hideTextBox()
			end
		end
	else
		if playdate.buttonJustPressed(playdate.kButtonB) and textBoxTimer == 0 then
			textBoxDisplayedText = textBoxText
			textBoxScrollDone = true
		else
			local numLettersToAdd
			if playdate.buttonIsPressed(playdate.kButtonA) then
				numLettersToAdd = 2
			else
				numLettersToAdd = 1
			end
			for i=1, numLettersToAdd do
				textBoxDisplayedText = textBoxDisplayedText .. string.sub(textBoxText, textBoxLetterIndex, textBoxLetterIndex)
				textBoxLetterIndex += 1
				if textBoxLetterIndex > #textBoxText then
					textBoxScrollDone = true
				end
			end
		end
	end
end

function drawTextBox()
	drawNiceRect(GLOBAL_BEZEL, textBoxPosY, textBoxWidth, textBoxHeight)
	gfx.drawTextInRect(textBoxDisplayedText, GLOBAL_BEZEL + textBoxTextBufferSize, textBoxPosY + textBoxTextBufferSize, textBoxWidth - (textBoxTextBufferSize*2), textBoxHeight - (textBoxTextBufferSize*2))
	
	if textBoxScrollDone and textBoxTimer == 0 and not followTextBoxWithPopup then
		downFacingTriangle(400 - (GLOBAL_BEZEL * 3), textBoxPosY + (GLOBAL_BEZEL * 5)+ (math.sin(bobTime * 3)), 10)
	end
end

function drawCombatTextBox()
	drawCombatBottomBg()

	gfx.drawTextInRect(textBoxDisplayedText, GLOBAL_BEZEL + textBoxTextBufferSize, combatTextBoxPosY + textBoxTextBufferSize, textBoxWidth - (textBoxTextBufferSize*2), combatTextBoxHeight - (textBoxTextBufferSize*2))
	
	if textBoxScrollDone and textBoxTimer == 0 then
		downFacingTriangle(400 - (GLOBAL_BEZEL * 2), textBoxPosY + (GLOBAL_BEZEL * 6) + (math.sin(bobTime * 3)), 10)
	end
end