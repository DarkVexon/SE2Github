local SHOP_IMG_WIDTH <const> = 130
local SHOP_IMG_HEIGHT <const> = 200

local SHOP_GUY_POS_X <const> = 0
local SHOP_GUY_POS_Y <const> = 240 - SHOP_IMG_HEIGHT

local SHOP_HELD_POS_X <const> = 10
local SHOP_HELD_POS_Y <const> = 10
local SHOP_HELD_WIDTH <const> = 125
local SHOP_HELD_HEIGHT <const> = 25

local SHOP_MENU_POS_X <const> = 160
local SHOP_MENU_POS_Y <const> = 5
local SHOP_MENU_WIDTH <const> = 400 - SHOP_MENU_POS_X - 5
local SHOP_MENU_HEIGHT <const> = 230
local SHOP_MENU_ITEM_X <const> = SHOP_MENU_POS_X + 5
local SHOP_MENU_ITEM_START_Y <const> = SHOP_MENU_POS_Y + 5
local SHOP_MENU_DIST_BETWEEN <const> = 30
local SHOP_MENU_PRICE_X <const> = SHOP_MENU_POS_X + SHOP_MENU_WIDTH - 50
local SHOP_MENU_DESC_START_Y <const> = SHOP_MENU_POS_Y + 180
local SHOP_MENU_DESC_HEIGHT <const> = SHOP_MENU_HEIGHT - SHOP_MENU_DESC_START_Y

local SHOPKEEPER_IMG <const> = gfx.image.new("img/ui/shopkeeper")

function openNextShop()
	shopMenuSelectedIdx = 1
	curQty = 1
	shopItemIsSelected = false
	curScreen = 10
end

function openShop(items)
	shopItems = items
	openNextShop()
end

function updateShop()
	if shopItemIsSelected then
		if playdate.buttonJustPressed(playdate.kButtonLeft) then
			menuClicky()
			curQty -= 1
			if curQty == 0 then
				curQty = math.floor(playerMoney / valueAtIndex(shopItems, shopMenuSelectedIdx))
			end
		elseif playdate.buttonJustPressed(playdate.kButtonRight) then
			menuClicky()
			curQty += 1
			if curQty > math.floor(playerMoney / valueAtIndex(shopItems, shopMenuSelectedIdx)) then
				curQty = 1
			end
		elseif playdate.buttonJustPressed(playdate.kButtonB) then
			shopItemIsSelected = false
		elseif playdate.buttonJustPressed(playdate.kButtonA) then
			menuClicky()
			playerMoney -= math.floor(valueAtIndex(shopItems, shopMenuSelectedIdx) * curQty)
			if playerItems[keyAtIndex(shopItems, shopMenuSelectedIdx)] == nil then
				playerItems[keyAtIndex(shopItems, shopMenuSelectedIdx)] = curQty
			else
				playerItems[keyAtIndex(shopItems, shopMenuSelectedIdx)] += curQty
			end
			shopItemIsSelected = false
			curQty = 1
		end
	else
		if playdate.buttonJustPressed(playdate.kButtonUp) then
			menuClicky()
			shopMenuSelectedIdx -= 1
			if shopMenuSelectedIdx == 0 then
				shopMenuSelectedIdx = numKeys(shopItems)
			end
		elseif playdate.buttonJustPressed(playdate.kButtonDown) then
			menuClicky()
			shopMenuSelectedIdx += 1
			if shopMenuSelectedIdx > numKeys(shopItems) then
				shopMenuSelectedIdx = 1
			end
		elseif playdate.buttonJustPressed(playdate.kButtonB) then
			startFade(openMainScreen)
		elseif playdate.buttonJustPressed(playdate.kButtonA) then
			menuClicky()
			shopItemIsSelected = true
			curQty = 1
		end
	end
end

function drawShopRow(y, item, price)
	gfx.drawText(item, SHOP_MENU_ITEM_X, y)
	gfx.drawText(price, SHOP_MENU_PRICE_X, y)
end

function drawShop()
	SHOPKEEPER_IMG:draw(SHOP_GUY_POS_X, SHOP_GUY_POS_Y)

	drawNiceRect(SHOP_HELD_POS_X, SHOP_HELD_POS_Y, SHOP_HELD_WIDTH, SHOP_HELD_HEIGHT)
	gfx.drawText("$" .. playerMoney, SHOP_HELD_POS_X + 4, SHOP_HELD_POS_Y + 4)

	drawNiceRect(SHOP_MENU_POS_X, SHOP_MENU_POS_Y, SHOP_MENU_WIDTH, SHOP_MENU_HEIGHT)

	local index = 0
	for k, v in pairs(shopItems) do
		local posY = SHOP_MENU_ITEM_START_Y + SHOP_MENU_DIST_BETWEEN * index
		drawShopRow(posY, k, v)
		if index == shopMenuSelectedIdx-1 then
			gfx.setColor(gfx.kColorXOR)
			gfx.fillRoundRect(SHOP_MENU_ITEM_X - 2, posY - 2, SHOP_MENU_WIDTH - 6, 20, 2)
			gfx.setColor(gfx.kColorBlack)
			if shopItemIsSelected then
				drawNiceRect(SHOP_HELD_POS_X + 75, posY + 20, 75, 20)
				leftFacingTriangle(SHOP_HELD_POS_X + 90, posY + 25, 12)
				gfx.drawText(curQty .. "", SHOP_HELD_POS_X + 105, posY + 22)
				rightFacingTriangle(SHOP_HELD_POS_X + 130, posY + 25, 12)
			end
		end
		index += 1
	end

	drawNiceRect(SHOP_MENU_POS_X, SHOP_MENU_DESC_START_Y, SHOP_MENU_WIDTH, SHOP_MENU_DESC_HEIGHT+5)
	local item = getItemByName(keyAtIndex(shopItems, shopMenuSelectedIdx))
	gfx.drawTextInRect(item.name .. ": " .. item.description, SHOP_MENU_POS_X + 3, SHOP_MENU_DESC_START_Y + 2, SHOP_MENU_WIDTH - 6, SHOP_MENU_DESC_HEIGHT - 4)

	drawBackButton()
end