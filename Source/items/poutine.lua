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
	local amtHealed = math.min(20, monster.maxHp - monster.curHp)
	monster.curHp = math.min(monster.curHp + 20, monster.maxHp)
	self:consumeOne()
	addScript(TextScript(monster.name .. " healed for " .. amtHealed .. "!"))
	addScript(TransitionScript(openBag))
	nextScript()
end

function Poutine:canUseOnTarget(target)
	return target.curHp < target.maxHp
end