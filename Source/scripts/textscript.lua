class('TextScript').extends(Script)

function TextScript:init(text)
	TextScript.super.init(self, "Show text: " .. text)
	self.text = text
end

function TextScript:execute()
	showTextBox(self.text)
end