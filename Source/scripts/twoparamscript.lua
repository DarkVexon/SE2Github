class('TwoParamScript').extends(GameScript)

function TwoParamScript:init(func, param1, param2)
	self.func = func
	self.param1 = param1
	self.param2 = param2
end

function TwoParamScript:execute()
	self.func(self.param1, self.param2)
end

-- SCRIPTS --

function mapChangeScript(map, transloc)
	startFade(loadNextMap)
	nextMap = map
	nextTransloc = transloc
end

function timedTextScript(text, time)
	showTimedTextBox(text, time)
end

function randomEncounterScript(species, range)
	startFade(beginWildBattle)
	wildSpecies = species
	wildLevelRange = range
end