class('ChangeCombatIntroPhaseScript').extends(Script)

function ChangeCombatIntroPhaseScript:init(targetPhase)
	ChangeCombatIntroPhaseScript.super.init(self, "Change combat intro phase to " .. targetPhase)
	self.phase = targetPhase
end

function ChangeCombatIntroPhaseScript:execute()
	combatIntroPhase = self.phase
	combatIntroAnimTimer = combatIntroAnimTimers[combatIntroPhase]
end