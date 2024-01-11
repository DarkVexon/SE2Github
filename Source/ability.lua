class('MonsterAbility').extends()

abilityInfo = json.decodeFile("data/abilities.json")

function MonsterAbility:init(name)
	local data = abilityInfo[name]
	self.id = name
	self.name = data["abilityName"]
	self.description = data["description"]
end

function MonsterAbility:displaySelf()

end

-- HOOKS

function MonsterAbility:whenHit(damage, type, attacker)

end

function MonsterAbility:onUseMove(move)

end

-- IMPORTS
import "abilities/lovebug"
import "abilities/backforseconds"

function getAbilityByName(name)
	if name == "Lovebug" then
		return Lovebug()
	elseif name == "Back for Seconds" then
		return BackForSeconds()
	end
end