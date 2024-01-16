class('MoveNPCScript').extends(Script)

function MoveNPCScript:init(npc, xMove, yMove)
	MoveNPCScript.super.init(self, "Move " .. npc.name)
	self.npc = npc
	self.xMove = xMove
	self.yMove = yMove
end

function MoveNPCScript:execute()
	self.npc.callScriptAfterMove = true
	if self.xMove == -1 then
		self.npc:attemptMoveLeft()
	elseif self.xMove == 1 then
		self.npc:attemptMoveRight()
	elseif self.yMove == -1 then
		self.npc:attemptMoveUp()
	else
		self.npc:attemptMoveDown()
	end
end