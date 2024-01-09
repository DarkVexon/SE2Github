class('Monster').extends()

monsterInfo = json.decodeFile("data/monsters.json")

monsterImgs = {}
for k, v in pairs(monsterInfo) do
	monsterImgs[k] = gfx.image.new("img/monster/" .. k .. ".png")
end

function Monster:init(data)
	self.randomnum = data["randomNum"]
	self.species = data["species"]
	self.img = monsterImgs[self.species]
	self.name = data["name"]
	self.level = data["level"]
	self.nature = data["nature"]
	self.mark = data["mark"]
	self.item = data["item"]
	self.curHp = data["curHp"]
	self.curStatus = data["curStatus"]

	self:loadSpeciesData()
end

function hpFromLevelFunc(base, level)
	return math.floor(((base * level) / 100) + (10 - math.floor(level / 10)))
end

function otherStatFromLevelFunc(base, level)
	return math.floor((base*level)/100)
end

function getStats(species, level, nature, mark)
	local stats = monsterInfo[species]["stats"]
	local hp, attack, defense, speed
	hp = hpFromLevelFunc(stats[1], level)
	attack = otherStatFromLevelFunc(stats[2], level)
	defense = otherStatFromLevelFunc(stats[3], level)
	speed = otherStatFromLevelFunc(stats[4], level)
	return hp, attack, defense, speed
end

function Monster:loadSpeciesData()
	self.types = monsterInfo[self.species]["types"]
	self.ability = monsterInfo[self.species]["ability"]
	local hp, attack, defense, speed = getStats(self.species, self.level, self.nature, self.mark)
	self.maxHp = hp
	self.attack = attack
	self.defense = defense
	self.speed = speed
end

function randomEncounterMonster(species)
	local monsterData = {}
	monsterData["randomNum"] = math.random(1, 10000)
	monsterData["species"] = species
	monsterData["name"] = monsterInfo[species]["speciesName"]
	monsterData["level"] = 10
	monsterData["nature"] = "Bored"
	monsterData["mark"] = "Tough"
	monsterData["item"] = nil
	monsterData["curHp"] = 31
	monsterData["curStatus"] = nil
	return Monster(monsterData)
end