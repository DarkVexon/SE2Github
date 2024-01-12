class('Ability').extends()

abilityInfo = json.decodeFile("data/abilities.json")

function Ability:init(name, owner)
	local data = abilityInfo[name]
	self.id = name
	self.name = data["abilityName"]
	self.description = data["description"]
	self.owner = owner
end

function Ability:displaySelf()
	addScript(TextScript(self.owner:messageBoxName() .. "'s " .. self.name .. " activated!"))
end

function Ability:displaySelfTop()
	addScriptTop(TextScript(self.owner:messageBoxName() .. "'s " .. self.name .. " activated!"))
end

-- HOOKS

function Ability:whenHit(damage, damageType)

end

function Ability:onUseMove(move)

end

function Ability:onDeath()

end

function Ability:onDealDamage(damage, damageType)

end

function Ability:modifyIncomingDamage(damage, damageType)
	return damage
end

function Ability:onEnterCombat()

end

-- IMPORTS
import "abilities/lovebug"
import "abilities/backforseconds"
import "abilities/explosive"
import "abilities/tastetester"
import "abilities/steelsoul"
import "abilities/dentalcarry"
import "abilities/snapper"

function getAbilityByName(name, owner)
	if name == "Lovebug" then
		return Lovebug(owner)
	elseif name == "Back for Seconds" then
		return BackForSeconds(owner)
	elseif name == "Explosive" then
		return Explosive(owner)
	elseif name == "Taste Tester" then
		return TasteTester(owner)
	elseif name == "Steel Soul" then
		return SteelSoul(owner)
	elseif name == "Dental Carry" then
		return DentalCarry(owner)
	elseif name == "Snapper" then
		return Snapper(owner)
	end
end