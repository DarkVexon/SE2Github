class('MotionScript').extends(GameScript)

function MotionScript:init(moves)
	TextScript.super.init(self)
	self.moves = moves
end

function MotionScript:execute()
	for k, v in pairs(self.moves) do
		if k == 0 then
			playerMoveBy(v[1], v[2])
		else
			objs[k]:moveBy(v[1], v[2])
		end
	end
end