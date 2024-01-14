class('Script').extends()

function Script:init(name)
	self.name = name
end

function Script:execute()

end

function addScript(script)
	table.insert(scriptStack, script)
end

function addScriptTop(script)
	table.insert(scriptStack, 1, script)
end

scriptStack = {}

-- SCRIPTS

-- IMPORTS

import "scripts/damagescript"
import "scripts/queryscript"
import "scripts/startanimscript"
import "scripts/applystatusscript"
import "scripts/moveattackscript"
import "scripts/textscript"
import "scripts/healingscript"
import "scripts/calculateddamagescript"
import "scripts/lambdascript"
import "scripts/mapchangescript"
import "scripts/randomencounterscript"
import "scripts/startanimscript"
import "scripts/timedtextscript"
import "scripts/trainerbattlescript"
import "scripts/transitionscript"
import "scripts/changecombatintrophasescript"
import "scripts/swapmonsterscript"