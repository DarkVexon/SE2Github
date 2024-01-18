class('Prayer').extends(Move)

function Prayer:init()
	Prayer.super.init(self, "Prayer")
end

function Prayer:use(owner, target)
	addScript(HealingScript(owner, owner.maxHp * 0.3))
	addScript(TextScript(owner:messageBoxName() .. "'s SPD was raised!"))
	addScript(ApplyStatusScript(owner, SpeedUp(owner)))
end