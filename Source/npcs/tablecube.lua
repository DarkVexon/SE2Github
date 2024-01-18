class('Tablecube').extends(NPC)

function Tablecube:init(x, y)
	Tablecube.super.init(self, "tablecube", x, y)
	self:loadImg("tablecube")
end

function Tablecube:shouldSpawn()
	return playerFlag < 3
end

function Tablecube:canInteract()
	return playerFlag < 3
end

function Tablecube:onInteract()
	if playerFlag < 3 then
		playerFlag = 3
		caughtMonster = randomEncounterMonster(randomSpecies(), {5, 5})
		-- TODO: First monster has special mark.
		addScript(TextScript("A Capture Cube, containing a Kenermon. The KENEDAR BIOLOGY GROUP left it for you."))
		addScript(TextScript("Looks like it contains " .. monsterInfo[caughtMonster.species].article .. " ... " .. caughtMonster.name .. ". Adorable!"))
		addScript(TransitionScript(openPostCaptureScreen))
		addScript(DestroyNPCScript(self))

		local newRival = RivalFirstEncounter(4, 12)
		addRetScript(SpawnNPCScript(newRival))
		for i=1, 7 do
			addRetScript(MoveNPCScript(newRival, 0, -1))
		end
		addRetScript(TextScript("RIVAL: Hey, the Biology Group gave you a Kenemon too? Let's battle!"))
		addRetScript(TrainerBattleScript("rivalfight1"))
		addRetScript(LambdaScript("after battle", 
			function ()
				addRetScript(TextScript("RIVAL: So what if you won? I'm still going to record all the KENEMON first. See ya!"))
				for i=1, 5 do
					addRetScript(MoveNPCScript(newRival, 0, 1))
				end
				addRetScript(DestroyNPCScript(newRival))
				nextScript()
			end
		))
		
		nextScript()
	end
end