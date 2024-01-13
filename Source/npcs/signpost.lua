class('Signpost').extends(Object)

function Signpost:init(x, y, text)
	Signpost.super.init(self, "signpost", x, y)
	self.text = text
end

function Signpost:onInteract()
	table.insert(scriptStack, OneParamScript(textScript, self.text))
	nextScript()
end