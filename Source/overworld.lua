local cameraHorizBuffer <const> = 6
local cameraVertBuffer <const> = 3

local gridSize <const> = 40
local gridWidth <const> = 400/40
local gridHeight <const> = 240/40

local cameraMoveTime <const> = 10
local cameraMoveTime_Run <const> = 6

guyImgN = { gfx.image.new("img/overworld/player/guy-n1"), gfx.image.new("img/overworld/player/guy-n2"), gfx.image.new("img/overworld/player/guy-n3")}
guyImgE = { gfx.image.new("img/overworld/player/guy-e1"), gfx.image.new("img/overworld/player/guy-e2")}
guyImgS = { gfx.image.new("img/overworld/player/guy-s1"), gfx.image.new("img/overworld/player/guy-s2"), gfx.image.new("img/overworld/player/guy-s3")}
guyImgW = { gfx.image.new("img/overworld/player/guy-w1"), gfx.image.new("img/overworld/player/guy-w2") }
playerImg = guyImgN
playerImgIndex = 1

camWidth = 400/40
camHeight = 240/40
movingCam = false

isMenuUp = false
menuTimer = 0
showingMenu = false

playerRenderPosX = 200
playerRenderPosY = 80
playerPrevRenderPosX = playerRenderPosX
playerPrevRenderPosY = playerRenderPosY
playerDestRenderPosX = playerRenderPosX
playerDestRenderPosY = playerRenderPosY
playerFooting = 1

objs = {}

returnScripts = {}

curAreaName = "Colus Town"

function swapPlayerFooting()
	if playerFooting == 1 then
		playerFooting = 2
	else
		playerFooting = 1
	end
end

function openMainScreen()
	curScreen = 0
	for i, v in ipairs(returnScripts) do
		addScript(v)
	end
	clear(returnScripts)
	nextScript()
end

function hardSetupAreaName()
	if dividers ~= nil then
		for k,v in ipairs(dividers) do
			if playerX >= v[2] and playerX <= v[2] + v[4] and playerY >= v[3] and playerY <= v[3] + v[5] then
				curAreaName = v[1]
				break
			end
		end
	end
end

local AREA_SHOW_TIME = 15
local AREA_HOLD_TIME = 25
areaIsShowing = false
areaShowTimer = 0

function checkAreaName()
	if dividers ~= nil then
		for k,v in ipairs(dividers) do
			if playerX >= v[2] and playerX <= v[2] + v[4] and playerY >= v[3] and playerY <= v[3] + v[5] then
				if curAreaName ~= v[1] then
					curAreaName = v[1]
					areaShowTimer = AREA_SHOW_TIME + AREA_HOLD_TIME
					areaIsShowing = true
				end
			end
		end
	end
end

function hardSetupCameraOffsets()
	if CAMERA_TRACKS then
		cameraOffsetGridX = math.max(0, math.min(mapWidth - camWidth, playerX - cameraHorizBuffer))
		cameraOffsetGridY = math.max(0, math.min(mapHeight - camHeight, playerY - cameraVertBuffer))
	else
		cameraOffsetGridX = playerX - cameraHorizBuffer
		cameraOffsetGridY = playerY - cameraVertBuffer
	end
	cameraOffsetX = cameraOffsetGridX * -40
	cameraOffsetY = cameraOffsetGridY * -40
	cameraPrevOffsetX = cameraOffsetX
	cameraPrevOffsetY = cameraOffsetY
	cameraDestOffsetX = cameraOffsetX
	cameraDestOffsetY = cameraOffsetY
	if (playerX < cameraHorizBuffer) and CAMERA_TRACKS then
		playerDestRenderPosX = (playerX-1) * 40
	elseif playerX > (mapWidth - (camWidth - cameraHorizBuffer)) and CAMERA_TRACKS then
		playerDestRenderPosX = (playerX - mapWidth + (camWidth) - 1) * 40
	else
		playerDestRenderPosX = (cameraHorizBuffer - 1) * 40
	end
	playerRenderPosX = playerDestRenderPosX

	if (playerY < cameraVertBuffer) and CAMERA_TRACKS then
		playerDestRenderPosY = (playerY - 1) * 40
	elseif (playerY > (mapHeight - (camHeight - cameraVertBuffer))) and CAMERA_TRACKS then
		playerDestRenderPosY = (playerY - mapHeight + (camHeight) - 1) * 40
	else
		playerDestRenderPosY = (cameraVertBuffer - 1) * 40
	end
	playerRenderPosY = playerDestRenderPosY
	playerPrevRenderPosX = playerRenderPosX
	playerPrevRenderPosY = playerRenderPosY
	cameraTimer = 0
end

