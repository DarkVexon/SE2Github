tilesets = {}
impassableTiles = {}
randomEncounterTiles = {}
outdoorsTiles = gfx.tilemap.new()
outdoorsTable = gfx.imagetable.new("img/overworld/tile/outdoors-table-40-40")
outdoorsTiles:setImageTable(outdoorsTable)
indoorsTiles = gfx.tilemap.new()
indoorsTable = gfx.imagetable.new("img/overworld/tile/indoors-table-40-40")
indoorsTiles:setImageTable(indoorsTable)
tilesets["outdoors"] = outdoorsTiles
tilesets["indoors"] = indoorsTiles

tilesetInfo = json.decodeFile("data/tiles.json")

currentMap = nil
currentTileset = nil



function loadMap(map, transloc)
	currentMap = map
	local mapResult = json.decodeFile("maps/" .. map .. ".json")
	local tilesToUse = mapResult["tiles"]
	tilesets[tilesToUse]:setTiles(mapResult["data"], mapResult["width"])
	currentTileset = tilesets[tilesToUse]

	mapWidth, mapHeight = tilesets[tilesToUse]:getSize()
	passables = tilesetInfo[tilesToUse]["passable"]
	encounterTiles = tilesetInfo[tilesToUse]["encounter"]
	randomEncounters = mapResult["encountertable"]
	encounterChance = mapResult["encounterchance"]
	clear(objs)
	for i, v in ipairs(mapResult["npcs"]) do
		loadNpc(v)
	end
	local targetTransloc = mapResult["translocs"][transloc]
	playerX = targetTransloc[1]
	playerY = targetTransloc[2]
	playerPrevX = playerX
	playerPrevY = playerY
	mapBg = mapResult["background"]
	if mapBg == "white" then
		gfx.setBackgroundColor(gfx.kColorWhite)
	elseif mapBg == "black" then
		gfx.setBackgroundColor(gfx.kColorBlack)
	end
	setPlayerFacing(targetTransloc[3])
	hardSetupCameraOffsets()
end

function loadNextMap()
	loadMap(nextMap, nextTransloc)
	if curScreen ~= 0 then
		openMainScreen()
	end
end