class('CaptureCube').extends(Item)

CAPTURE_CUBE_COMBAT_IMG = gfx.image.new("img/combat/cube")

function CaptureCube:init()
	CaptureCube.super.init(self, "Capture Cube")
end

function CaptureCube:canUse()
	if isTrainerBattle then
		showTextBox("You can't throw Capture Cubes at others' Kenemon!")
		return false
	else
		return CaptureCube.super.canUse(self)
	end
end

function CaptureCube:use()
	self:displaySelf(playerName)
	local result, factors = attemptToCapture(enemyMonster)
	addScript(StartAnimScript(ThrowCubeAnim(result, factors)))
	if result == 4 then
		caughtMonster = enemyMonster
		if (playerDex[caughtMonster.species]) < 2 then
			playerDex[caughtMonster.species] = 2
		end
		addScript(TextScript("Capture was successful!"))
		if inCaptureTutorialMode then
			addScript(TransitionScript(openMainScreen))
		else
			addScript(LambdaScript("Gain exp", function()
				playerMonster:getExp(caughtMonster)
				nextScript()
			end))
			if playerDex[enemyMonster.species] ~= 2 then
				playerDex[enemyMonster.species] = 2
				addScript(TextScript(enemyMonster.name .. "'s information was added to the Monsterpedia."))
				addScript(TransitionScript(openPostCaptureScreen))
			else
				addScript(TransitionScript(openPostCaptureScreen))
			end
		end
	else
		addScript(TextScript("Capture failed! Darn."))
	end
	self:consumeOne()
end

function attemptToCapture(target)
	if inCaptureTutorialMode then
		return 4, 1
	end
	local output = monsterInfo[target.species]["catchDifficulty"]
	local factors = 1
	output *= (((target.maxHp - target.curHp) / target.maxHp) + 0.1)
	if target.curHp <= target.maxHp * 0.75 then
		factors += 1
	end
	if target.curHp <= target.maxHp * 0.25 then
		factors += 1
	end
	-- TODO: Persistent statuses modify catch rate
	if playerDex[target.species] == 2 then
		output *= 1.1
		factors += 1
	end
	output = math.floor(output)
	local foundValue = math.random(1, 100)
	if foundValue <= output then
		return 4, factors
	else
		local diff = foundValue-output
		if diff <= 20 then
			return 3, factors
		elseif diff <= 40 then
			return 2, factors
		else
			return 1, factors
		end
	end
end