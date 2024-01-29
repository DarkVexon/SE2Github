class('TransitionScript').extends(Script)

function TransitionScript:init(func, transitionType)
	TransitionScript.super.init(self, "Screen fade out")
	self.func = func
	self.transitionType = self.transitionType
end

function TransitionScript:execute()
	startSpecificFade(self.func, self.transitionType)
end