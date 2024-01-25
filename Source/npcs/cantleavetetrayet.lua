class('CantLeaveTetraYet').extends(Person)

function CantLeaveTetraYet:init(x, y)
	CantLeaveTetraYet.super.init(self, "musicnote", x, y, 0)
end

function CantLeaveTetraYet:onInteract()
	if playerFlag == 4 then
		addScript(TextScript("Trying to get through Sorlim Forest?"))
		addScript(TextScript("Sorry, but no can do. We can't let anyone pass until we find Terrence."))
		addScript(TextScript("Who's Terrence? He's the innkeeper's son. She last saw him heading into that... desert."))
		addScript(TextScript("Which no one's supposed to enter, either! It's blocked off for \"Kenemon research\"... whatever that is."))
		playerFlag = 5
		nextScript()
	elseif playerFlag == 5 then
		addScript(TextScript("Sorry, I still can't let you through Sorlim Forest until we find Terrence."))
		addScript(TextScript("Go talk to the innkeep if you don't like it. I'm not in charge!"))
		nextScript()
	else
		addScript(TextScript("Thanks for helping us out. Best of luck on... uh... whatever it is you're doing."))
		nextScript()
	end
end

function CantLeaveTetraYet:onPlayerEndMove()
	if playerFlag >=4 and playerFlag <= 5 then
		if playerX == self.posX and playerY > self.posY and playerY <= self.posY + 5 then
			if playerY > self.posY + 1 then
				for i=1, playerY - (self.posY + 1) do
					addScript(MoveNPCScript(self, 0, 1))
				end
			end
			self:onInteract()
			addScript(MovePlayerScript(-1, 0))
			if playerY > self.posY + 1 then
				for i=0, playerY - (self.posY + 1) do
					addScript(MoveNPCScript(self, 0, -1))
				end
			end
		end
	end
end