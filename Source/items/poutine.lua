class('Poutine').extends(UseOnMonsterItem)

function Poutine:init()
	Poutine.super.init(self, "Poutine")
end

function Poutine:useInCombat()
	self:displaySelf(playerName)
	addScript(HealingScript(20, playerMonster))
	self:consumeOne()
end

function Poutine:useOutsideCombat(monster)
	monster.curHp = math.min(monster.curHp + 20, monster.maxHp)
	self:consumeOne()
end

function Poutine:canUseOnTarget(target)
	return target.curHp < target.maxHp
end