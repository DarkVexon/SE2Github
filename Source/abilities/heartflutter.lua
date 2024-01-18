class('Heartflutter').extends(Ability)

function Heartflutter:init(owner)
	Heartflutter.super.init(self, "Heartflutter", owner)
end

function Heartflutter:onUseMove(move, target)
	if move.type == "wing" then
		self:displaySelf()
		addScript(TextScript(target:messageBoxName() .. " was infatuated by " .. self.owner:messageBoxName() .. "!"))
	end
end