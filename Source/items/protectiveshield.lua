class('ProtectiveShield').extends(EquippableItem)

function ProtectiveShield:init()
	ProtectiveShield.super.init(self, "Protective Shield")
end

function ProtectiveShield:atBattleStart()
	self.used = false
end

function ProtectiveShield:receiveTypeMatchupOutcome(outcome)
	if outcome == 2 and not self.used then
		self.used = true
		self:displaySelf()
		addScript(TextScript("The super-effective move dealt normal damage instead!"))
		return 1
	end
end