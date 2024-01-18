dexItems = {}
for i, k in ipairs(getTableKeys(monsterInfo)) do
	table.insert(dexItems, k)
end

local MAINDEX_BASICINFO_X <const> = 20
local MAINDEX_BASICINFO_Y <const> = 100
local MAINDEX_BASICINFO_WIDTH <const> = 180
local MAINDEX_BASICINFO_HEIGHT <const> = 20
local MAINDEX_TYPEINFO_OFFSETY <const> = 25

local baseDexItemOffset <const> = 180
local dexDistBetween <const> = (180/4)
local dexAngleLimit <const> = dexDistBetween / 2
local dexCircRadius <const> = 115
local numDexPaddingFrames <const> = 5
local circlePosition <const> = 450
dexIdx = 1
dexAngle = 0
dexPaddingFrames = 0
dexNameShowFrames = 0

function resetDex()
	dexAngle = 0
	dexAngleToNext = 0
	dexAngleToPrev = 0
	dexPaddingFrames = 0
end

function openDexMenu()
	curScreen = 7
	dexIdx = 1
	lastDexIdx = dexIdx
	resetDex()
	dexTimer = 10
	showingDex = true
end

function updateDexMenu()
	if dexTimer > 0 then
		dexTimer -= 1
	else
		--input
		local input = playdate.getCrankChange() / 2
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			input -= 3
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			input += 3
		end

		--handling input
		if (input ~= 0) then
			dexPaddingFrames = numDexPaddingFrames
			dexAngle += input

			if dexAngle > dexAngleLimit then
				if dexIdx < #dexItems then
					--print("-> moved next")
					dexAngle -= dexAngleLimit *2
					dexIdx += 1
					menuClicky()
					--dexNameShowFrames = 10
				else --limit scroll
					dexAngle = dexAngleLimit
				end
			elseif dexAngle < -dexAngleLimit then
				if dexIdx > 1 then
					--print("-> moved prev")
					dexAngle += dexAngleLimit *2
					dexIdx -= 1
					menuClicky()
					--dexNameShowFrames = 10
				else --limit scroll
					dexAngle = -dexAngleLimit
				end
			end
		else --no input, slowly reset to center
			if dexPaddingFrames > 0 then
				dexPaddingFrames -= 1
			else
				if dexAngle > 0 then --are there only integer values? Dunno if this logic is fine for this. Adjust as necessary to have dexAngle slowly move back to 0.
					dexAngle -= 1
					if dexAngle < 0 then
						dexAngle = 0
					end
				elseif dexAngle < 0 then
					dexAngle += 1
					if dexAngle > 0 then
						dexAngle = 0
					end
				end
			end
		end

		if playdate.buttonJustPressed(playdate.kButtonA) then
			if playerDex[dexItems[dexIdx]] ~= 0 then
				menuClicky()
				dexSelectedIdx = dexIdx
				dexSelectedSpecies = dexItems[dexIdx]
				startFade(openDexSingleView)
			end
		elseif playdate.buttonJustPressed(playdate.kButtonB) then
			menuClicky()
			startFade(openMainScreen)
		end

		if dexNameShowFrames > 0 then
			dexNameShowFrames -= 1
		end
	end
end


lastDexIdx = 0 --impossible value, probably set it to "current one" when opened

local renderOrder <const> = {-2, 2, -1, 1, 0}
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

    gfx.drawCircleAtPoint(circlePosition, 120, circRadius)

    local lastIconX = 0
    local lastIconY = 0
    for idx, v in ipairs(renderOrder) do
    	i = dexIdx + v
        if i > 0 and i <= #dexItems then
            local destinationOffset = i - dexIdx --if rendering "current" one it's 0
            local destDegrees = destinationOffset * (-dexDistBetween) + dexAngle + baseDexItemOffset --might need adjustment idk
            local destRads = toRadians(destDegrees)
            local basicallyOffset = (180 - (math.abs(baseDexItemOffset - destDegrees)))/180
            --local basicallyOffset = (math.abs(i-dexIdx)) * 0.5

            --local dexIconScale = playdate.math.lerp(1.0, 0.5, basicallyOffset)
            local dexIconScale = playdate.math.lerp(0, 1, basicallyOffset)
            local dexIconDestX = (circRadius) * math.cos(destRads) + circlePosition
            local dexIconDestY = (circRadius) * math.sin(destRads) + 120

            if dexIdx == i then
                local squareSize = 120 * dexIconScale
                if lastDexIdx == dexIdx then
                    drawNiceRect(dexIconDestX - (squareSize / 2), dexIconDestY - (squareSize / 2), squareSize, squareSize)
                else --have square 1 frame of moving between (lazy method)
                    lastDexIdx = dexIdx
                    drawNiceRect((lastIconX + dexIconDestX) / 2 - (squareSize / 2), (lastIconY + dexIconDestY) / 2 - (squareSize / 2), squareSize, squareSize)
                end
            end

            if playerDex[dexItems[i]] ~= 0 then
                monsterImgs[dexItems[i]]:drawScaled(dexIconDestX - (50 * dexIconScale), dexIconDestY - (50 * dexIconScale), dexIconScale)
            else
                unknownMonsterImg:drawScaled(dexIconDestX - (50 * dexIconScale), dexIconDestY - (50 * dexIconScale), dexIconScale)
            end

            if dexIdx == i then
			     if dexNameShowFrames == 0 then
			     	if playerDex[dexItems[i]] == 0 then
						gfx.drawText("#" .. dexIdx .. " Unknown", MAINDEX_BASICINFO_X, MAINDEX_BASICINFO_Y)
			     	else
			     		gfx.drawText("#" .. dexIdx .. " " .. monsterInfo[dexItems[i]].speciesName, MAINDEX_BASICINFO_X, MAINDEX_BASICINFO_Y)
			     	end
					
					gfx.drawLine(MAINDEX_BASICINFO_X, MAINDEX_BASICINFO_Y + MAINDEX_BASICINFO_HEIGHT, MAINDEX_BASICINFO_X + MAINDEX_BASICINFO_WIDTH, MAINDEX_BASICINFO_Y + MAINDEX_BASICINFO_HEIGHT)
					gfx.drawLine(MAINDEX_BASICINFO_X + MAINDEX_BASICINFO_WIDTH - 2, MAINDEX_BASICINFO_Y + MAINDEX_BASICINFO_HEIGHT, dexIconDestX - 75, dexIconDestY)

					if playerDex[dexItems[i]] == 2 then
						renderTypesHoriz(getDefaultTypes(dexItems[i]), MAINDEX_BASICINFO_X, MAINDEX_BASICINFO_Y + MAINDEX_TYPEINFO_OFFSETY)
					end
			    else

			    end
            end

            if lastDexIdx == i then
	            lastIconX = dexIconDestX
	            lastIconY = dexIconDestY
	        end
        end
    end
    gfx.setColor(gfx.kColorBlack)

end