class('Poutine').extends(Item)

function Poutine:init()
	Poutine.super.init(self, "Poutine")
end

function Poutine:use()
	if turnExecuting then
		self:displaySelf(playerName)
		addScript(HealingScript(20, playerMonster))
	else
		-- TODO: Heal from ooc
	end
end