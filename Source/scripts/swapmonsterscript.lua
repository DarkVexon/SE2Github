class('SwapMonsterScript').extends(Script)

function SwapMonsterScript:init(newMonster, isEnemy)
	SwapMonsterScript.super.init(self, "Swap out with " .. newMonster.name)
	self.nextMon = newMonster
	self.enemySwap = isEnemy
end

function SwapMonsterScript:execute()
	sendInMonster(self.nextMon)
	if self.enemySwap then
		enemyMonster = self.nextMon
		enemyMonster.ability:onEnterCombat()
	else
		playerMonster = self.nextMon
		playerMonster.ability:onEnterCombat()
	end
	
	nextScript()
end