class('Trainer').extends(Person)

function Trainer:init(name, x, y, facing, combat, textIn, textAfterFought, flagID)
	Trainer.super.init(self, name, x, y, facing)
	self.combatID = combat
	self.textIn = textIn
	self.textAfterFought = textAfterFought
	self.flagID = flagID
end

local dirs <const> = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}

function Trainer:startBattle()
	fightStarting = true
	addScript(TextScript(self.textIn))
	addScript(TrainerBattleScript(self.combatID))
	addRetScript(LambdaScript("set " .. self.name .. " fight done", function () table.insert(playerBeatenTrainers, self.flagID) nextScript() end))
	nextScript()
end

function Trainer:checkForEyeContact()
	local v = dirs[self.facing+1]
	local canContinue = true
	local distOut = 1
	while (canContinue) do
		local testXOffset = v[1] * distOut
		local testYOffset = v[2] * distOut
		local testX = self.posX + testXOffset
		local testY = self.posY + testYOffset
		if not (playerX == testX and playerY == testY) and (not self:canMoveThere(testX, testY) or testX < 0 or testX > mapWidth or testY < 0 or testY > mapWidth) then
			canContinue = false
			break
		else
			if playerX == testX and playerY == testY then
				canContinue = false
				for i=1, distOut-1 do
					addScript(MoveNPCScript(self, v[1], v[2]))
				end
				self:startBattle()
				break
			end
		end
		distOut += 1
		if distOut > 5 then 
			canContinue = false
			break
		end
	end
end

function Trainer:onInteract()
	self:turnToFacePlayer()
	if contains(playerBeatenTrainers, self.flagID) then
		addScript(TextScript(self.textAfterFought))
		nextScript()
	else
		self:startBattle()
	end
end

function Trainer:onEndMove()
	if not contains(playerBeatenTrainers, self.flagID) then
		self:checkForEyeContact()
	end
end

function Trainer:onPlayerEndMove()
	if not contains(playerBeatenTrainers, self.flagID) then
		self:checkForEyeContact()
	end
end