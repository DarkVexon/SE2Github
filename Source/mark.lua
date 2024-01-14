class('Mark').extends()

markInfo = json.decodeFile("data/marks.json")

markImgs = {}
for k, v in pairs(markInfo) do
	markImgs[k] = gfx.image.new("img/mark/" .. k)
end

function Mark:init(name)
	local info = markInfo[name]
	self.name = info["markName"]
	self.description = info["description"]
	self.img = markImgs[self.name]
end

-- HOOKS

function Mark:applyToStats(stats)

end

function Mark:modifyIncomingMiss(missChance)
	return missChance
end

-- IMPORTS
import "marks/tough"
import "marks/big"
import "marks/swole"
import "marks/speedy"
import "marks/dodgy"

function getMarkByName(name)
	if name == "Tough" then
		return ToughMark()
	elseif name == "Big" then
		return BigMark()
	elseif name == "Swole" then
		return SwoleMark()
	elseif name == "Speedy" then
		return SpeedyMark()
	end
end