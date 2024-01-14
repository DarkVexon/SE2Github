class('QueryScript').extends(Script)

function QueryScript:init(text, options, funcs)
	QueryScript.super.init(self, "Querying player: " .. text)
	self.text = text
	self.options = options
	self.funcs = funcs
end

function QueryScript:execute()
	showQueryTextBox(self.text, self.options, self.funcs)
end