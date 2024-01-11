class('UseMoveScript').extends(GameScript)

function UseMoveScript:init(attacker, move, target)
	self.attacker = attacker
	self.move = move
	self.target = target
end

function UseMoveScript:execute()
	self.attacker:useMove(move, target)
end