function setupCameraOffset()
	cameraPrevOffsetX = cameraOffsetX
	cameraPrevOffsetY = cameraOffsetY
	playerPrevRenderPosX = playerRenderPosX
	playerPrevRenderPosY = playerRenderPosY
	if ((playerX < cameraHorizBuffer or (playerX == cameraHorizBuffer and playerFacing == 1))) and CAMERA_TRACKS then
		playerDestRenderPosX = (playerX-1) * 40
	elseif (playerX > (mapWidth - (camWidth - cameraHorizBuffer)) or (playerX == (mapWidth - (camWidth - cameraHorizBuffer)) and playerFacing == 3)) and CAMERA_TRACKS then
		playerDestRenderPosX = (playerX - mapWidth + (camWidth) - 1) * 40
	else
		cameraOffsetGridX = (playerX - cameraHorizBuffer)
		cameraDestOffsetX = cameraOffsetGridX * -40
	end


	if (playerY < cameraVertBuffer or (playerY == cameraVertBuffer and playerFacing == 2)) and CAMERA_TRACKS then
		playerDestRenderPosY = (playerY - 1) * 40
	elseif (playerY > (mapHeight - (camHeight - cameraVertBuffer)) or (playerY == (mapHeight - (camHeight - cameraVertBuffer)) and playerFacing == 0)) and CAMERA_TRACKS then
		playerDestRenderPosY = (playerY - mapHeight + (camHeight) - 1) * 40
	else
		cameraOffsetGridY = (playerY - cameraVertBuffer)
		cameraDestOffsetY = cameraOffsetGridY * -40
	end

	movingCam = true
end

function setPlayerFacing(facing)
	playerFacing = facing
	if facing == 0 then
		playerImg = guyImgN
	elseif facing == 1 then
		playerImg = guyImgE
	elseif facing == 2 then
		playerImg = guyImgS
	elseif facing == 3 then
		playerImg = guyImgW
	end
end

function updateOverworld()
	if (textBoxShown) then
		updateTextBox()
	else
		for i, v in ipairs(objs) do
			v:update()
		end

		if (movingCam) then
			updateCameraOffset()
		elseif (menuTimer > 0) then
			updateMenuTimer()
		elseif (isMenuUp) then
			updateInMenu()
		else
			checkMovement()
		end
	end

	if areaShowTimer > 0 then
		areaShowTimer -= 1
		if areaShowTimer == 0 and areaIsShowing then
			areaIsShowing = false
			areaShowTimer = AREA_SHOW_TIME
		end
	end
end

local AREA_BLURB_POS_X <const> = 10
local AREA_BLURB_WIDTH <const> = 150
local AREA_BLURB_HEIGHT <const> = 30
local AREA_BLURB_START_Y <const> = -AREA_BLURB_HEIGHT
local AREA_BLURB_END_Y <const> = 10

function drawAreaPopup()
	local areaPopupY
	if areaIsShowing then
		if areaShowTimer <= AREA_HOLD_TIME then
			areaPopupY = AREA_BLURB_END_Y
		else
			areaPopupY = playdate.math.lerp(AREA_BLURB_START_Y, AREA_BLURB_END_Y, timeLeft(areaShowTimer - AREA_HOLD_TIME, AREA_SHOW_TIME))
		end
	else
		areaPopupY = playdate.math.lerp(AREA_BLURB_END_Y, AREA_BLURB_START_Y, timeLeft(areaShowTimer, AREA_SHOW_TIME))
	end
	drawNiceRect(AREA_BLURB_POS_X, areaPopupY, AREA_BLURB_WIDTH, AREA_BLURB_HEIGHT)
	gfx.drawText(curAreaName, AREA_BLURB_POS_X + 3, areaPopupY + 3)
end

function drawInOverworld()
	currentTileset:draw(cameraOffsetX, cameraOffsetY)

	for i, v in ipairs(objs) do
		v:render()
	end

	--gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
	gfx.fillEllipseInRect(playerRenderPosX, playerRenderPosY + 40 - 13, 40, 10)
	--gfx.setColor(gfx.kColorBlack)
	playerImg[playerImgIndex]:draw(playerRenderPosX, playerRenderPosY - 8)

	if menuTimer > 0 or isMenuUp then
		drawMenu()
	end

	if textBoxShown then
		drawTextBox()
	end

	if areaShowTimer > 0 and curAreaName ~= nil then
		drawAreaPopup()
	end
end

function canMoveThere(x, y) 
	if x < 1 or y < 1 or x > mapWidth or y > mapHeight then
		return false
	end
	local result = currentTileset:getTileAtPosition(x, y)
	if (not contains(passables, result)) then
		return false
	end
	for i, v in ipairs(objs) do
		if (v:occupies(x, y) and not v:canMoveHere()) then
			return false
		end
	end
	return true
end

