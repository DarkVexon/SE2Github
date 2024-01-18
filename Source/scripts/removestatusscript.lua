class('RemoveStatusScript').extends(Script)

function RemoveStatusScript:init(target, status)
	RemoveStatusScript.super.init(self, "Remove " .. status.name .. " from " .. target.name)
	self.target = target
	self.status = status
end

function RemoveStatusScript:execute()
	self.target:removeStatus(self.status)
	nextScript()
end