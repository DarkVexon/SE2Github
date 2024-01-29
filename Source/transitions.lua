local transitionNames <const> = {"CircFade", "PureFade"}
local transitionTimesIn <const> = {12, 5}
local transitionTimesOut <const> = {12, 5}

transitionTimer = 0
fadeOutTimer = 0
fadeInTimer = 0
fadeDest = nil
curFadeType = 1

fadeCircEndpoint = math.sqrt(400^2 + 240^2)/2

function startFade(toCall)
	startSpecificFade(toCall, 2)
end

function startSpecificFade(toCall, transitionType)
	if transitionType == nil then
		curFadeType = 2
	else
		curFadeType = transitionType
	end
	transitionTimer = transitionTimesIn[curFadeType]
	fadeOutTimer = transitionTimer
	fadeDest = toCall
end

function updateFade()
	if fadeOutTimer > 0 then
		fadeOutTimer -= 1
		if fadeOutTimer == 0 then
			onEndFadeOut()
			transitionImg = gfx.image.new(400, 240)
			gfx.pushContext(transitionImg)
			render()
			gfx.popContext()
			transitionTimer = transitionTimesOut[curFadeType]
			fadeInTimer = transitionTimer
		end
	elseif fadeInTimer > 0 then
		fadeInTimer -= 1
	end
end

function renderFade()
	if curFadeType == 1 then
		if fadeOutTimer > 0 then
			gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(0, 1, timeLeft(fadeOutTimer, transitionTimer)) * fadeCircEndpoint)
		elseif fadeInTimer > 0 then
			gfx.clear()
			transitionImg:draw(0, 0)
			gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(1, 0, timeLeft(fadeInTimer, transitionTimer)) * fadeCircEndpoint)
		end
	elseif curFadeType == 2 then
		if fadeOutTimer >= transitionTimer - 2 or (fadeInTimer > 0 and fadeInTimer <= 2) then
			gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		else
			gfx.setColor(gfx.kColorBlack)
		end
		if fadeOutTimer > 0 then
			gfx.fillRect(0, 0, 400, 240)
		elseif fadeInTimer > 0 then
			gfx.clear()
			transitionImg:draw(0, 0)
			gfx.fillRect(0, 0, 400, 240)
		end
	end
end

function onEndFadeOut()
	fadeDest()
	if curScreen == 0 then
		if mapBg == "white" then
			gfx.setBackgroundColor(gfx.kColorWhite)
		elseif mapBg == "black" then
			gfx.setBackgroundColor(gfx.kColorBlack)
		end
	elseif curScreen == 13 then

	else
		gfx.setBackgroundColor(gfx.kColorWhite)
	end
	if scriptAfter then
		scriptAfter = false
		nextScript()
	end
end