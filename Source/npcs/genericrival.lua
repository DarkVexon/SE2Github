class('GenericRival').extends(Person)

function GenericRival:init(x, y)
	GenericRival.super.init(self, "rival", x, y, 0)
end