class('MonsterAbility').extends()

abilities = {
	["Lovebug"] = "Reduces enemy ATK by 10% when hit."
}

function MonsterAbility:init(name)
	self.name = name
	self.description = abilities[self.name]
end

function getAbilityByName(name)
	if name == "Lovebug" then
		return LovebugAbility()
	end
end