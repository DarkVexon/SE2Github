local levelSetups <const> = {5, 25, 50, 75}

function quickBattle()
	local levelCap = levelSetups[math.random(#levelSetups)]
	playerName = "Mindbomber"
	playerMonsters = {}
	playerMonsters[1] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	playerMonsters[2] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	playerMonsters[3] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	playerMonsters[4] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	playerItems = {["Poutine"] = 3}
	playerKeyItems = {}
	playerMoney = 100
	playerKeyItems = {
		["Kenedar Map"] = 1
	}
	playerFlag = 100
	playerRetreatMap = "testtownroom1"
	playerPickedUpItems = {}
	playerBeatenTrainers = {}	
	playerDex = {}
	for i, k in ipairs(getTableKeys(monsterInfo)) do
		playerDex[k] = 0
	end

	enemyMonsters = {}
	enemyMonsters[1] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	enemyMonsters[2] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	enemyMonsters[3] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	enemyMonsters[4] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	startFade(resetCombat)
	isTrainerBattle = true

	curTrainerName = "Dr. Syte, M.D., P.H.D"
	local imgWanted = "rival"
	if (containsKey(trainerImgs, imgWanted)) then
		curTrainerImg = trainerImgs[imgWanted]
	else
		trainerImgs[imgWanted] = gfx.image.new("img/combat/trainers/" .. imgWanted)
		curTrainerImg = trainerImgs[imgWanted]
	end
end