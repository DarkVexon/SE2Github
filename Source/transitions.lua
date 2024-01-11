fadeOutTimer = 0
fadeInTimer = 0
fadeDest = 0

local fadeCircEndpoint = math.sqrt(400^2 + 240^2)/2

function updateFade()
	if fadeOutTimer > 0 then
		fadeOutTimer -= 1
		if fadeOutTimer == 0 then
			onEndFadeOut()
			transitionImg = gfx.image.new(400, 240)
			gfx.pushContext(transitionImg)
			render()
			gfx.popContext()
			fadeInTimer = 15
		end
	elseif fadeInTimer > 0 then
		fadeInTimer -= 1
	end
end

function renderFade()
	if fadeOutTimer > 0 then
		gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(0, 1, ((15-fadeOutTimer)/14)) * fadeCircEndpoint)
	elseif fadeInTimer > 0 then
		gfx.clear()
		transitionImg:draw(0, 0)
		gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(1, 0, ((15-fadeInTimer)/14)) * fadeCircEndpoint)
	end
end


function onEndFadeOut()
	if scriptAfter then
		scriptAfter = false
		nextScript()
	end
	if fadeDest == 0 then
		openMainScreen()
	elseif fadeDest == 1 then
		loadMap(nextMap, nextTransloc)
	elseif fadeDest == 2 then
		openMonsterScreen()
	elseif fadeDest == 3 then
		openSingleMonsterView()
	elseif fadeDest == 4 then
		beginCombat()
	elseif fadeDest == 5 then
		openBag()
	end
end