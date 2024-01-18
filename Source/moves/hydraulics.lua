class('Hydraulics').extends(Move)

function Hydraulics:init()
	Hydraulics.super.init(self, "Hydraulics")
end

function Hydraulics:use(owner, target)
	addScript(TextScript(owner:messageBoxName() .. "'s ATK was raised!"))
	addScript(ApplyStatusScript(owner, AttackUp(owner)))
	addScript(TextScript(owner:messageBoxName() .. "'s SPD was raised!"))
	addScript(ApplyStatusScript(owner, SpeedUp(owner)))
end