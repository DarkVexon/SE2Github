class('ShopOpener').extends(NPC)

function ShopOpener:init(x, y)
	ShopOpener.super.init(self, "shopopener", x, y)
end

function ShopOpener:onInteract()
	addScript(TextScript("Heya! Welcome to the shop."))
	shopItems = {
		["Capture Cube"] = 15,
		["Poutine"] = 20
	}
	addScript(TransitionScript(openNextShop))
	nextScript()
end