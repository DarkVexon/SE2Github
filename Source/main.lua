import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/math"

gfx = playdate.graphics
sfx = playdate.sound

import "helpers"
import "gameobject"
import "gamescript"
import "textscript"
import "motionscript"
import "npcs"
import "maps"

-- CORE --
local gridSize <const> = 40
local gridWidth <const> = 400/40
local gridHeight <const> = 240/40

-- STUFF THAT ALWAYS IMPORTANT
gameFont = gfx.font.new("font/Sasser Slab/Sasser-Slab-Bold")
gfx.setFont(gameFont)
guyImgN = gfx.image.new("img/guy-n")
guyImgE = gfx.image.new("img/guy-e")
guyImgS = gfx.image.new("img/guy-s")
guyImgW = gfx.image.new("img/guy-w")

tilesets = {}
tileInfo = {}
overworldTiles = gfx.tilemap.new()
overworldTable = gfx.imagetable.new("img/overworld-table-40-40")
overworldTiles:setImageTable(overworldTable)
tilesets["overworld"] = overworldTiles
tileInfo["overworld"] = {3}
objs = {}

local cameraHorizBuffer <const> = -6
local cameraVertBuffer <const> = -3
camWidth = 400/40
camHeight = 240/40

function hardSetupCameraOffsets()
	cameraOffsetGridX = (playerX + cameraHorizBuffer)
	cameraOffsetGridY = (playerY + cameraVertBuffer)
	cameraOffsetX = cameraOffsetGridX * -40
	cameraOffsetY = cameraOffsetGridY * -40
	cameraDestOffsetX = cameraOffsetX
	cameraDestOffsetY = cameraOffsetY
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

loadMap("testtown", 1)

-- VARIABLES THAT ALWAYS IMPORTANT
playerCreatures = {}
playerBag = {}





movingCam = false

textBoxText = ""
textBoxShown = false
textBoxScrollDone = false
textBoxTime = 0
textBoxTotalTime = 0
local textBoxTimePerLetter <const> = 2
fadeOutTimer = 0
fadeInTimer = 0

local lineThickness <const> = 2

scriptStack = {}

function nextScript()
	if #scriptStack == 0 then

	else
		local nextFound = table.remove(scriptStack, 1)
		nextFound:execute()
	end
end

function showTextBox(text)
	textBoxText = text
	textBoxDisplayedText = ""
	textBoxShown = true
	textBoxScrollDone = false
	textBoxTime = 0
	textBoxLetterIndex = 0
end

function hideTextBox()
	textBoxShown = false
	nextScript()
end

function updateTextBox()
	if textBoxScrollDone then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			hideTextBox()
		end
	else
		if playdate.buttonJustPressed(playdate.kButtonB) then
			textBoxDisplayedText = textBoxText
			textBoxScrollDone = true
		else
			if playdate.buttonIsPressed(playdate.kButtonA) then
				textBoxTime += 2
			else
				textBoxTime += 1
			end
			if textBoxTime >= textBoxTimePerLetter then
				textBoxDisplayedText = textBoxDisplayedText .. string.sub(textBoxText, textBoxLetterIndex, textBoxLetterIndex)
				textBoxLetterIndex += 1
				textBoxTime = 0
				if textBoxLetterIndex > #textBoxText then
					textBoxScrollDone = true
				end
			end
		end
	end
end

function initialize()
	gfx.setLineWidth(lineThickness)
end

function playdate.update()
	if (fadeOutTimer > 0 or fadeInTimer > 0) then
		if fadeOutTimer > 0 then
			fadeOutTimer -= 1
			if fadeOutTimer == 0 then
				loadMap(nextMap, nextTransloc)
				transitionImg = gfx.image.new(400, 240)
				gfx.pushContext(transitionImg)
				render()
				gfx.popContext()
				fadeInTimer = 15
			end
		elseif fadeInTimer > 0 then
			fadeInTimer -= 1
		end

		renderFade()
	else
		if (textBoxShown) then
			updateTextBox()
		else
			for i, v in ipairs(objs) do
				v:update()
			end

			if (movingCam) then
				updateCameraOffset()
			else
				checkMovement()
			end
		end

		render()
	end
end

local textBoxOuterBuffer <const> = 10
local textBoxPosY <const> = 120
local textBoxOutlineSize <const> = 2
local textBoxTextBufferSize <const> = 4
local textBoxWidth <const> = 400 - (textBoxOuterBuffer * 2)
local textBoxHeight <const> = 240 - textBoxPosY - (textBoxOuterBuffer * 2)

