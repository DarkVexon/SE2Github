class('TextScript').extends(Script)

function TextScript:init(text)
	TextScript.super.init(self, "Show text: " .. text)
	self.text = text
end

function TextScript:execute()
	local result = split(self.text, "NL")
	if #result == 1 then
		showTextBox(self.text)
	else
		showTextBox(result[1])
		for i=#result, 2, -1 do
			addScriptTop(TextScript(result[i]))
		end
	end
end