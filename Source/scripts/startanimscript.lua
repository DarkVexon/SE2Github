class('StartAnimScript').extends(GameScript)

function StartAnimScript:init(anim)
	self.anim = anim
end

function StartAnimScript:execute()
	curAnim = self.anim
end