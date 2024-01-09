class('Signpost').extends(GameObject)

function Signpost:init(x, y, text)
	Signpost.super.init(self, "signpost", x, y)
	self.text = text
end

function Signpost:onInteract()
	table.insert(scriptStack, TextScript("hello there 1. my name is SIGNPOSTY. nice to meet you! this is a long message to test just how much text fits into the text box. ok now press a"))
	table.insert(scriptStack, TextScript("hello there 2! this is a SECOND text box"))
	nextScript()
end