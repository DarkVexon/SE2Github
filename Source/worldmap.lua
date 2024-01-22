local WORLD_MAP_START_X <const> = 30
local WORLD_MAP_START_Y <const> = 20

local WORLD_MAP_WIDTH <const> = 400 - WORLD_MAP_START_X * 2
local WORLD_MAP_HEIGHT <const> = 240 - WORLD_MAP_START_Y * 2

local WORLD_MAP_TILESIZE <const> = 20

local WORLD_MAP_TILEWIDTH <const> = WORLD_MAP_WIDTH / WORLD_MAP_TILESIZE
local WORLD_MAP_TILEHEIGHT <const> = WORLD_MAP_HEIGHT / WORLD_MAP_TILESIZE

local WORLD_MAP_IMG <const> = gfx.image.new("img/worldmap/map")
local WORLD_MAP_CURSOR <const> = gfx.image.new("img/worldmap/mapCursor")
local WORLD_MAP_PLAYER <const> = gfx.image.new("img/worldmap/playerIcon")
local WORLD_MAP_FLAG <const> = gfx.image.new("img/worldmap/flagIcon")

local WORLD_MAP_INFO <const> = json.decodeFile("data/locations.json")

local JOURNAL_WIDTH <const> = 300
local JOURNAL_POSX <const> = (400 - JOURNAL_WIDTH) / 2
local JOURNAL_STARTY <const> = 220
local JOURNAL_MAX_CRANK <const> = 200

worldMapCursorX = 1
worldMapCursorY = 1

worldMapCrankAmt = 0
worldMapFlagLocationX = nil
worldMapFlagLocationY = nil

function openWorldMap()
	curScreen = 12
	worldMapPlayerX, worldMapPlayerY = getPlayerWorldMapPos()
	worldMapCursorX = worldMapPlayerX
	worldMapCursorY = worldMapPlayerY
	worldMapCrankAmt = 0
end

function getPlayerWorldMapPos()
	for k, v in pairs(WORLD_MAP_INFO) do
		if k == curAreaName then
			curMapSelectedArea = k
			mapBoxWidth = gfx.getTextSize(k) + 10
			return v[1], v[2]
		end
	end
	return 1, 1
end

function checkWorldMapHover()
	local foundOne = false
	for k, v in pairs(WORLD_MAP_INFO) do
		if worldMapCursorX >= v[1] and worldMapCursorY >= v[2] and worldMapCursorX < v[1] + v[3] and worldMapCursorY < v[2] + v[4] then
			foundOne = true
			curMapSelectedArea = k
			mapBoxWidth = gfx.getTextSize(k) + 10
		end
	end
	if not foundOne then
		curMapSelectedArea = nil
	end
end

function updateWorldMap()
	local input = playdate.getCrankChange() / 2
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		if worldMapCursorY > 1 then
			worldMapCursorY -= 1
			checkWorldMapHover()
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		if worldMapCursorY < WORLD_MAP_TILEHEIGHT-2 then
			worldMapCursorY += 1
			checkWorldMapHover()
		end
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		if worldMapCursorX > 1 then
			worldMapCursorX -= 1
			checkWorldMapHover()
		end
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		if worldMapCursorX < WORLD_MAP_TILEWIDTH-2 then
			worldMapCursorX += 1
			checkWorldMapHover()
		end
	elseif playdate.buttonJustPressed(playdate.kButtonB) then
		startFade(openMainScreen)
	elseif playdate.buttonJustPressed(playdate.kButtonA) then
		worldMapFlagLocationX = worldMapCursorX * 40 * 10
		worldMapFlagLocationY = worldMapCursorY * 40 * 10
	end
	if input ~= 0 then
		worldMapCrankAmt += input
		if worldMapCrankAmt < 0 then
			worldMapCrankAmt = 0
		end
		if worldMapCrankAmt > JOURNAL_MAX_CRANK then
			worldMapCrankAmt = JOURNAL_MAX_CRANK
		end
	end
end

function drawWorldMap()
	--drawNiceRect(5, 5, 45, 20)
	--gfx.drawText("MAP", 7, 7)
	WORLD_MAP_IMG:draw(WORLD_MAP_START_X + 20, WORLD_MAP_START_Y + 20)

	if worldMapFlagLocationX ~= nil and worldMapFlagLocationY ~= nil then
		WORLD_MAP_FLAG:draw(worldMapFlagLocationX * WORLD_MAP_TILESIZE + 20 + 10, worldMapFlagLocationY * WORLD_MAP_TILESIZE + 20)
	end

	if math.floor(bobTime/2) % 2 == 0 then
		WORLD_MAP_PLAYER:draw(worldMapPlayerX, worldMapPlayerY)
	end

	if curMapSelectedArea ~= nil then
		drawNiceRect(150, 5, mapBoxWidth, 20)
		gfx.drawText(curMapSelectedArea, 152, 7)
	end

	WORLD_MAP_CURSOR:draw(WORLD_MAP_START_X + worldMapCursorX * WORLD_MAP_TILESIZE + 4, WORLD_MAP_START_Y + (worldMapCursorY-1) * WORLD_MAP_TILESIZE + 12)

	drawNiceRect(JOURNAL_POSX, JOURNAL_STARTY - worldMapCrankAmt, JOURNAL_WIDTH, JOURNAL_MAX_CRANK)
	gfx.drawTextAligned("Assignments", JOURNAL_POSX + (JOURNAL_WIDTH/2), JOURNAL_STARTY - worldMapCrankAmt + 20, kTextAlignment.center)
	gfx.drawText("- Catch all Kenemon (" .. getDexProgress(2) .. "/" .. numMonsters .. ")", JOURNAL_POSX + 15, JOURNAL_STARTY - worldMapCrankAmt + 50)

	drawBackButton()
end