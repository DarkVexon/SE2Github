class('ApplyStatusScript').extends(GameScript)

function ApplyStatusScript:init(target, status)
	self.target = target
	self.status = status
end

function ApplyStatusScript:execute()
	table.insert(self.target.statuses, self.status)
	nextScript()
end