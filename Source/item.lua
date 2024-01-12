class('Item').extends()

itemInfo = json.decodeFile("data/items.json")

function Item:init(name)
	local data = itemInfo[name]
	self.id = name
	self.name = data["itemName"]
	self.description = data["description"]
	self.canUseFromBag = data["canUseFromBag"]
	self.canUseInBattle = data["canUseInBattle"]
	self.isKey = data["isKey"]
	self.useOnce = data["useOnce"]
end

function Item:canUse()
	if curScreen == 3 then
		if self.canUseInBattle then
			return true
		else
			return false
		end
	else
		if self.canUseFromBag then
			return true
		else
			return false
		end
	end
end

function Item:use()

end

function Item:displaySelf(user)
	addScript(TextScript(user .. " used " .. self.name .. "!"))
end

function Item:consumeOne()
	playerItems[self] -= 1
	if playerItems[self] == 0 then
		playerItems[self] = nil
	end
end

-- IMPORTS
import "items/poutine"
import "items/capturecube"

function getItemByName(name)

end