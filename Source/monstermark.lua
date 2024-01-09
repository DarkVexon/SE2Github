class('MonsterMark').extends()

marks = {
	["Big"] = "+20% max HP",
	["Strong"] = "+20% ATK",
	["Tough"] = "+20% DEF",
	["Quick"] = "+20% SPD",
	["Tricky"] = "Moves first turn 1",
	["Immune"] = "30% Status Resist Chance",
	["Dodgy"] = "1% Dodge Chance"
}

function MonsterMark:init(name)
	self.name = name
	self.description = marks[self.name]
end

function MonsterMark:applyToStats(stats)

end