class('StartAnimScript').extends(Script)

function StartAnimScript:init(anim)
	StartAnimScript.super.init(self, "Animation start")
	self.anim = anim
end

function StartAnimScript:execute()
	curAnim = self.anim
end