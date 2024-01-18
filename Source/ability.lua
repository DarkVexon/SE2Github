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

function Ability:getCopy(owner)
	return getAbilityByName(self.id, owner)
end

function Ability:modifyIncomingMiss(missChance)
	return missChance
end

function Ability:atEndOfTurn()

end

function Ability:modifyAttack(attack)
	return attack
end

function Ability:modifyDefense(defense)
	return defense
end

function Ability:modifySpeed(speed)
	return speed
end

function Ability:update()

end

function Ability:render()

end

function Ability:receiveStatusApplied(incomingStatus)

end

function Ability:modifyOutgoingDamage(damage, damageType)

end

function Ability:modifyTypeMatchup(type)
	return 1
end

-- IMPORTS
import "abilities/lovebug"
import "abilities/backforseconds"
import "abilities/explosive"
import "abilities/tastetester"
import "abilities/steelsoul"
import "abilities/dentalcarry"
import "abilities/snapper"
import "abilities/innovator"
import "abilities/skitter"
import "abilities/fastasfire"
import "abilities/crybaby"
import "abilities/upsidedown"
import "abilities/devourer"
import "abilities/wandwaver"
import "abilities/springspout"
import "abilities/muffledneighing"
import "abilities/alienated"
import "abilities/puffedplumage"
import "abilities/iridescence"

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
	elseif name == "Innovator" then
		return Innovator(owner)
	elseif name == "Skitter" then
		return Skitter(owner)
	elseif name == "Fast as Fire" then
		return FastAsFire(owner)
	elseif name == "Crybaby" then
		return Crybaby(owner)
	elseif name == "UpsideDown" then
		return UpsideDown(owner)
	elseif name == "Devourer" then
		return Devourer(owner)
	elseif name == "Wand Waver" then
		return WandWaver(owner)
	elseif name == "Spring Spout" then
		return SpringSpout(owner)
	elseif name == "Muffled Neighing" then
		return MuffledNeighing(owner)
	elseif name == "Alienated" then
		return Alienated(owner)
	elseif name == "Puffed Plumage" then
		return PuffedPlumage(owner)
	elseif name == "Iridescence" then
		return Iridescence(owner)
	end
end

function randomAbility(owner)
	--TODO TOO LAZY
	return getAbilityByName("Devourer", owner)
end