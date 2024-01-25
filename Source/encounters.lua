local encounterData <const> = json.decodeFile("data/encounters.json")

function getEncounterChance()
	return encounterData[curAreaName]["encounterchance"]
end

function getEncounterTable()
	return encounterData[curAreaName]["encountertable"]
end