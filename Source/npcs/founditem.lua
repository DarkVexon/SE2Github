class('FoundItem').extends(NPC)

function FoundItem:init(x, y, itemID, flagID)
	FoundItem.super.init(self, "founditem", x, y)
	self:loadImg("founditem")
	self.itemID = itemID
	self.flagID = flagID
end

function FoundItem:shouldSpawn()
	return not contains(playerPickedUpItems, self.flagID)
end

function FoundItem:canInteract()
	return not contains(playerPickedUpItems, self.flagID)
end

function FoundItem:onInteract()
	if not contains(playerPickedUpItems, self.flagID) then
		table.insert(playerPickedUpItems, self.flagID)
		addScript(TextScript("Found a " .. getItemByName(self.itemID).name .. "!"))
		addScript(ObtainItemScript(self.itemID))
		addScript(DestroyNPCScript(self))
		nextScript()
	end
end