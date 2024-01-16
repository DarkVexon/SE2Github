class('SpringSpout').extends(Ability)

function SpringSpout:init(owner)
	SpringSpout.super.init(self, "Spring Spout", owner)
end

function SpringSpout:atEndOfTurn()
	self:displaySelf()
	addScript(TextScript(self.owner:messageBoxName() .. " healed their party!"))
	addScript(HealingScript(self.owner.maxHp * 0.05, self.owner))
	if self.owner:isFriendly() then
		addScript(LambdaScript("heal all ally", function () 
			for k, v in pairs(playerMonsters) do
				if v ~= playerMonster then
					v.curHp = math.min(v.maxHp, v.curHp + v.maxHp * 0.05)
				end
			end
			nextScript()
		end))
	else
		addScript(LambdaScript("heal all ally", function () 
			for k, v in pairs(enemyMonsters) do
				if v ~= enemyMonster then
					v.curHp = math.min(v.maxHp, v.curHp + v.maxHp * 0.05)
				end
			end
			nextScript()
		end))
	end
end