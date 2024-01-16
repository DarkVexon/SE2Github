class('ApplyStatusScript').extends(Script)

function ApplyStatusScript:init(target, status)
	ApplyStatusScript.super.init(self, "Apply " .. status.name .. " to " .. target.name)
	self.target = target
	self.status = status
end

function ApplyStatusScript:execute()
	table.insert(self.target.statuses, self.status)
	self.target.ability:receiveStatusApplied(self.status)
	nextScript()
end