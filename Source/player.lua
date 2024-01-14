playerName = "Dr. Qupo"
playerMonsters = {

}
playerMonsterStorage = {

}
playerItems = {
	[Poutine()] = 1,
	[CaptureCube()] = 2
}
playerMoney = 100

playerFlag = 1

playerDex = {}
for i, k in ipairs(getTableKeys(monsterInfo)) do
	playerDex[k] = 0
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

addToParty(randomEncounterMonster(randomSpecies(), {5, 5}))
playerMonsters[1].exp = playerMonsters[1]:xpToNext()-1
--addToParty(randomEncounterMonster("Mawrachnid", {5, 5}))