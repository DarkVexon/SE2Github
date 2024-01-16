playerName = "Dr. Qupo"
playerMonsters = {

}
playerMonsterStorage = {
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5}),
	randomEncounterMonster(randomSpecies(), {5, 5})
}
playerItems = {
	[Poutine()] = 1,
	[CaptureCube()] = 2,
	[MoveTeacher("Mystery Box")] = 2
}
playerMoney = 100

playerFlag = 1
playerRetreatMap = "testtownroom1"

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
	if playerDex[monster.species] < 2 then
		playerDex[monster.species] = 2
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

addToParty(randomEncounterMonster("Wheart", {5, 5}))
addToParty(randomEncounterMonster(randomSpecies(), {5, 5}))
addToParty(randomEncounterMonster(randomSpecies(), {5, 5}))
addToParty(randomEncounterMonster(randomSpecies(), {5, 5}))
--addToParty(randomEncounterMonster("Hungwy", {5, 5}))
--playerMonsters[1].exp = playerMonsters[1]:xpToNext()-1
