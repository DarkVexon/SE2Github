class('SpawnIntroMan').extends(NPC)

function SpawnIntroMan:init(x, y)
	SpawnIntroMan.super.init(self, "spawnintroman", x, y)
	self.width = 2
end

function SpawnIntroMan:shouldSpawn()
	return playerFlag == 1
end

function SpawnIntroMan:canMoveHere()
	return true
end

function SpawnIntroMan:onOverlap()
	if playerFlag == 1 then
		playerFlag = 2
		addScript(MovePlayerScript(0, -1, false))
		local agent = GenericRival(playerX, 5)
		addScript(SpawnNPCScript(agent))
		addScript(MoveNPCScript(agent, 1, 0))
		addScript(MoveNPCScript(agent, 0, -1))
		addScript(LambdaScript("turn agent", function () agent:setFacing(1) nextScript() end))
		addScript(TextScript("Hey, Dr. " .. playerName .. "!"))
		addScript(TextScript("It's me. Dr. Syte A., P.H.D. comma M.D..."))
		addScript(TextScript("You know, from nextdoor. Right nextdoor. As in your neighbor."))
		addScript(TextScript("I was looking at your bacterium research, by the waaaaaay. It looks okay..."))
		addScript(TextScript("Except for the part you got wrong (hehheh). Anywaaaaays"))
		addScript(TextScript("Did you get this letter?"))
		addScript(TextScript("Yeah, about 'Kenemon'. I figured something would happen with all those crazy internet videos."))
		addScript(TextScript("I was kinda hoping you wouldn't get invited, so I could rub it in your face, but whatever."))
		addScript(TextScript("Anyways, I'm gonna head over towards the SCIENCE LAB. I get first pick, okaaaaay?"))
		addScript(TextScript("Catch up whenever. Bye!"))
		if playerX == 3 then
			addScript(MoveNPCScript(agent, 0, 1))
			addScript(MoveNPCScript(agent, -1, 0))
			addScript(MoveNPCScript(agent, 0, 1))
			addScript(LambdaScript("turn agent", function () agent:setFacing(2) nextScript() end))
		else
			addScript(MoveNPCScript(agent, 0, 1))
		end
		addScript(DestroyNPCScript(agent))
		nextScript()
	end
end

function SpawnIntroMan:allowImmediateMovementAfterStep()
	return playerFlag > 1
end