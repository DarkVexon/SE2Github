class('MonsterMark').extends()

markInfo = json.decodeFile("data/marks.json")

markImgs = {}
for k, v in pairs(markInfo) do
	markImgs[k] = gfx.image.new("img/mark/" .. k)
end

function MonsterMark:init(name)
	local info = markInfo[name]
	self.name = info["markName"]
	self.description = info["description"]
	self.img = markImgs[self.name]
end

-- HOOKS

function MonsterMark:applyToStats(stats)

end

-- IMPORTS
import "toughmark"

function getMarkByName(name)
	if name == "Tough" then
		return ToughMark()
	end
end