function checkMovement()
	if #scriptStack == 0 then
		if (playdate.buttonJustPressed(playdate.kButtonA)) then
			local tarX, tarY = getPlayerPointCoord()
			for i, v in ipairs(objs) do
				if (v.posX == tarX and v.posY == tarY) then
					menuClicky()
					v:onInteract()
				end
			end
		elseif (playdate.buttonIsPressed(playdate.kButtonUp)) then
			attemptMoveUp()
		elseif (playdate.buttonIsPressed(playdate.kButtonDown)) then
			attemptMoveDown()
		elseif (playdate.buttonIsPressed(playdate.kButtonLeft)) then
			attemptMoveLeft()
		elseif (playdate.buttonIsPressed(playdate.kButtonRight)) then
			attemptMoveRight()
		end

		if not playdate.isCrankDocked() and not isCrankUp then
			isCrankUp = true
			openMenu()
		end
	end
end

function attemptMoveUp()
	setPlayerFacing(0)
	if (canMoveThere(playerX, playerY-1)) then
		playerMoveBy(0, -1)
		return
	end
end

function attemptMoveDown()
	setPlayerFacing(2)
	if (canMoveThere(playerX, playerY+1)) then
		playerMoveBy(0, 1)
		return
	end
end

function attemptMoveLeft()
	setPlayerFacing(3)
	if (canMoveThere(playerX - 1, playerY)) then
		playerMoveBy(-1, 0)
		return
	end
end

function attemptMoveRight()
	setPlayerFacing(1)
	if (canMoveThere(playerX + 1, playerY)) then
		playerMoveBy(1, 0)
		return
	end
end

function playerMoveBy(x, y)
	if (x ~= 0 or y ~= 0) then
		playerPrevX = playerX
		playerPrevY = playerY
		swapPlayerFooting()
		playerX += x
		playerY += y
		if playerFacing == 0 or playerFacing == 2 then
			playerImgIndex = 1 + playerFooting
		else
			playerImgIndex = 2
		end
		setupCameraOffset()
		if playdate.buttonIsPressed(playdate.kButtonB) then
			cameraTimer = cameraMoveTime_Run
			cameraMaxTimer = cameraTimer
		else
			cameraTimer = cameraMoveTime
			cameraMaxTimer = cameraTimer
		end		
	end
end

function getPlayerPointCoord()
	if (playerFacing == 0) then
		return playerX, playerY-1
	elseif (playerFacing == 1) then
		return playerX+1, playerY
	elseif (playerFacing == 2) then
		return playerX, playerY+1
	elseif (playerFacing == 3) then
		return playerX-1, playerY
	end
	return playerX, playerY-1
end

function randomEncounterChance()
	if math.random(0, encounterChance) == 0 then
		return true
	end
	return false
end

function mapRandomEncounter()
	local maxSum = 0
	for k, v in pairs(randomEncounters) do
		maxSum += v[3]
	end

	local result = math.random(maxSum)

	for k, v in pairs(randomEncounters) do
		result -= v[3]
		if result <= 0 then
			--addScript(RandomEncounterScript(v[1], v[2]))
			addScript(RandomEncounterScript(randomSpecies(), {playerMonsters[1].level-2, playerMonsters[1].level}))
			--addScript(RandomEncounterScript("Yunyun", {3, 5}))
			--addScript(RandomEncounterScript("Chompah", {playerMonsters[1].level-2, playerMonsters[1].level}))
			nextScript()
			break
		end
	end
end

function onMoveEnd()
	playerImgIndex  = 1
	local landedTile = currentTileset:getTileAtPosition(playerX, playerY)
	movingCam = false
	allowImmediateMovementCheck = true
	for k, v in ipairs(objs) do
		v:onPlayerEndMove()
		if v:occupies(playerX, playerY) then
			v:onOverlap()
			if not v:allowImmediateMovementAfterStep() then
				allowImmediateMovementCheck = false
			end
		end
	end
	if contains(encounterTiles, landedTile) then
		if randomEncounterChance() then
			allowImmediateMovementCheck = false
			mapRandomEncounter()
		end
	end
	if allowImmediateMovementCheck then
		checkMovement()
		checkAreaName()
	end
end

function updateCameraOffset()
	if cameraTimer > 0 then
		cameraTimer -= 1
		if playerRenderPosX == playerDestRenderPosX and playerRenderPosY == playerDestRenderPosY then
			cameraOffsetX = playdate.math.lerp(cameraPrevOffsetX, cameraDestOffsetX, timeLeft(cameraTimer, cameraMaxTimer))
			cameraOffsetY = playdate.math.lerp(cameraPrevOffsetY, cameraDestOffsetY, timeLeft(cameraTimer, cameraMaxTimer))
		elseif playerRenderPosX ~= playerDestRenderPosX or playerRenderPosY ~= playerDestRenderPosY then
			playerRenderPosX = playdate.math.lerp(playerPrevRenderPosX, playerDestRenderPosX, timeLeft(cameraTimer, cameraMaxTimer))
			playerRenderPosY = playdate.math.lerp(playerPrevRenderPosY, playerDestRenderPosY, timeLeft(cameraTimer, cameraMaxTimer))
		end

		if cameraTimer == cameraMaxTimer * 0.5 then
			playerImgIndex = 1
		end

		if cameraTimer == 0 then
			onMoveEnd()
		end
	end
end