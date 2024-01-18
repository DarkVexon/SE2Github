class('UpsideDown').extends(Ability)

function UpsideDown:init(owner)
	Crybaby.super.init(self, "UpsideDown", owner)
	self.shouldActivate = true
end

local invertedStatii <const> = {"Defense Down", "Defense Up", "Attack Down", "Attack Up", "Speed Down", "Speed Up"}

function UpsideDown:receiveStatusApplied(incomingStatus)
	if contains(invertedStatii, incomingStatus.name) and self.shouldActivate then
		self:displaySelf()
		self.owner:removeStatus(incomingStatus)
		self.shouldActivate = false
		if incomingStatus.name == "Defense Down" then
			addScript(TextScript("DEF was raised instead!"))
			addScript(ApplyStatusScript(self.owner, DefenseUp(self.owner)))
		elseif incomingStatus.name == "Defense Up" then
			addScript(TextScript("DEF was lowered instead!"))
			addScript(ApplyStatusScript(self.owner, DefenseDown(self.owner)))
		elseif incomingStatus.name == "Attack Down" then
			addScript(TextScript("ATK was raised instead!"))
			addScript(ApplyStatusScript(self.owner, AttackUp(self.owner)))
		elseif incomingStatus.name == "Attack Up" then
			addScript(TextScript("ATK was lowered instead!"))
			addScript(ApplyStatusScript(self.owner, AttackDown(self.owner)))
		elseif incomingStatus.name == "Speed Down" then
			addScript(TextScript("SPD was raised instead!"))
			addScript(ApplyStatusScript(self.owner, SpeedUp(self.owner)))
		elseif incomingStatus.name == "Speed Up" then
			addScript(TextScript("SPD was lowered instead!"))
			addScript(ApplyStatusScript(self.owner, SpeedDown(self.owner)))
		end
		addScript(LambdaScript("re-enable upside down", function() self.shouldActivate = true nextScript() end))
	end
end