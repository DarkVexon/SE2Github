class('ApplyTeamStatusScript').extends(Script)

function ApplyTeamStatusScript:init(isPlayerTeam, status)
	ApplyTeamStatusScript.super.init(self, "Apply party " .. status.name)
	self.isPlayer = isPlayerTeam
	self.status = status
end

function ApplyTeamStatusScript:execute()
	if self.isPlayer then
		table.insert(playerTeamStatuses, self.status)
	else
		table.insert(enemyTeamStatuses, self.status)
	end
	nextScript()
end