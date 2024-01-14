class('SwapMonsterScript').extends(Script)

function SwapMonsterScript:init(newMonster, isEnemy)
	SwapMonsterScript.super.init(self, "Swap out enemy=" .. isEnemy .. " monster with " .. newMonster.name)
	self.nextMon = newMonster
	self.enemySwap = isEnemy
end

function SwapMonsterScript:execute()
	sendInMonster(self.nextMon)
	if self.isEnemy then
		enemyMonster = newMonster
		enemyMonsterPosX = enemyMonsterEndX
	else
		playerMonster = newMonster
		playerMonsterPosX = PLAYER_MONSTER_X
	end
	
	nextScript()
end