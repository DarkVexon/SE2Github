class('DineAndDash').extends(Move)

function DineAndDash:init()
	DineAndDash.super.init(self, "Dine and Dash")
end

function DineAndDash:use(owner, target)
	if self:checkMiss(owner, target) then
		addScript(StartAnimScript(AttackAnim(owner ~= playerMonster)))
		addScript(MoveAttackScript(owner, self, target))
	end
	addScript(LambdaScript("add swap bot", 
		function ()
			addScript(LambdaScript("swap out menu open", 
			function ()
				if not isCombatEnding and #playerMonsters > 1 then
					openLastResortMenu()
				else
					nextScript()
				end
			end
			))
			nextScript()
		end
	))
end