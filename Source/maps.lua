objs = {}
storedOverworldObjs = nil

overworldMapInfo = json.decodeFile("maps/overworld.json")

outdoorsTable = gfx.imagetable.new("img/overworld/tile/outdoors-table-40-40")
indoorsTable = gfx.imagetable.new("img/overworld/tile/indoors-table-40-40")

overworldTiles = gfx.tilemap.new()
overworldTiles:setImageTable(outdoorsTable)

tilesets = {}
impassableTiles = {}
randomEncounterTiles = {}

indoorsTiles = gfx.tilemap.new()
indoorsTiles:setImageTable(indoorsTable)

tilesets["outdoors"] = overworldTiles
tilesets["indoors"] = indoorsTiles

tilesetInfo = json.decodeFile("data/tiles.json")

currentMap = nil
currentTileset = nil

function storeOverworldNpcs()
	for i, v in ipairs(objs) do
		table.insert(storedOverworldObjs, v)
	end

	clear(objs)
end

function loadMap(map, x, y, facing)
	currentMap = map
	local mapResult
	if map == "overworld" then
		mapResult = overworldMapInfo
	else
		mapResult = json.decodeFile("maps/" .. map .. ".json")
	end
	local tilesToUse = mapResult["tiles"]
	tilesets[tilesToUse]:setTiles(mapResult["data"], mapResult["width"])

	mapWidth, mapHeight = tilesets[tilesToUse]:getSize()
	passables = tilesetInfo[tilesToUse]["passable"]
	encounterTiles = tilesetInfo[tilesToUse]["encounter"]
	stepSwaps = tilesetInfo[tilesToUse]["stepSwaps"]
	randomEncounters = mapResult["encountertable"]
	encounterChance = mapResult["encounterchance"]
	dividers = mapResult["dividers"]

	clear(objs)
	for i, v in ipairs(mapResult["npcs"]) do
		loadNpc(v)
	end

	mapBg = mapResult["background"]
	
	currentTileset = tilesets[tilesToUse]

	playerX = x
	playerY = y
	playerPrevX = playerX
	playerPrevY = playerY

	if mapBg == "white" then
		gfx.setBackgroundColor(gfx.kColorWhite)
	elseif mapBg == "black" then
		gfx.setBackgroundColor(gfx.kColorBlack)
	end
	setPlayerFacing(facing)
	hardSetupCameraOffsets()
end

function loadMapFromTransloc(map, transloc)
	local targetTransloc
	if map == "overworld" then
		targetTransloc = overworldMapInfo["translocs"][transloc]
	else
		local mapResult = json.decodeFile("maps/" .. map .. ".json")
		targetTransloc = mapResult["translocs"][transloc]
	end

	loadMap(map, targetTransloc[1], targetTransloc[2], targetTransloc[3])
end

function loadNextMap()
	loadMapFromTransloc(nextMap, nextTransloc)
	if curScreen ~= 0 then
		openMainScreen()
	end
end