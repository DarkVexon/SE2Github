class('Rejuvenation').extends(Ability)

function Rejuvenation:init(owner)
	Rejuvenation.super.init(self, "Rejuvenation", owner)
end

function Rejuvenation:atEndOfTurn()
	local debuffs = {}
	for k, v in self.owner.statuses do
		if v.type == 0 then
			table.insert(debuffs, v)
		end
	end
	if #debuffs>0 then
		local result = debuffs[math.random(#debuffs)]
		self:displaySelf()
		addScript(TextScript(result.name .. " was removed!"))
		addScript(RemoveStatusScript(result))
	end
end