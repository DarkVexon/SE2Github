class('NonblockingTextScript').extends(GameScript)

function NonblockingTextScript:init(text)
	self.text = text
end

function NonblockingTextScript:execute()
	showTextBox(self.text)
	callScriptAfterHideTextBox = false
end