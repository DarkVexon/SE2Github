class('Monster').extends()

monsterInfo = json.decodeFile("data/monsters.json")

monsterImgs = {}
for k, v in pairs(monsterInfo) do
	monsterImgs[k] = gfx.image.new("img/monster/" .. k)
end

local natureMultPerPoint <const> = 0.2

natures = {
	["Lucky"] = {1, 1, 1, 1},
	["Bored"] = {0, 0, 0, 0},
	["Happy"] = {0, 0, 0, 0},
	["Curious"] = {0, 0, 0, 0},
	["Thoughtful"] = {0, 0, 0, 0},
	["Cute"] = {0, 0, 0, 0},
	["Rude"] = {0, 0, 0, 0},
	["Wiggly"] = {0, 0, 0, 0},
	["Playful"] = {0, 0, 0, 0},
	["Caring"] = {1, -1, 0, 0},
	["Quiet"] = {1, 0, -1, 0},
	["Sleepy"] = {1, 0, 0, -1},
	["Angsty"] = {-1, 1, 0, 0},
	["Reckless"] = {0, 1, -1, 0},
	["Precise"] = {0, 1, 0, -1},
	["Shy"] = {-1, 0, 1, 0},
	["Hungry"] = {0, -1, 1, 0},
	["Smart"] = {0, 0, 1, -1},
	["Impulsive"] = {-1, 0, 0, 1},
	["Evil"] = {0, -1, 0, 1},
	["Crazed"] = {0, 0, -1, 1},
	["Unlucky"] = {-1, -1, -1, -1}
}

function Monster:init(data)
	self.randomnum = data["randomNum"]
	self.species = data["species"]
	self.speciesName = monsterInfo[self.species]["speciesName"]
	self.img = monsterImgs[self.species]
	self.name = data["name"]
	self.level = data["level"]
	self.exp = data["exp"]
	self.nature = data["nature"]
	self.mark = data["mark"]
	self.item = data["item"]
	self.curStatus = data["curStatus"]

	self:loadSpeciesData()

	if (data["curHp"] == nil) then
		self.curHp = self.maxHp
	else
		self.curHp = data["curHp"]
	end
end

function hpFromLevelFunc(base, level)
	return math.floor(((base * level) / 100) + (10 - math.floor(level / 10)))
end

function otherStatFromLevelFunc(base, level)
	return math.floor((base*level)/100)
end

function getStats(species, level, nature, mark)
	local stats = monsterInfo[species]["stats"]
	local results = {
		hpFromLevelFunc(stats[1], level), 
		otherStatFromLevelFunc(stats[2], level), 
		otherStatFromLevelFunc(stats[3], level), 
		otherStatFromLevelFunc(stats[4], level)
	}

	local natureModifiers = natures[nature]
	for i=1, 4 do
		local nextMod = natureModifiers[i] * natureMultPerPoint
		results[i] = results[i] + results[i] * nextMod
	end

	if mark ~= nil then
		mark:applyToStats(results)
	end

	for k, v in pairs(results) do
		results[k] = math.floor(results[k])
	end
	return results[1], results[2], results[3], results[4]
end

function Monster:loadSpeciesData()
	self.types = monsterInfo[self.species]["types"]
	self.ability = getAbilityByName(monsterInfo[self.species]["ability"])
	local hp, attack, defense, speed = getStats(self.species, self.level, self.nature, self.mark)
	self.maxHp = hp
	self.attack = attack
	self.defense = defense
	self.speed = speed
end

function xpNeededForLevel(xpCurve, level)
	if xpCurve == "normal" then
		return level^3
	end
end

function randomEncounterMonster(species)
	local monsterData = {}
	monsterData["randomNum"] = math.random(1, 10000)
	monsterData["species"] = species
	monsterData["name"] = monsterInfo[species]["speciesName"]
	monsterData["level"] = math.random(8, 11)
	monsterData["exp"] = 0
	monsterData["nature"] = randomKey(natures)
	if math.random(0, 10) == 0 then
		monsterData["mark"] = getMarkByName(randomKey(marks))
	else
		monsterData["mark"] = nil
	end
	monsterData["item"] = nil
	monsterData["curHp"] = nil
	monsterData["curStatus"] = nil
	return Monster(monsterData)
end