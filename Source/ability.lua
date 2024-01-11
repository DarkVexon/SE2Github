class('MonsterAbility').extends()

abilityInfo = json.decodeFile("data/abilities.json")

function MonsterAbility:init(name)
	local data = abilityInfo[name]
	self.name = data["abilityName"]
	self.description = data["description"]
end

-- HOOKS

-- IMPORTS
import "lovebugability"
import "backforsecondsability"

function getAbilityByName(name)
	if name == "Lovebug" then
		return Lovebug()
	elseif name == "Back for Seconds" then
		return BackForSeconds()
	end
end