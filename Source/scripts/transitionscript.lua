class('TransitionScript').extends(Script)

function TransitionScript:init(func)
	TransitionScript.super.init(self, "Screen fade out")
	self.func = func
end

function TransitionScript:execute()
	startFade(self.func)
end