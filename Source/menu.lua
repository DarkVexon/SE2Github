menuItems = {"Save", "Creatures", "Creaturedex", "Bag", "Options"}
local menuStartIndex <const> = 2
menuIcons = {}
menuIcons["Save"] = gfx.image.new("img/ui/menu/saveMenuIcon")
menuIcons["Creatures"] = gfx.image.new("img/ui/menu/creaturesMenuIcon")
menuIcons["Creaturedex"] = gfx.image.new("img/ui/menu/creaturedexMenuIcon")
menuIcons["Bag"] = gfx.image.new("img/ui/menu/bagMenuIcon")
menuIcons["Options"] = gfx.image.new("img/ui/menu/optionsMenuIcon")

local baseMenuItemOffset <const> = 180
local menuDistBetween <const> = (180/3)
local menuAngleLimit <const> = menuDistBetween / 2
local menuCircRadius <const> = 115
local menuCircPosition <const> = 450
local numMenuPaddingFrames <const> = 5
menuPaddingFrames = 0
menuIdx = menuStartIndex
lastIdx = menuIdx
menuAngle = 0

function openMenu()
	menuTimer = 10
	showingMenu = true
	resetMenu()
end

function closeMenu()
	menuTimer = 10
	showingMenu = false
end

function resetMenu()
	menuAngle = 0
	menuAngleToNext = 0
	menuAngleToPrev = 0
	menuPaddingFrames = 0
end

local CRANKING_NEEDED_FOR_SAVE <const> = 1111

function updateInMenu()
	local input = playdate.getCrankChange() / 2
	if not isInSaveGameMode then
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			input -= 3
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			input += 3
		end
		if (input ~= 0) then
			menuPaddingFrames = numMenuPaddingFrames
			menuAngle += input

			if menuAngle > menuAngleLimit then
				if menuIdx < #menuItems then
					--print("-> moved next")
					menuAngle -= menuAngleLimit * 2
					menuIdx += 1
					menuClicky()
				else --limit scroll
					menuAngle = menuAngleLimit
				end
			elseif menuAngle < -menuAngleLimit then
				if menuIdx > 1 then
					--print("-> moved prev")
					menuAngle += menuAngleLimit * 2
					menuIdx -= 1
					menuClicky()
				else --limit scroll
					menuAngle = -menuAngleLimit
				end
			end
		else
			if menuPaddingFrames > 0 then
				menuPaddingFrames -= 1
			else
				if menuAngle > 0 then --are there only integer values? Dunno if this logic is fine for this. Adjust as necessary to have menuAngle slowly move back to 0.
					menuAngle -= 1
					if menuAngle < 0 then
						menuAngle = 0
					end
				elseif menuAngle < 0 then
					menuAngle += 1
					if menuAngle > 0 then
						menuAngle = 0
					end
				end
			end
		end
	else
		if input > 0 then
			saveGameCrankProgress += input
		end
		if saveGameCrankProgress < CRANKING_NEEDED_FOR_SAVE/2 then
			saveGameCrankProgress -= 1
		end
		if saveGameCrankProgress > CRANKING_NEEDED_FOR_SAVE then
			saveGameCrankProgress = CRANKING_NEEDED_FOR_SAVE
		end
		if playdate.buttonIsPressed(playdate.kButtonB) then
			isInSaveGameMode = false
			saveGameCrankProgress = 0
		end
	end

	if playdate.isCrankDocked() and isCrankUp then
		isCrankUp = false
		closeMenu()
		if isInSaveGameMode then
			if saveGameCrankProgress >= CRANKING_NEEDED_FOR_SAVE then
				saveGame()
				showTextBox("Your game has been saved.")
			end
			isInSaveGameMode = false
			saveGameCrankProgress = 0
		end
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local target = menuItems[menuIdx]
		if target == "Creatures" then
			startFade(openMonsterScreen)
		elseif target == "Bag" then
			startFade(openBag)
		elseif target == "Options" then
			startFade(openOptionsMenu)
		elseif target == "Creaturedex" then
			startFade(openDexMenu)
		elseif target == "Save" then
			showQueryTextBox("Would you like to save the game?", {"Yes", "No"}, {prepSaveGame}, true)
		end
	end
