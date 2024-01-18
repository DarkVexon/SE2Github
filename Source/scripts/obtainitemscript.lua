class('ObtainItemScript').extends(Script)

function ObtainItemScript:init(itemID)
	ObtainItemScript.super.init(self, "Obtain a " .. itemID)
	self.itemID = itemID
end

function ObtainItemScript:execute()
	obtainItem(self.itemID)
	nextScript()
end