class('TextScript').extends(GameScript)

function TextScript:init(text)
	self.text = text
end

function TextScript:execute()
	showTextBox(self.text)
end