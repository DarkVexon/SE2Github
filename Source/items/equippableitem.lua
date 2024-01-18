class('EquippableItem').extends(UseOnMonsterItem)

function EquippableItem:init(name)
	EquippableItem.super.init(self, name)
end

function EquippableItem:useInCombat()

end

function EquippableItem:useOutsideCombat(monster)
	monster.item = self
	self.owner = monster
	self:consumeOne()
	addScript(TextScript("Equipped " .. self.name .. " to " .. monster.name .. "."))
	addScript(TransitionScript(openBag))
	nextScript()
end

function EquippableItem:canUseOnTarget(monster)
	return monster.item == nil
end

function EquippableItem:use()
	invItemToUseOnMonster = self
	startFade(openMonsterScreen)
end

function EquippableItem:displaySelf()
	addScript(TextScript(self.owner:messageBoxName() .. "'s " .. self.name .. " activated!"))
end

function EquippableItem:atBattleStart()

end

function EquippableItem:receiveTypeMatchupOutcome(outcome)
	return outcome
end