class('DamagePaf').extends(VFX)

local TIME_PER_FLASH <const> = 4
local NUM_FLASHES <const> = 2

function DamagePaf:init(isEnemy)
	DamagePaf.super.init(self)
	self.isEnemy = isEnemy
	self.lifetime = TIME_PER_FLASH * NUM_FLASHES * 2
	self.timeToNext = 1
end

function DamagePaf:update()
	self.lifetime -= 1
	self.timeToNext -= 1
	if self.timeToNext == 0 then
		self.timeToNext = TIME_PER_FLASH
		if self.isEnemy then
			showEnemyMonster = not showEnemyMonster
		else
			showPlayerMonster = not showPlayerMonster
		end
	end
	if self.lifetime == 0 then
		self.isDone = true
	end
end