function render()
	gfx.clear()



	overworldTiles:draw(cameraOffsetX, cameraOffsetY)

	for i, v in ipairs(objs) do
		v:render()
	end

	playerImg:draw(200, 80)

	if textBoxShown then
		gfx.drawRoundRect(textBoxOuterBuffer, textBoxPosY, textBoxWidth, textBoxHeight, textBoxOutlineSize)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(textBoxOuterBuffer + 1, textBoxPosY + 1, textBoxWidth - 2, textBoxHeight - 2, textBoxOutlineSize)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawTextInRect(textBoxDisplayedText, textBoxOuterBuffer + textBoxTextBufferSize, textBoxPosY + textBoxTextBufferSize, textBoxWidth - (textBoxTextBufferSize*2), textBoxHeight - (textBoxTextBufferSize*2))
		
		if textBoxScrollDone then
			gfx.fillTriangle(400 - (textBoxOuterBuffer * 4), textBoxPosY + (textBoxOuterBuffer * 8), 400 - (textBoxOuterBuffer * 3), textBoxPosY + (textBoxOuterBuffer * 8), 400 - (textBoxOuterBuffer * 3.5), textBoxPosY + (textBoxOuterBuffer * 9))
		end
	end
end

function canMoveThere(x, y) 
	local result = overworldTiles:getTileAtPosition(x, y)
	if (contains(impassables, result)) then
		return false
	end
	for i, v in ipairs(objs) do
		if (v.posX == x and v.posY == y and not v:canMoveHere()) then
			return false
		end
	end
	return true
end

function setupCameraOffset()
	cameraOffsetGridX = (playerX + cameraHorizBuffer)
	cameraOffsetGridY = (playerY + cameraVertBuffer)
	cameraDestOffsetX = cameraOffsetGridX * -40
	cameraDestOffsetY = cameraOffsetGridY * -40
	movingCam = true
end

local cameraMoveSpeed <const> = 5

function checkMovement() 
	if (playdate.buttonIsPressed(playdate.kButtonUp)) then
		setPlayerFacing(0)
		if (canMoveThere(playerX, playerY-1)) then
			playerMoveBy(0, -1)
			return
		end
	end
	if (playdate.buttonIsPressed(playdate.kButtonDown)) then
		setPlayerFacing(2)
		if (canMoveThere(playerX, playerY+1)) then
			playerMoveBy(0, 1)
			return
		end
	end
	if (playdate.buttonIsPressed(playdate.kButtonLeft)) then
		setPlayerFacing(3)
		if (canMoveThere(playerX - 1, playerY)) then
			playerMoveBy(-1, 0)
			return
		end
	end
	if (playdate.buttonIsPressed(playdate.kButtonRight)) then
		setPlayerFacing(1)
		if (canMoveThere(playerX + 1, playerY)) then
			playerMoveBy(1, 0)
			return
		end
	end
	if (playdate.buttonJustPressed(playdate.kButtonA)) then
		local tarX, tarY = getPlayerPointCoord()
		for i, v in ipairs(objs) do
			if (v.posX == tarX and v.posY == tarY) then
				v:onInteract()
			end
		end
	end
end

function playerMoveBy(x, y)
	if (x ~= 0 or y ~= 0) then
		playerX += x
		playerY += y
		setupCameraOffset()
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

function updateCameraOffset()
	if (cameraOffsetX > cameraDestOffsetX) then
		cameraOffsetX -= cameraMoveSpeed
		if (cameraOffsetX < cameraDestOffsetX) then
			cameraOffsetX = cameraDestOffsetX
		end
	elseif (cameraOffsetX < cameraDestOffsetX) then
		cameraOffsetX += cameraMoveSpeed
		if (cameraOffsetX > cameraDestOffsetX) then
			cameraOffsetX = cameraDestOffsetX
		end
	end
	if (cameraOffsetY > cameraDestOffsetY) then
		cameraOffsetY -= cameraMoveSpeed
		if (cameraOffsetY < cameraDestOffsetY) then
			cameraOffsetY = cameraDestOffsetY
		end
	elseif (cameraOffsetY < cameraDestOffsetY) then
		cameraOffsetY += cameraMoveSpeed
		if (cameraOffsetY > cameraDestOffsetY) then
			cameraOffsetY = cameraDestOffsetY
		end
	end
	if (cameraOffsetX == cameraDestOffsetX and cameraOffsetY == cameraDestOffsetY) then
		movingCam = false
		allowImmediateMovementCheck = true
		for k, v in ipairs(objs) do
			if v.posX == playerX and v.posY == playerY then
				v:onOverlap()
				if not v:allowImmediateMovementAfterStep() then
					allowImmediateMovementCheck = false
				end
			end
		end
		if allowImmediateMovementCheck then
			checkMovement()
		end
	end
end

local fadeCircEndpoint = math.sqrt(400^2 + 240^2)/2

function renderFade()
	if fadeOutTimer > 0 then
		gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(0, 1, ((15-fadeOutTimer)/14)) * fadeCircEndpoint)
	elseif fadeInTimer > 0 then
		gfx.clear()
		transitionImg:draw(0, 0)
		gfx.fillCircleAtPoint(200, 120, playdate.math.lerp(1, 0, ((15-fadeInTimer)/14)) * fadeCircEndpoint)
	end
end

initialize()