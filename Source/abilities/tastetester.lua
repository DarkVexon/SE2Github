class('TasteTester').extends(Ability)

function TasteTester:init(owner)
	TasteTester.super.init(self, "Taste Tester", owner)
end

function TasteTester:onDealDamage(damage, damageType)
	if damageType == 0 then
		self:displaySelf()
		addScript(HealingScript(damage * 0.2, self.owner))
	end
end