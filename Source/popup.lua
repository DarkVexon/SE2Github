local distBetweenPopupOptions <const> = 30
local popupBuffer <const> = 40

popupMenuSelectionIdx = 1

function setupPopupMenu(x, y, options, funcs, canCancel)
	popupUp = true
	popupX = x
	popupY = y
	popupWidth = widthOfWidest(options) + popupBuffer
	popupHeight = #options * (gameFont:getHeight() + 16)
	popupOptions = {}
	popupFuncs = {}
	canCancelPopup = canCancel
	for i, v in ipairs(options) do
		popupOptions[i] = v
	end
	for i, v in ipairs(funcs) do
		popupFuncs[i] = v
	end
	popupMenuSelectionIdx = 1
end

function drawPopupMenu()
	drawNiceRect(popupX, popupY, popupWidth, popupHeight)
	for i, v in ipairs(popupOptions) do
		if popupMenuSelectionIdx == i then
			gfx.fillTriangle(popupX + 3, popupY + ((i-1)*distBetweenPopupOptions) + 10, popupX + 18,popupY + 8+ ((i-1)*distBetweenPopupOptions) + 10, popupX + 3, popupY + 16+ ((i-1)*distBetweenPopupOptions) + 10)
		end
		gfx.drawText(v, popupX + 20, popupY + ((i-1)*distBetweenPopupOptions) + 10)
	end
	if canCancel then
		globalBack:draw(popupX + popupWidth - BACK_BTN_WIDTH - 2, popupY + popupHeight - BACK_BTN_HEIGHT - 2)
	end
end

function updatePopupMenu()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		popupMenuSelectionIdx -= 1
		if popupMenuSelectionIdx == 0 then
			popupMenuSelectionIdx = #popupOptions
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		popupMenuSelectionIdx += 1
		if popupMenuSelectionIdx > #popupOptions then
			popupMenuSelectionIdx = 1
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		popupFuncs[popupMenuSelectionIdx]()
		if followTextBoxWithPopup then
			followTextBoxWithPopup = false
			hideTextBox()
		end
		popupUp = false
	elseif playdate.buttonJustPressed(playdate.kButtonB) and canCancel then
		popupUp = false
	end
end