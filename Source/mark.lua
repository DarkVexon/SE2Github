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

function Mark:modifyOutgoingCrit(critChance)
	return critChance
end

-- IMPORTS
import "marks/tough"
import "marks/big"
import "marks/swole"
import "marks/speedy"
import "marks/dodgy"
import "marks/sharp"

function getMarkByName(name)
	if name == "Tough" then
		return Tough()
	elseif name == "Big" then
		return Big()
	elseif name == "Swole" then
		return Swole()
	elseif name == "Speedy" then
		return Speedy()
	elseif name == "Sharp" then
		return Sharp()
	end
end