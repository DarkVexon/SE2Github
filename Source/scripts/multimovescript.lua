class('MultiMoveScript').extends(Script)

function MultiMoveScript:init(npcs, xMove, yMove, includePlayer)
	MultiMoveScript.super.init(self, "Multi Move")
	self.npcs = npcs
	self.xMove = xMove
	self.yMove = yMove
	self.includePlayer = includePlayer
end

function MultiMoveScript:execute()
	self.npcs[#self.npcs].callScriptAfterMove = true
	for k, v in pairs(self.npcs) do
		if self.xMove == -1 then
			v:attemptMoveLeft()
		elseif self.xMove == 1 then
			v:attemptMoveRight()
		elseif self.yMove == -1 then
			v:attemptMoveUp()
		else
			v:attemptMoveDown()
		end
	end

	if self.includePlayer then
		callScriptAfterPlayerMove = true
		if self.xMove == -1 then
			setPlayerFacing(1)
			playerMoveBy(-1, 0)
		elseif self.xMove == 1 then
			setPlayerFacing(3)
			playerMoveBy(1, 0)
		elseif self.yMove == -1 then
			setPlayerFacing(0)
			playerMoveBy(0, -1)
		else
			setPlayerFacing(2)
			playerMoveBy(0, 1)
		end
	end
end