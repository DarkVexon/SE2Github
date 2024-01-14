class('CaptureCube').extends(Item)

function CaptureCube:init()
	CaptureCube.super.init(self, "Capture Cube")
end

function CaptureCube:canUse()
	if isTrainerBattle then
		return false
	else
		return CaptureCube.super.canUse(self)
	end
end

function CaptureCube:use()
	self:displaySelf(playerName)
	-- TODO: Cool anim
	attemptToCapture(enemyMonster)
end

function attemptToCapture(target)
	local output = monsterInfo[target.species]["catchDifficulty"]
	output *= (((target.maxHp - target.curHp) / target.maxHp) + 0.1)
	-- TODO: Persistent statuses modify catch rate
	if playerDex[target.species] == 2 then
		output *= 1.1
	end
	output = math.floor(output)
	local foundValue = math.random(1, 100)
	if foundValue >= output then
		caughtMonster = target
		if (playerDex[caughtMonster.speciesName]) < 2 then
			playerDex[caughtMonster.speciesName] = 2
		end
		addScript(TextScript("Capture was successful!"))
		if playerDex[target.species] ~= 2 then
			playerDex[target.species] = 2
			dexSelectedSpecies = target.species
			dexFromCapture = true
			addScript(TextScript(target.name .. "'s information was added to the Monsterpedia."))
			addScript(TransitionScript(openPostCaptureScreen))
		else
			addScript(TransitionScript(openPostCaptureScreen))
		end
	else
		addScript(TextScript("Capture failed! Darn."))
	end
end