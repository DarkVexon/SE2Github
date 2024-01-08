function loadMap(map, transloc)
	local mapResult = json.decodeFile("maps/" .. map .. ".json")
	local tilesToUse = mapResult["tiles"]
	tilesets[tilesToUse]:setTiles(mapResult["data"], mapResult["width"])
	mapWidth, mapHeight = tilesets[tilesToUse]:getSize()
	impassables = tileInfo[tilesToUse]
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
