class('HealingMachineInvis').extends(NPC)

function HealingMachineInvis:init(x, y, pretext, posttext)
	HealingMachineInvis.super.init(self, "healmachine", x, y)
	self.pretext = text
	self.posttext = text
end

function fullyRestoreMonsters()
	for k, v in pairs(playerMonsters) do
		v.curHp = v.maxHp
	end
end

function HealingMachineInvis:onInteract()
	if #playerMonsters > 0 then
		fullyRestoreMonsters()
		playerRetreatMap = currentMap
		addScript(TextScript(self.pretext))
		addScript(TextScript("Bwee-oop! Your team has been healed."))
		addScript(TextScript(self.posttext))
		nextScript()
	else
		addScript(TextScript("And this is where I'd heal my Kenemon... if I HAD any!!!"))
		nextScript()
	end
end