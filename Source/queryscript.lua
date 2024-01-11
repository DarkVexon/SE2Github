class('QueryScript').extends(GameScript)

function QueryScript:init(text, options, funcs)
	self.text = text
	self.options = options
	self.funcs = funcs
end

function QueryScript:execute()
	showQueryTextBox(self.text, self.options, self.funcs)
end