class('OneParamScript').extends(GameScript)

function OneParamScript:init(func, param)
	self.func = func
	self.param = param
end

function OneParamScript:execute()
	self.func(self.param)
end

-- SCRIPTS --

function changeCombatPhaseScript(phase)
	combatIntroPhase = phase
	combatIntroAnimTimer = combatIntroAnimTimers[combatIntroPhase]
end

function textScript(text)
	showTextBox(text)
end

function combatScript(combatID) 
	fadeOutTimer = 15
	fadeDest = 4
	curCombat = combatID
end

function moveScript(moves)
	for k, v in pairs(moves) do
		if k == 0 then
			if v[1] < 0 then
				setPlayerFacing(3)
			elseif v[1] > 0 then
				setPlayerFacing(1)
			elseif v[2] < 0 then
				setPlayerFacing(2)
			elseif v[2] > 0 then
				setPlayerFacing(0)
			end
			playerMoveBy(v[1], v[2])
		else
			--TODO: Object facing
			objs[k]:moveBy(v[1], v[2])
		end
	end
end