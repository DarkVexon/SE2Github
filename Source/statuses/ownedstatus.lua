class('OwnedStatus').extends(Status)

function OwnedStatus:init(name, type, owner)
	OwnedStatus.super.init(self, name, type)
	self.owner = owner
end