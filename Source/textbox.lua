local queryDropdownX <const> = 300
local queryDropdownY <const> = 100
local textBoxPosY <const> = 165

local textBoxTextBufferSize <const> = 4
local textBoxWidth <const> = 400 - (GLOBAL_BEZEL * 2)
local textBoxHeight <const> = 240 - textBoxPosY - (GLOBAL_BEZEL)

local TEXT_BOX_ROW_WIDTH <const> = textBoxWidth - (textBoxTextBufferSize*2)

textBoxTimer = 0
textBoxText = ""
textBoxShown = false
textBoxScrollDone = false
textBoxTotalTime = 0

function parseIntoRows(text)
	local rows = {}
	local widthOfText = gfx.getTextSize(text)
	if widthOfText <= TEXT_BOX_ROW_WIDTH then
		table.insert(rows, text)
		return rows
	else
		local curWidthSum = 0
		for test in text:gmatch("%S+") do
			local wordWidth = gfx.getTextSize(" " .. test)
			if curWidthSum + wordWidth > TEXT_BOX_ROW_WIDTH or curWidthSum == 0 then
				curWidthSum = wordWidth
				table.insert(rows, test)
			else
				rows[#rows] = rows[#rows] .. " " .. test
				curWidthSum += wordWidth
			end
		end
	end
	return rows
end

function showTextBox(text)
	textBoxText = text
	textBoxTextRows = parseIntoRows(text)
	textBoxDisplayedText = {}
	for i=1, #textBoxTextRows do
		table.insert(textBoxDisplayedText, "")
	end
	textBoxShown = true
	textBoxScrollDone = false
	textBoxLetterIndex = 0
	callScriptAfterHideTextBox = true
	curTextBoxRow = 1
end

function showTimedTextBox(text, time)
	showTextBox(text)
	textBoxTimer = time
end

function showQueryTextBox(text, options, funcs, canCancel)
	showTextBox(text)
	followTextBoxWithPopup = true
	textBoxFollowUpOptions = options
	textBoxFollowUpFuncs = funcs
	textBoxFollowUpCanCancel = canCancel
end

function hideTextBox()
	textBoxShown = false
	if callScriptAfterHideTextBox then
		nextScript()
	end
end

function getTextBoxMaxRows()
	if curScreen == 3 then
		return 3
	else
		return 5
	end
end

function addLetter()
	if not textBoxScrollDone then
		textBoxDisplayedText[curTextBoxRow] = textBoxDisplayedText[curTextBoxRow] .. string.sub(textBoxTextRows[curTextBoxRow], textBoxLetterIndex, textBoxLetterIndex)
		textBoxLetterIndex += 1
		if textBoxLetterIndex > string.len(textBoxTextRows[curTextBoxRow]) then
			curTextBoxRow += 1
			textBoxLetterIndex = 1
			if curTextBoxRow > #textBoxTextRows or curTextBoxRow > getTextBoxMaxRows() then
				textBoxScrollDone = true
			end
		end
	end
end
	
function updateTextBox()
	if textBoxScrollDone then
		if textBoxTimer > 0 then
			textBoxTimer -= 1
			if textBoxTimer == 0 then
				hideTextBox()
			end
		elseif followTextBoxWithPopup then
			setupPopupMenu(queryDropdownX, queryDropdownY, textBoxFollowUpOptions, textBoxFollowUpFuncs, textBoxFollowUpCanCancel)
		else
			if playdate.buttonJustPressed(playdate.kButtonA) then
				menuClicky()
				hideTextBox()
			end
		end
	else
		if playdate.buttonJustPressed(playdate.kButtonB) and textBoxTimer == 0 then
			textBoxDisplayedText = textBoxTextRows
			textBoxScrollDone = true
		else
			local numLettersToAdd
			if playdate.buttonIsPressed(playdate.kButtonA) then
				numLettersToAdd = 2
			else
				numLettersToAdd = 1
			end
			for i=1, numLettersToAdd do
				addLetter()
			end
		end
	end
end
local TEXT_BOX_HEIGHT_BETWEEN <const> = 20

function drawTextBox()
	drawNiceRect(GLOBAL_BEZEL, textBoxPosY, textBoxWidth, textBoxHeight)
	for i=1, #textBoxDisplayedText do
		gfx.drawText(textBoxDisplayedText[i], GLOBAL_BEZEL + textBoxTextBufferSize, textBoxPosY + textBoxTextBufferSize + (i-1) * TEXT_BOX_HEIGHT_BETWEEN)
	end
	--gfx.drawTextInRect(textBoxDisplayedText, GLOBAL_BEZEL + textBoxTextBufferSize, textBoxPosY + textBoxTextBufferSize, TEXT_BOX_ROW_WIDTH, textBoxHeight - (textBoxTextBufferSize*2))
	
	if textBoxScrollDone and textBoxTimer == 0 and not followTextBoxWithPopup then
		downFacingTriangle(400 - (GLOBAL_BEZEL * 3), textBoxPosY + (GLOBAL_BEZEL * 5) + (math.sin(bobTime * 3)), 10)
	end
end

function drawCombatTextBox()
	drawCombatBottomBg()

	--combatTextBoxHeight - (textBoxTextBufferSize*2)
	for i=1, #textBoxDisplayedText do
		gfx.drawText(textBoxDisplayedText[i], GLOBAL_BEZEL + textBoxTextBufferSize, combatTextBoxPosY + textBoxTextBufferSize + (i-1) * TEXT_BOX_HEIGHT_BETWEEN)
	end
	--gfx.drawTextInRect(textBoxDisplayedText, GLOBAL_BEZEL + textBoxTextBufferSize, combatTextBoxPosY + textBoxTextBufferSize, TEXT_BOX_ROW_WIDTH, 45)
	
	if textBoxScrollDone and textBoxTimer == 0 then
		downFacingTriangle(400 - (GLOBAL_BEZEL * 2), textBoxPosY + (GLOBAL_BEZEL * 6) + (math.sin(bobTime * 3)), 10)
	end
end