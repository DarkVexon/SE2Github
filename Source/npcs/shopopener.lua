class('ShopOpener').extends(NPC)

function ShopOpener:init(x, y)
	ShopOpener.super.init(self, "shopopener", x, y)
end

function ShopOpener:onInteract()
	shopItems = {
		["Capture Cube"] = 15,
		["Poutine"] = 20
	}
	startFade(openNextShop)
end