end

function prepSaveGame()
	showTextBox("Crank to save, dock when complete!")
	isInSaveGameMode = true
	saveGameCrankProgress = 0
end

function updateMenuTimer()
	menuTimer -= 1
	if (menuTimer == 0) then
		isMenuUp = showingMenu
	end
end


local renderOrder <const> = {-2, 2, -1, 1, 0}

local MENU_INFO_BOX_HEIGHT <const> = 100

function drawMenu()
    local circRadius
    if menuTimer > 0 then
        if showingMenu then
            circRadius = menuCircRadius * playdate.math.lerp(0, 1, (10-menuTimer)/10)
        else
            circRadius = menuCircRadius * playdate.math.lerp(0, 1, menuTimer/10)
        end
    else
        circRadius = menuCircRadius
    end

	gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(menuCircPosition, 120, circRadius)
    gfx.setColor(gfx.kColorBlack)

    local lastIconX = 0
    local lastIconY = 0
    for idx, v in ipairs(renderOrder) do
    	i = menuIdx + v
        if i > 0 and i <= #menuItems then
            local destinationOffset = i - menuIdx --if rendering "current" one it's 0
            local destDegrees = destinationOffset * (-menuDistBetween) + menuAngle + baseMenuItemOffset --might need adjustment idk
            local destRads = toRadians(destDegrees)
            --local basicallyOffset = (180 - (math.abs(baseMenuItemOffset - destDegrees)))/180
            --local basicallyOffset = (math.abs(i-menuIdx)) * 0.5

            local menuIconScale = 1
            local menuIconDestX = (circRadius) * math.cos(destRads) + menuCircPosition
            local menuIconDestY = (circRadius) * math.sin(destRads) + 120

            if menuIdx == i then
                local squareSize = 75 * menuIconScale
                if lastIdx == menuIdx then
                    drawNiceRect(menuIconDestX - (squareSize / 2), menuIconDestY - (squareSize / 2), squareSize, squareSize)
                else --have square 1 frame of moving between (lazy method)
                    lastIdx = menuIdx
					drawNiceRect((lastIconX + menuIconDestX) / 2 - (squareSize / 2), (lastIconY + menuIconDestY) / 2 - (squareSize / 2), squareSize, squareSize)
                end
            end

            if lastIdx == i then
				lastIconX = menuIconDestX
				lastIconY = menuIconDestY
			end

            menuIcons[menuItems[i]]:drawScaled(menuIconDestX - (33 * menuIconScale), menuIconDestY - (33 * menuIconScale), menuIconScale)
        end
    end

	if not (popupUp or followTextBoxWithPopup) and not isInSaveGameMode then
	    if (menuTimer == 0) or (menuTimer > 0 and showingMenu) then
	    	if #playerMonsters > 0 then
	    		drawMonsterInfoBox(playerMonsters[1], 10, 10, false)
	    	end

		    drawNiceRect(10, (240 - MENU_INFO_BOX_HEIGHT) - 10, 275, MENU_INFO_BOX_HEIGHT)
		    gfx.drawText(playerName, 20, (240 - MENU_INFO_BOX_HEIGHT) - 10 + 10)
		    gfx.drawText("$" .. playerMoney, 225, (240 - MENU_INFO_BOX_HEIGHT) - 10 + 10)
		    gfx.drawText("Seen: " .. getDexProgress(1) .. "/" .. numMonsters, 20, (240 - MENU_INFO_BOX_HEIGHT) - 10 + 30)
		    gfx.drawText("Caught: " .. getDexProgress(2).. "/" .. numMonsters, 140, (240 - MENU_INFO_BOX_HEIGHT) - 10 + 30)
		end
	end

	if isInSaveGameMode then
		drawBar(10, 200, 380, 20, saveGameCrankProgress, CRANKING_NEEDED_FOR_SAVE)
	end
end