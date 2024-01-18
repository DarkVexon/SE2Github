class('Scaleshield').extends(Move)

function Scaleshield:init()
	Scaleshield.super.init(self, "Scaleshield")
end

function Scaleshield:use(owner, target)
	addScript(TextScript(owner:messageBoxName() .. " put up a Scaleshield!"))
	addScript(ApplyTeamStatusScript(owner:isFriendly(), ScaleshieldStatus()))
end