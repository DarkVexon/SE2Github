class('NoCreaturesGoBack').extends(NPC)

function NoCreaturesGoBack:init(x, y)
	NoCreaturesGoBack.super.init(self, "nocreaturesgoback", x, y)
	self.width = 4
end

function NoCreaturesGoBack:shouldSpawn()
	return playerFlag < 3
end

function NoCreaturesGoBack:canMoveHere()
	return true
end

function NoCreaturesGoBack:onOverlap()
	if #playerMonsters == 0 then
		if playerFlag == 1 then
			addScript(TextScript("You should probably check out that mysterious letter."))
		elseif playerFlag == 2 then
			addScript(TextScript("You should probably see what the DOUBLE SHADOW GOVERNMENT has for you in the SCIENCE LAB."))
		end
		addScript(LambdaScript("Move player up", function () attemptMoveUp() nextScript() end))
		nextScript()
	end
end

function NoCreaturesGoBack:allowImmediateMovementAfterStep()
	return #playerMonsters > 0
end