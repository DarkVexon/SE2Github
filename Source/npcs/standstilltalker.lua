class('StandStillTalker').extends(Person)

function StandStillTalker:init(name, x, y, facing, talkText)
	StandStillTalker.super.init(self, name, x, y, facing)
	self.text = talkText
end

function StandStillTalker:onInteract()
	self:turnToFacePlayer()
	addScript(TextScript(self.text))
	nextScript()
end