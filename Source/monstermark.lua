class('MonsterMark').extends()

marks = {
	--["Big"] = "+20% max HP",
	--["Strong"] = "+20% ATK",
	--["Quick"] = "+20% SPD",
	--["Tricky"] = "Moves first turn 1",
	--["Immune"] = "30% Status Resist Chance",
	--["Dodgy"] = "1% Dodge Chance",
	["Tough"] = "+20% DEF"
}

markImgs = {}
for k, v in pairs(marks) do
	markImgs[k] = gfx.image.new("img/mark/" .. k)
end

function MonsterMark:init(name)
	self.name = name
	self.description = marks[self.name]
	self.img = markImgs[self.name]
end

function MonsterMark:applyToStats(stats)

end

-- IMPORTS

import "toughmark"

function getMarkByName(name)
	if name == "Tough" then
		return ToughMark()
	end
end