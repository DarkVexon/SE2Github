local WORLD_MAP_START_X <const> = 30
local WORLD_MAP_START_Y <const> = 20

local WORLD_MAP_WIDTH <const> = 400 - WORLD_MAP_START_X * 2
local WORLD_MAP_HEIGHT <const> = 240 - WORLD_MAP_START_Y * 2

local WORLD_MAP_TILESIZE <const> = 20

local WORLD_MAP_TILEWIDTH <const> = WORLD_MAP_WIDTH / WORLD_MAP_TILESIZE
local WORLD_MAP_TILEHEIGHT <const> = WORLD_MAP_HEIGHT / WORLD_MAP_TILESIZE

local WORLD_MAP_IMG <const> = gfx.image.new("img/worldmap/map_shaded.png")
local WORLD_MAP_CURSOR <const> = gfx.image.new("img/worldmap/mapCursor.png")
local WORLD_MAP_PLAYER <const> = gfx.image.new("img/worldmap/playerIcon.png")

local WORLD_MAP_INFO <const> = json.decodeFile("data/locations.json")

worldMapCursorX = 1
worldMapCursorY = 1

function openWorldMap()
	curScreen = 12
	worldMapCursorX = 1
	worldMapCursorY = 1
	worldMapPlayerX, worldMapPlayerY = getPlayerWorldMapPos()
end

function getPlayerWorldMapPos()
	for k, v in pairs(WORLD_MAP_INFO) do
		if k == curAreaName then
			return v[1]* WORLD_MAP_TILESIZE, v[2]* WORLD_MAP_TILESIZE
		end
	end
end

function updateWorldMap()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		if worldMapCursorY > 1 then
			worldMapCursorY -= 1
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		if worldMapCursorY < WORLD_MAP_TILEHEIGHT-2 then
			worldMapCursorY += 1
		end
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		if worldMapCursorX > 1 then
			worldMapCursorX -= 1
		end
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		if worldMapCursorX < WORLD_MAP_TILEWIDTH-2 then
			worldMapCursorX += 1
		end
	end
end

function drawWorldMap()
	WORLD_MAP_IMG:draw(WORLD_MAP_START_X * 2, WORLD_MAP_START_Y * 2)

	WORLD_MAP_PLAYER:draw(worldMapPlayerX, worldMapPlayerY)

	WORLD_MAP_CURSOR:draw(WORLD_MAP_START_X + worldMapCursorX * WORLD_MAP_TILESIZE + 4, WORLD_MAP_START_Y + (worldMapCursorY-1) * WORLD_MAP_TILESIZE + 12)
end