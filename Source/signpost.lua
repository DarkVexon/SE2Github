class('Signpost').extends(GameObject)

function Signpost:init(x, y, text)
	Signpost.super.init(self, "signpost", x, y)
	self.text = text
end

function Signpost:onInteract()
	table.insert(scriptStack, OneParamScript(textScript, "so you have come into my house. this can only mean one thing. one of us will fall. pray it will be me"))
	table.insert(scriptStack, OneParamScript(textScript, "I, SIGNPOSTY, will do the honor of facing you in the world's first MONSTER BATTLE!"))
	table.insert(scriptStack, OneParamScript(combatScript, "WildEncounterDubldraker"))
	nextScript()
end