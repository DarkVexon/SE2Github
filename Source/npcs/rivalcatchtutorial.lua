class('RivalCatchTutorial').extends(Person)

local DRSYTE_COMBAT_BACKSIDE <const> = gfx.image.new("img/combat/combatRival")

function RivalCatchTutorial:init(x, y)
	RivalCatchTutorial.super.init(self, "rival", x, y, 0)
end

function RivalCatchTutorial:shouldSpawn()
	return playerFlag == 3
end

function RivalCatchTutorial:onInteract()
	playerFlag = 4
	addScript(TextScript("Hey! Just catching up, huuuuhh?"))
	addScript(TextScript("That's right, Dr. Syte A., P.H.D. comma M.D..."))
	addScript(TextScript("Wow, you have't caught ANY other Kenemon yet?"))
	addScript(TextScript("Kindaaaaaa lame! I already have three registered! Here, I'll show you how with an awesome demo."))
	addScript(TextScript("Just sit back and bask in my glorious Kenemon-catching skill."))
	addScript(TextScript("First, you gottaaaa go in the grass where the Kenemon hide, duh."))
	addScript(MultiMoveScript({self}, -1, 0, true))
	addScript(MultiMoveScript({self}, -1, 0, true))
	addScript(MoveNPCScript(self, -1, 0))
	addScript(MoveNPCScript(self, -1, 0))
	local restoreParty = {}
	local restoreItems = {}
	local restoreName
	local restoreImg
	addScript(LambdaScript("setup capture tutorial", 
		function ()
			inCaptureTutorialMode = true
			tutorialTextBoxOneShown = false
			tutorialTextBoxTwoShown = false
			captureTutorialTimer = 45
			for i, v in ipairs(playerMonsters) do
				table.insert(restoreParty, v)
			end
			for i, v in ipairs(playerItems) do
				table.insert(restoreItems, v)
			end
			restoreName = playerName
			restoreImg = playerCombatImg
			clear(playerMonsters)
			playerMonsters[1] = randomEncounterMonster("Sootiwi", {6, 6})
			playerItems = {["Capture Cube"] = 1}
			playerName = "Dr. Syte, P.H.D, M.D."
			playerCombatImg = DRSYTE_COMBAT_BACKSIDE
			nextScript()
		end
	))
	addScript(TextScript("There's one!"))
	addScript(RandomEncounterScript("Bombeetl", {5, 5}))
	addRetScript(LambdaScript("end capture tutorial", 
		function ()
			inCaptureTutorialMode = false
			playerMonsters = restoreParty
			playerItems = restoreItems
			playerName = restoreName
			playerCombatImg = restoreImg
			nextScript()
		end
	))
	addRetScript(TextScript("Aaaaand that's how it's done!"))
	addRetScript(TextScript("(oh my god this Bombeetl is so cute)"))
	addRetScript(TextScript("Here, I'll give you five Capture Cubes - in the interest of mutual scientific research or something."))
	for i=1, 5 do
		addRetScript(ObtainItemScript("Capture Cube"))
	end
	addRetScript(TextScript("Okay, I'm gonna go get back to work. See yaaaa!"))
	addRetScript(MoveNPCScript(self, 0, 1))
	addRetScript(MoveNPCScript(self, 0, 1))
	addRetScript(MoveNPCScript(self, 0, 1))
	addRetScript(MoveNPCScript(self, 0, 1))
	addRetScript(MoveNPCScript(self, 0, 1))
	addRetScript(MoveNPCScript(self, 0, 1))
	addRetScript(DestroyNPCScript(self))
	nextScript()
end

function RivalCatchTutorial:onPlayerEndMove()
	if playerFlag == 3 then
		if (playerX == self.posX and playerY == self.posY - 1) or (playerY == self.posY and playerX >= self.posX and playerX <= self.posX + 4) then
			if playerX > self.posX + 1 then
				for i=1, playerX - (self.posX + 1) do
					addScript(MovePlayerScript(-1, 0))
				end
			end
			self:onInteract()
		end
	end
end