class('MoveTeacher').extends('UseOnMonsterItem')

function MoveTeacher:init(move)
	MoveTeacher.super.init(self, "Move Teacher")
	self.moveID = move
	self.name = move .. " Teacher"
	self.description = "Use this to teach a Kenermon " .. move .. "."
end

function MoveTeacher:useOutsideCombat(monster)
	if #monster.moves == 4 then
		local options = {}
		local functions = {}
		for i, v in ipairs(monster.moves) do
			table.insert(options, v.name)
			table.insert(functions, function () monster.moves[i] = getMoveByName(self.moveID) showTextBox(monster.name .. " learned " .. self.moveID .. "!") self:consumeOne() end)
		end

		showQueryTextBox("Which move should be replaced?", options, functions, true)
	else
		table.insert(monster.moves, getMoveByName(self.moveID))
		showTextBox(monster.name .. " learned " .. self.moveID .. "!") 
		self:consumeOne()
	end
end

function MoveTeacher:canUseOnTarget(target)
	for k, v in pairs(target.moves) do
		if v.id == self.moveID then
			showTextBox(target.name .. " already knows " .. v.name .. "!")
			return false
		end
	end
	return true
end