class('MotionScript').extends(GameScript)

function MotionScript:init(moves)
	TextScript.super.init(self)
	self.moves = moves
end

function MotionScript:execute()
	for k, v in pairs(self.moves) do
		if k == 0 then
			if v[1] < 0 then
				setPlayerFacing(3)
			elseif v[1] > 0 then
				setPlayerFacing(1)
			elseif v[2] < 0 then
				setPlayerFacing(2)
			elseif v[2] > 0 then
				setPlayerFacing(0)
			end
			playerMoveBy(v[1], v[2])
		else
			--TODO: Object facing
			objs[k]:moveBy(v[1], v[2])
		end
	end
end