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
	-- TODO: Dex bonus
	output = math.floor(output)
	local foundValue = math.random(1, 100)
	if foundValue >= output then
		caughtMonster = target
		addScript(TextScript("Capture was successful!"))
		--TODO: If not seen in dex yet, dex presentation screen
		addScript(OneParamScript(screenChangeScript, openPostCaptureScreen))
	else
		addScript(textScript("Capture failed! Darn."))
	end
end