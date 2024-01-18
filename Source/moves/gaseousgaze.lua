class('GaseousGaze').extends(Move)

function GaseousGaze:init()
	GaseousGaze.super.init(self, "Gaseous Gaze")
end

function GaseousGaze:use(owner, target)
	addScript(TextScript(target:messageBoxName() .. " became Sick!"))
	addScript(ApplyStatusScript(target, AttackDown(owner)))
end