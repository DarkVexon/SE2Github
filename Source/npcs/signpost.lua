class('Signpost').extends(NPC)

function Signpost:init(x, y, text)
	Signpost.super.init(self, "signpost", x, y)
	self:loadImg("signpost")
	self.text = text
end

function Signpost:onInteract()
	addScript(TextScript(self.text))
	nextScript()
end