class('Warble').extends(Move)

function Warble:init()
	Warble.super.init(self, "Warble")
end

function Warble:use(owner, target)
	addScript(TextScript(target:messageBoxName() .. "'s ATK was lowered!"))
	addScript(ApplyStatusScript(target, AttackDown(target)))
	addScript(TextScript(target:messageBoxName() .. "'s DEF was lowered!"))
	addScript(ApplyStatusScript(target, DefenseDown(target)))
	addScript(TextScript(target:messageBoxName() .. "'s SPD was lowered!"))
	addScript(ApplyStatusScript(target, SpeedDown(target)))
end