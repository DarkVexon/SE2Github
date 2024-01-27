class('Innovator').extends(Ability)

function Innovator:init(owner)
	Innovator.super.init(self, "Innovator", owner)
end

function Innovator:onEnterCombat()
	local toCheck = self.owner:getFoe()
	if toCheck.ability.id ~= "Innovator" then
		self:displaySelf()
		addScript(TextScript(self.owner:messageBoxName() .. " copied " .. toCheck.name .. "'s " .. toCheck.ability.name .. "!"))
		addScript(LambdaScript("set ability", function () self.owner.ability = toCheck.ability:getCopy(self.owner) self.owner.ability:onEnterCombat() nextScript() end))
	end
end