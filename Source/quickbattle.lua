local levelSetups <const> = {5, 25, 50, 75}

function quickBattle()
	local levelCap = levelSetups[math.random(#levelSetups)]
	playerName = "Mindbomber"
	playerMonsters = {}
	for i=1, 4 do
		playerMonsters[i] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap})
	end
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
	for i=1, 4 do
		enemyMonsters[i] = randomEncounterMonster(randomSpecies(), {levelCap, levelCap}) 
	end
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