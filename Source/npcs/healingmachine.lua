class('HealingMachine').extends(NPC)

function HealingMachine:init(x, y)
	HealingMachine.super.init(self, "healmachine", x, y)
	self:loadImg("healmachine")
end

function fullyRestoreMonsters()
	for k, v in pairs(playerMonsters) do
		v.curHp = v.maxHp
	end
end

function HealingMachine:onInteract()
	if #playerMonsters > 0 then
		fullyRestoreMonsters()
		playerRetreatMap = currentMap
		addScript(TextScript("Bwee-oop! Your team has been healed."))
		nextScript()
	else
		addScript(TextScript("And this is where I'd heal my Kenemon... if I HAD any!!!"))
		nextScript()
	end
end