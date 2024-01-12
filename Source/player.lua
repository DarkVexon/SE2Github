playerName = "Dr. Qupo"
playerMonsters = {
	randomEncounterMonster("Mx Roboto", {10, 12})
}
playerMonsterStorage = {

}
playerItems = {
	[Poutine()] = 1,
	[CaptureCube()] = 2
}

playerDex = {}
for i, k in ipairs(getTableKeys(monsterInfo)) do
	table.insert(playerDex, math.random(0, 2))
end