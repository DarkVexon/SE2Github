class('Meditate').extends(Move)

function Meditate:init()
	Meditate.super.init(self, "Meditate")
end

function Meditate:use(owner, target)
	addScript(TextScript(owner:messageBoxName() .. "'s Attack increased!"))
	for i=1, 4 do
		addScript(ApplyStatusScript(owner, AttackUp(owner)))
	end
end