menuItems = {"Save", "Creatures", "Creaturedex", "Bag", "ID"}
local menuStartIndex <const> = 2
menuIcons = {}
menuIcons["Save"] = gfx.image.new("img/saveMenuIcon")
menuIcons["Creatures"] = gfx.image.new("img/creaturesMenuIcon")
menuIcons["Creaturedex"] = gfx.image.new("img/creaturedexMenuIcon")
menuIcons["Bag"] = gfx.image.new("img/bagMenuIcon")
menuIcons["ID"] = gfx.image.new("img/idCardMenuIcon")

menuIdx = menuStartIndex
menuAngle = 0
local baseMenuItemOffset <const> = 180
local menuDistBetween <const> = (180/3)
local menuCrankDistBetween <const> = menuDistBetween * 0.85
local offsetPerMenuItem <const> = menuDistBetween * -1
menuAngleToNext = 0
menuAngleToPrev = 0
local menuMaxAngle <const> = #menuItems * menuDistBetween - 35
local menuCircRadius <const> = 115
local numMenuPaddingFrames <const> = 5
menuPaddingFrames = 0

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
	menuAngle = menuDistBetween * (menuIdx-1)
	menuAngleToNext = 0
	menuAngleToPrev = 0
	menuPaddingFrames = 0
end

function updateInMenu()
	local change = playdate.getCrankChange() / 2
	if (change ~= 0) then
		menuPaddingFrames = numMenuPaddingFrames
		menuAngle += change
		if menuAngle > menuDistBetween * (#menuItems-1) then
			menuAngle = menuDistBetween * (#menuItems-1)
		end
		if menuIdx < #menuItems and not (change < 0 and menuIdx == 1) then
			menuAngleToNext += change
		end
		if menuIdx > 1 and not (change > 0 and menuIdx == #menuItems) then
			menuAngleToPrev -= change
		end
		if (menuAngle < 0) then
			menuAngle = 0
		end
		if menuAngle > menuMaxAngle then
			menuAngle = menuMaxAngle
		end
		if (menuAngleToNext >= menuCrankDistBetween) then
			if (menuIdx < #menuItems) then
				--print("-> moved next")
				menuIdx += 1
				menuAngle = menuDistBetween * (menuIdx-1)
				menuAngleToNext = 0
				menuAngleToPrev = 0
			end
		elseif menuAngleToPrev >= menuCrankDistBetween then
			if menuIdx > 1 then
				--print("-> moved prev")
				menuIdx -= 1
				menuAngle = menuDistBetween * (menuIdx-1)
				menuAngleToPrev = 0
				menuAngleToNext = 0
			end
		end
	else
		if menuPaddingFrames > 0 then
			menuPaddingFrames -= 1
		else

			
		end
	end
	if playdate.isCrankDocked() and isCrankUp then
		isCrankUp = false
		closeMenu()
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		local target = menuItems[menuIdx]
		if target == "Creatures" then
			fadeOutTimer = 15
			fadeDest = 2
		elseif target == "Bag" then
			fadeOutTimer = 15
			fadeDest = 5
		end
	end
end

function updateMenuTimer()
	menuTimer -= 1
	if (menuTimer == 0) then
		isMenuUp = showingMenu
	end
end

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
	gfx.fillCircleAtPoint(400, 120, circRadius)
	gfx.setColor(gfx.kColorBlack)

	for i=menuIdx-3, menuIdx+3 do
		if i > 0 and i <= #menuItems then
			local destinationIndex = i-1
			local destDegrees = destinationIndex * offsetPerMenuItem + baseMenuItemOffset + menuAngle
			local destRads = toRadians(destDegrees)
			local menuIconDestX = circRadius * math.cos(destRads) + 400
			local menuIconDestY = circRadius * math.sin(destRads) + 120
			if menuIdx == i then
				gfx.drawRect(menuIconDestX - 40, menuIconDestY - 40, 80, 80)
			end
			menuIcons[menuItems[i]]:draw(menuIconDestX - 33, menuIconDestY - 33)
		end
	end
	gfx.setColor(gfx.kColorBlack)
end