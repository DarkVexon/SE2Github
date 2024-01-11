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

import "oneparamscript"
import "twoparamscript"
import "damagescript"
import "queryscript"