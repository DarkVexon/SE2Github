function newGame()
	initializePlayer()
	loadMapFromTransloc("overworld", 1)
	startFade(openMainScreen)
end

function serializeMonster(monster)
	local monsterData = {}
	monsterData["randomNum"] = monster.randomNum
	monsterData["species"] = monster.species
	monsterData["name"] = monster.name
	monsterData["level"] = monster.level
	monsterData["moves"] = monster:getMoveNames()
	monsterData["exp"] = monster.exp
	monsterData["nature"] = monster.nature
	monsterData["mark"] = monster.mark
	monsterData["item"] = monster.item
	monsterData["curHp"] = monster.curHp
	monsterData["curStatus"] = monster.curStatus
	return monsterData
end

function serializeMonsterList(monsters)
	local monsterDatas = {}
	for i, v in ipairs(monsters) do
		table.insert(monsterDatas, serializeMonster(v))
	end
	return monsterDatas
end

function deserializeMonsterList(monsterDatas)
	local monsters = {}
	for i, v in ipairs(monsterDatas) do
		table.insert(monsters, Monster(v))
	end
	return monsters
end

function saveGame()
	local gameData = {
		dataPlayerName = playerName,
		dataPlayerMonsters = serializeMonsterList(playerMonsters),
		dataPlayerMonsterStorage = serializeMonsterList(playerMonsterStorage),
		dataPlayerItems = playerItems,
		dataPlayerKeyItems = playerKeyItems,
		dataPlayerMoney = playerMoney,
		dataPlayerFlag = playerFlag,
		dataPlayerRetreatMap = playerRetreatMap,
		dataPlayerPickedUpItems = playerPickedUpItems,
		dataPlayerBeatenTrainers = playerBeatenTrainers,
		dataPlayerDex = playerDex,
		dataCurrentMap = currentMap,
		dataPlayerX = playerX,
		dataPlayerY = playerY,
		dataPlayerFacing = playerFacing
	}

	playdate.datastore.write(gameData)
end

function loadSave()
	local gameData = playdate.datastore.read()
	printTable(gameData)

	if gameData then
		if gameData.dataPlayerName == nil then
			playdate.datastore.delete()
		else
			playerName = gameData.dataPlayerName
			playerMonsters = deserializeMonsterList(gameData.dataPlayerMonsters)
			playerMonsterStorage = deserializeMonsterList(gameData.dataPlayerMonsterStorage)
			playerItems = gameData.dataPlayerItems
			playerKeyItems = gamedata.dataPlayerKeyItems
			playerMoney = gameData.dataPlayerMoney
			playerFlag = gameData.dataPlayerFlag
			playerRetreatMap = gameData.dataPlayerRetreatMap
			playerPickedUpItems = gameData.dataPlayerPickedUpItems
			playerBeatenTrainers = gameData.dataPlayerBeatenTrainers
			playerDex = gameData.dataPlayerDex
			loadMap(gameData.dataCurrentMap, gameData.dataPlayerX, gameData.dataPlayerY, gameData.dataPlayerFacing)
			startFade(openMainScreen)
		end
	else
		showTextBox("No game data found!")
	end
end