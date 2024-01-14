class('LambdaScript').extends(Script)

function LambdaScript:init(info, func, param1, param2)
	LambdaScript.super.init(self, info)
	self.func = func
	self.param1 = param1
	self.param2 = param2
end

function LambdaScript:execute()
	self.func(param1, param2)
end