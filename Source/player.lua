playerName = "Dr. Qupo"
playerMonsters = {

}
playerMonsterStorage = {

}
playerItems = {
	["Capture Cube"] = 10
}
playerMoney = 100

playerFlag = 1
playerRetreatMap = "testtownroom1"

playerPickedUpItems = {}
playerBeatenTrainers = {}

playerDex = {}
for i, k in ipairs(getTableKeys(monsterInfo)) do
	playerDex[k] = 2
end

function getDexProgress(type)
	local total = 0
	for k, v in pairs(playerDex) do
		if v >= type then
			total += 1
		end
	end
	return total
end

function addToParty(monster)
	table.insert(playerMonsters, monster)
	if playerDex[monster.species] ~= nil and playerDex[monster.species] < 2 then
		playerDex[monster.species] = 2
	end
end

function obtainItem(itemID)
	if playerItems[itemID] == nil then
		playerItems[itemID] = 1
	else
		playerItems[itemID] = playerItems[itemID]+1
	end
end

function removeFromParty(monster)
	local monIdx = indexValue(playerMonsters, monster)
	if monIdx ~= -1 then
		for i=monIdx, 4 do 
			playerMonsters[i] = playerMonsters[i+1]
		end
	end
end

--addToParty(randomEncounterMonster("Error", {40, 50}))
addToParty(randomEncounterMonster("Circe", {5, 5}))
addToParty(randomEncounterMonster(randomSpecies(), {5, 5}))
addToParty(randomEncounterMonster("Chompah", {5, 5}))
--for i, v in ipairs(playerMonsters) do
--	glitch(v)
--end
--addToParty(randomEncounterMonster("Hungwy", {5, 5}))
--playerMonsters[1].exp = playerMonsters[1]:xpToNext()-25
