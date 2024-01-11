class('GameScript').extends()

function GameScript:init(func)
	self.func = func
end

function GameScript:execute()
	self.func()
end

function addScript(script)
	table.insert(scriptStack, script)
end

scriptStack = {}

function nextScript()
	if #scriptStack == 0 then
		if curScreen == 3 then
			getNextCombatActions()
		end
	else
		local nextFound = table.remove(scriptStack, 1)
		nextFound:execute()
	end
end

function getNextCombatActions()
	if movesExecuting then
		movesExecuting = false
	end
end


-- SCRIPTS

function healMonstersToOne()
	for k, v in pairs(playerMonsters) do
		if v.curHp == 0 then
			v.curHp = 1
		end
	end
end

function endTurn()
	movesExecuting = false
end

-- IMPORTS

import "scripts/oneparamscript"
import "scripts/twoparamscript"
import "scripts/damagescript"
import "scripts/queryscript"