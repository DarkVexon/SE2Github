
dexItems = {}
for i, k in ipairs(getTableKeys(monsterInfo)) do
	table.insert(dexItems, k)
end

local baseDexItemOffset <const> = 180
local dexDistBetween <const> = (180/5)
local dexCrankDistBetween <const> = dexDistBetween * 0.75
local offsetPerDexItem <const> = dexDistBetween * -1
local dexMaxAngle <const> = #dexItems * dexDistBetween - 35
local dexCircRadius <const> = 115
local numDexPaddingFrames <const> = 5

dexIdx = 1
dexAngle = 0

dexAngleToNext = 0
dexAngleToPrev = 0

dexPaddingFrames = 0

function resetDex()
	dexAngle = dexDistBetween * (dexIdx-1)
	dexAngleToNext = 0
	dexAngleToPrev = 0
	dexPaddingFrames = 0
end

function openDexMenu()
	curScreen = 7
	dexIdx = 1
	resetDex()
	dexTimer = 10
	showingDex = true
end

function updateDexMenu()
	if dexTimer > 0 then
		dexTimer -= 1
	else
		local change = playdate.getCrankChange() / 2
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			change -= 3
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			change += 3
		end
		if (change ~= 0) then
			dexPaddingFrames = numDexPaddingFrames
			dexAngle += change
			if dexAngle > dexDistBetween * (#dexItems-1) then
				dexAngle = dexDistBetween * (#dexItems-1)
			end
			if dexIdx < #dexItems and not (change < 0 and dexIdx == 1) then
				dexAngleToNext += change
			end
			if dexIdx > 1 and not (change > 0 and dexIdx == #dexItems) then
				dexAngleToPrev -= change
			end
			if (dexAngle < 0) then
				dexAngle = 0
			end
			if dexAngle > dexMaxAngle then
				dexAngle = dexMaxAngle
			end
			if (dexAngleToNext >= dexCrankDistBetween) then
				if (dexIdx < #dexItems) then
					--print("-> moved next")
					dexIdx += 1
					dexAngle = dexDistBetween * (dexIdx-1)
					dexAngleToNext = 0
					dexAngleToPrev = 0
				end
			elseif dexAngleToPrev >= dexCrankDistBetween then
				if dexIdx > 1 then
					--print("-> moved prev")
					dexIdx -= 1
					dexAngle = dexDistBetween * (dexIdx-1)
					dexAngleToPrev = 0
					dexAngleToNext = 0
				end
			end
		else
			if dexPaddingFrames > 0 then
				dexPaddingFrames -= 1
			else

				
			end
		end
		if playdate.buttonJustPressed(playdate.kButtonA) then
			--TODO: Single dex view
		elseif playdate.buttonJustPressed(playdate.kButtonB) then
			startFade(openMainScreen)
		end
	end
end

function drawDexMenu()
	local circRadius
	if dexTimer > 0 then
		if showingDex then
			circRadius = dexCircRadius * playdate.math.lerp(0, 1, (10-dexTimer)/10)
		else
			circRadius = dexCircRadius * playdate.math.lerp(0, 1, dexTimer/10)
		end
	else
		circRadius = dexCircRadius
	end
	gfx.drawCircleAtPoint(400, 120, circRadius)

	for i=dexIdx-2, dexIdx+2 do
		if i > 0 and i <= #dexItems then
			local destinationIndex = i-1
			local destDegrees = destinationIndex * offsetPerDexItem + baseDexItemOffset + dexAngle
			local destRads = toRadians(destDegrees)
			local dexIconDestX = circRadius * math.cos(destRads) + 400
			local dexIconDestY = circRadius * math.sin(destRads) + 120
			local dexIconScale
			if i < dexIdx then
				dexIconScale = playdate.math.lerp(0.5, 0.7, dexAngleToPrev / (dexCrankDistBetween))
			elseif i > dexIdx then

			else

			end
			if dexIdx == i then
				gfx.drawRect(dexIconDestX - 40, dexIconDestY - 40, 80, 80)
			end
			monsterImgs[dexItems[i]]:drawScaled(dexIconDestX - 33, dexIconDestY - 33, dexIconScale)
		end
	end
	gfx.setColor(gfx.kColorBlack)
end