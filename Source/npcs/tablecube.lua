class('Tablecube').extends(NPC)

function Tablecube:init(x, y)
	Tablecube.super.init(self, "tablecube", x, y)
	self:loadImg("tablecube")
end

function Tablecube:shouldSpawn()
	return playerFlag == 2
end

function Tablecube:canInteract()
	return playerFlag == 2
end

function Tablecube:onInteract()
	if playerFlag == 2 then
		playerFlag = 3
		caughtMonster = randomEncounterMonster(randomSpecies(), {5, 5})
		-- TODO: First monster has special mark.
		addScript(TextScript("A Capture Cube, containing a Kenemon. The KENEDAR BIOLOGY GROUP left it for you."))
		addScript(TextScript("Looks like it contains " .. monsterInfo[caughtMonster.species].article .. " ... " .. caughtMonster.name .. ". Adorable!"))
		addScript(TransitionScript(openPostCaptureScreen))
		addScript(DestroyNPCScript(self))

		local newRival = GenericRival(4, 12)
		addRetScript(SpawnNPCScript(newRival))
		for i=1, 7 do
			addRetScript(MoveNPCScript(newRival, 0, -1))
		end
		addRetScript(LambdaScript("Turn player around", function () setPlayerFacing(2) nextScript() end))
		addRetScript(TextScript("It's me, Dr. Syte A., P.H.D. comma M.D..."))
		addRetScript(TextScript("Finaaaaally made it, huh? I already got my, uh... Kenemon."))
		addRetScript(TextScript("(Yours looks about as strong as mine but slightly weaker and less cute)"))
		addRetScript(TextScript("C'mon, I'll prove it - let's battle, so we're prepared for the real thing."))
		addRetScript(TrainerBattleScript("rivalfight1"))
		addRetScript(LambdaScript("after battle", 
			function ()
				addRetScript(TextScript("OK, so what if you won? They're offering a HUGE prize for anyone who can document all Kenemon."))
				addRetScript(TextScript("I'm leaving! I'll be waaaaaay ahead of you, so you might as well not even try."))
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