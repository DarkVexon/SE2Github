class('TextScript').extends(GameScript)

function TextScript:init(text)
	TextScript.super.init(self)
	self.text = text
end

function TextScript:execute()
	showTextBox(self.text)
end