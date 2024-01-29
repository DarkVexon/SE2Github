class('TrainerBattleScript').extends(Script)

function TrainerBattleScript:init(trainerBattleID)
	TrainerBattleScript.super.init(self, "Start trainer battle of id: " .. trainerBattleID)
	self.battleID = trainerBattleID
end

function TrainerBattleScript:execute()
	startSpecificFade(beginNextCombat, 1)
	curCombat = self.battleID
end