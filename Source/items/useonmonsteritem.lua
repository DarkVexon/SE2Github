class('UseOnMonsterItem').extends(Item)

function UseOnMonsterItem:init(name)
	UseOnMonsterItem.super.init(self, name)
end

function UseOnMonsterItem:useInCombat()

end

function UseOnMonsterItem:useOutsideCombat(monster)

end

function UseOnMonsterItem:canUseOnTarget(monster)
	return true
end

function UseOnMonsterItem:use()
	if turnExecuting then
		self:useInCombat()
	else
		invItemToUseOnMonster = self
		startFade(openMonsterScreen)
	end
end