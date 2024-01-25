class('MovePlayerScript').extends(Script)

function MovePlayerScript:init(xMove, yMove)
	MovePlayerScript.super.init(self, "Move player")
	self.xMove = xMove
	self.yMove = yMove
end

function MovePlayerScript:execute()
	callScriptAfterPlayerMove = true
	if self.xMove == -1 then
		setPlayerFacing(3)
		attemptMoveLeft()
	elseif self.xMove == 1 then
		setPlayerFacing(1)
		attemptMoveRight()
	elseif self.yMove == -1 then
		setPlayerFacing(0)
		attemptMoveUp()
	else
		setPlayerFacing(2)
		attemptMoveDown()
	end
end