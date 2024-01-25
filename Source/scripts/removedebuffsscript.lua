class('RemoveDebuffsScript').extends(Script)

function RemoveDebuffsScript:init(target)
	RemoveDebuffsScript.super.init(self, "Remove " .. target.name .. "'s debuffs")
	self.target = target
end

function RemoveDebuffsScript:execute()
	for k, v in ipairs(self.target.statuses) do
		if v.type == 0 then
			addScriptTop(RemoveStatusScript(self.target, v))
		end
	end
	nextScript()
end