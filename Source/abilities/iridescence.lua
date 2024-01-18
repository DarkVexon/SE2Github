class('Iridescence').extends(Ability)

function Iridescence:init(owner)
	Iridescence.super.init(self, "Iridescence")
end

function Iridescence:modifyTypeMatchup(type)
	if type == "fire" or type == "water" or type == "plant" then
		return 0.5
	end
	return 1
end