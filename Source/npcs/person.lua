class('Person').extends(Object)

function Person:init(name, x, y, text)
	Person.super.init(self, name, x, y)
	self.facing = 1
end