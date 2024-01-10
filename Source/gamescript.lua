class('GameScript').extends()

function GameScript:init(func)
	self.func = func
end

function GameScript:execute()
	self.func()
end

-- SCRIPTS