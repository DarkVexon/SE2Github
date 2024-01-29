local INTRO_SCROLL_START_X <const> = 25
local INTRO_SCROLL_WIDTH <const> = 400 - (INTRO_SCROLL_START_X * 2)
local INTRO_SCROLL_START_Y <const> = 40

local INTRO_SCROLL_TEXT <const> = {
	"From: KENEDAR BIOLOGY GROUP",
	"",
	"",
	"To: Prof. ",
	"",
	"",
	"Times are changing in Kenedar.",
	"",
	"",
	"Blah blah blah."
}

local INTRO_MAX_SCROLL <const> = 750
local INTRO_SCROLL_TO_SEE_FULL <const> = INTRO_MAX_SCROLL - 120
local INTRO_A_BTN_IMG <const> = gfx.image.new("img/intro/pressa")

local PLAYERNAME_X <const> = 115
local DOCKTEXT_X

introCrankScrollAmt = 0

function openIntroScroll()
	gfx.setBackgroundColor(gfx.kColorBlack)
	introCrankScrollAmt = 0
	curScreen = 13
end

function updateIntroScroll()
	if not keyboardShown then
		local input = playdate.getCrankChange() / 2
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			input -= 3
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			input += 3
		end

		if input ~= 0 then
			introCrankScrollAmt += input
			if introCrankScrollAmt < 0 then
				introCrankScrollAmt = 0
			end
			if introCrankScrollAmt > INTRO_SCROLL_TO_SEE_FULL then
				introCrankScrollAmt = INTRO_SCROLL_TO_SEE_FULL
			end
		end

		if playdate.buttonJustPressed(playdate.kButtonA) and introCrankScrollAmt >= INTRO_SCROLL_TO_SEE_FULL - 75 then
			initializePlayer()
			loadMapFromTransloc("testtownroom1", 1)
			startFade(openMainScreen)
			addRetScript(TextScript("Hard at work. Today you're studying... bacteria."))
			addRetScript(TextScript("Knock! Knock! Knock!"))
			addRetScript(TextScript("Someone's at the door."))
			addRetScript(LambdaScript("turn player", function () setPlayerFacing(2) nextScript() end))
		elseif introCrankScrollAmt < 75 then
			if playdate.buttonJustPressed(playdate.kButtonA) then
				playdate.keyboard.show()
				keyboardShown = true
			end
		end
	end
end

function drawIntroScroll()
	drawNiceRect(INTRO_SCROLL_START_X, INTRO_SCROLL_START_Y - introCrankScrollAmt, INTRO_SCROLL_WIDTH, INTRO_MAX_SCROLL)
	for i, v in ipairs(INTRO_SCROLL_TEXT) do
		gfx.drawText(v, INTRO_SCROLL_START_X + 5, INTRO_SCROLL_START_Y - introCrankScrollAmt + 5 + ((i-1) * 20))
	end
	if introCrankScrollAmt < 75 then
		if keyboardShown then
			gfx.drawText(playdate.keyboard.text, PLAYERNAME_X, 102 - introCrankScrollAmt)
			gfx.setColor(gfx.kColorXOR)
			gfx.fillRoundRect(PLAYERNAME_X - 5, 100 - introCrankScrollAmt, gfx.getTextSize(playdate.keyboard.text) + 25, 22, 2)
			gfx.setColor(gfx.kColorBlack)
		else
			gfx.drawText(playerName, PLAYERNAME_X, 102 - introCrankScrollAmt)
			gfx.setColor(gfx.kColorXOR)
			gfx.fillRoundRect(PLAYERNAME_X - 5, 100 - introCrankScrollAmt, gfx.getTextSize(playerName) + 10, 22, 2)
			gfx.setColor(gfx.kColorBlack)
			INTRO_A_BTN_IMG:draw(PLAYERNAME_X + gfx.getTextSize(playerName) + 15, 90 - introCrankScrollAmt)
		end
	else
		gfx.drawText(playerName, PLAYERNAME_X, 102 - introCrankScrollAmt)
		if introCrankScrollAmt >= INTRO_SCROLL_TO_SEE_FULL - 75 then
			INTRO_A_BTN_IMG:draw(350, INTRO_MAX_SCROLL - introCrankScrollAmt + 25)
		end
	end
end

function receiveTextChanged()
	if string.len(playdate.keyboard.text) > 8 then
		playdate.keyboard.text = string.sub(playdate.keyboard.text, 1, 8)
	end
end

playdate.keyboard.textChangedCallback = receiveTextChanged