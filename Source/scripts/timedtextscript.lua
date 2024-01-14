class('TimedTextScript').extends(Script)

function TimedTextScript:init(text, time)
	TimedTextScript.super.init(self, "Timed text box with text " .. text .. " and time " .. time)
	self.text = text
	self.time = time
end

function TimedTextScript:execute()
	showTimedTextBox(self.text, self.time)
end