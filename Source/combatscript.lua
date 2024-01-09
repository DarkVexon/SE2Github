class('CombatScript').extends(GameScript)

function CombatScript:init(combatID)
	CombatScript.super.init(self)
	self.combatID = combatID
end

function CombatScript:execute()
	fadeOutTimer = 15
	fadeDest = 4
	curCombat = self.combatID
end