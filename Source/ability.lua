class('MonsterAbility').extends()

abilities = {
	["Lovebug"] = "Reduces enemy ATK by 10% when hit.",
	["Back for Seconds"] = "Attacks hit again for 30% damage."
}

function MonsterAbility:init(name)
	self.name = name
	self.description = abilities[self.name]
end

function getAbilityByName(name)
	if name == "Lovebug" then
		return LovebugAbility()
	elseif name == "Back for Seconds" then
		return BackForSeconds()
	end
end