class('TypeMasterFire').extends(Person)

function TypeMasterFire:init(x, y, facing)
	TypeMasterFire.super.init(self, "rival", x, y, facing)
end

function TypeMasterFire:onInteract()
	self:turnToFacePlayer()
	if playerFlag >= 4 and playerFlag <= 5 then
		addScript(TextScript("Mmh... these SKWIZARD taste terrible..."))
		addScript(TextScript("Huh? Hey, you don't look like a Kenemon. Are you from the city?"))
		addScript(TextScript("You say they're looking for me?"))
		addScript(TextScript("There was a terrible sandstorm. I had to eat the cacti and SKWIZARD to survive."))
		addScript(TextScript("But I learned. I learned that FIRE is the only element that can keep you safe."))
		addScript(TextScript("Roasting cactus flesh... holding the Batties at bay with its light..."))
		addScript(TextScript("Let me prove to you that FIRE is the element of survival!!"))
		addScript(TrainerBattleScript("typemasterfire1"))
		addRetScript(LambdaScript("increase flag", function () playerFlag = 6 nextScript() end))
		addRetScript(TextScript("Whew, thanks for that. OK, I think I'm ready to return to society."))
		addRetScript(TextScript("I'll head back now. See you in Tetra City!"))
		if playerY == self.posY - 1 then
			addRetScript(MoveNPCScript(self, 1, 0))
		end
		for i=1, 7 do
			addRetScript(MoveNPCScript(self, 0, -1))
		end
		addRetScript(DestroyNPCScript(self))
		nextScript()
	end
end
