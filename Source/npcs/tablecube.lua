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
		addScript(TextScript("A Capture Cube, containing a Kenermon. The DOUBLE SHADOW GOVERNMENT (2SG from now on) left it for you."))
		addScript(TextScript("Looks like it contains a ... " .. caughtMonster.name .. ". Adorable!"))
		addScript(TransitionScript(openPostCaptureScreen))
		addScript(DestroyNPCScript(self))

		local newRival = RivalFirstEncounter(4, 12)
		addRetScript(SpawnNPCScript(newRival))
		for i=1, 7 do
			addRetScript(MoveNPCScript(newRival, 0, -1))
		end
		addRetScript(TextScript("RIVAL: Hey, the 2SG gave you a Kenermon (KNM for short now) too? Let's battle!"))
		addRetScript(TrainerBattleScript("rivalfight1"))
		addRetScript(LambdaScript("after battle", 
			function ()
				addRetScript(TextScript("RIVAL: That was a good battle. OK, see ya."))
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