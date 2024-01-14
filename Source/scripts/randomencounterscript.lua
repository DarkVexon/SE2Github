class('RandomEncounterScript').extends(Script)

function RandomEncounterScript:init(species, range)
	RandomEncounterScript.super.init(self, "Random encounter with species " .. species .. " with level range " .. range[1] .. "-" .. range[2])
	self.species = species
	self.range = range
end

function RandomEncounterScript:execute()
	startFade(beginWildBattle)
	wildSpecies = self.species
	wildLevelRange = self.range
end