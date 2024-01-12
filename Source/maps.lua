tilesets = {}
impassableTiles = {}
randomEncounterTiles = {}
outdoorsTiles = gfx.tilemap.new()
outdoorsTable = gfx.imagetable.new("img/overworld/tile/outdoors-table-40-40")
outdoorsTiles:setImageTable(outdoorsTable)
tilesets["outdoors"] = outdoorsTiles
impassableTiles["outdoors"] = {4, 5, 6, 7}
randomEncounterTiles["outdoors"] = {3}

currentMap = nil
currentTileset = nil

function loadMap(map, transloc)
	currentMap = map
	local mapResult = json.decodeFile("maps/" .. map .. ".json")
	local tilesToUse = mapResult["tiles"]
	tilesets[tilesToUse]:setTiles(mapResult["data"], mapResult["width"])
	currentTileset = tilesets[tilesToUse]

	mapWidth, mapHeight = tilesets[tilesToUse]:getSize()
	impassables = impassableTiles[tilesToUse]
	encounterTiles = randomEncounterTiles[tilesToUse]
	randomEncounters = mapResult["encountertable"]
	clear(objs)
	for i, v in ipairs(mapResult["npcs"]) do
		loadNpc(v)
	end
	local targetTransloc = mapResult["translocs"][transloc]
	playerX = targetTransloc[1]
	playerY = targetTransloc[2]
	setPlayerFacing(targetTransloc[3])
	hardSetupCameraOffsets()
end

function loadNextMap()
	loadMap(nextMap, nextTransloc)
end