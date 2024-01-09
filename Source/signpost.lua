class('Signpost').extends(GameObject)

function Signpost:init(x, y, text)
	Signpost.super.init(self, "signpost", x, y)
	self.text = text
end

function Signpost:onInteract()
	table.insert(scriptStack, TextScript("I, SIGNPOSTY, will do the honor of facing you in the world's first MONSTER BATTLE!"))
	table.insert(scriptStack, EnterCombatScript("signposty"))
	nextScript()
end