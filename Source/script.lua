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

function addScriptTop(script)
	table.insert(scriptStack, 1, script)
end

scriptStack = {}

-- SCRIPTS

function healMonstersToOne()
	for k, v in pairs(playerMonsters) do
		if v.curHp == 0 then
			v.curHp = 1
		end
	end
end

-- IMPORTS

import "scripts/oneparamscript"
import "scripts/twoparamscript"
import "scripts/damagescript"
import "scripts/queryscript"
import "scripts/startanimscript"
import "scripts/applystatusscript"
import "scripts/moveattackscript"
import "scripts/textscript"
import "scripts/healingscript"
import "scripts/calculateddamagescript"