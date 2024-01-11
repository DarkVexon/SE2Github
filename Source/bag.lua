local bagViewScreenEdgeBezel <const> = 5
local bagViewScreenPanelWidth <const> = 400 - bagViewScreenEdgeBezel*2
local bagViewScreenTabHeight <const> = 30
local bagViewScreenTabSelectedHeight <const> = 40
local bagViewTabIconHeight <const> = 10

normalItemTabImg = gfx.image.new("img/itemTabNormal")
keyItemTabImg = gfx.image.new("img/itemTabKey")

bagMenuChosenTab = 1
bagMenuIdx = 1

function openBag()
	curScreen = 4
	bagMenuIdx = 1
end

function drawBagViewScreen()
	drawNiceRect(bagViewScreenEdgeBezel, bagViewScreenEdgeBezel, bagViewScreenPanelWidth, fromBot(bagViewScreenEdgeBezel))

	if bagMenuChosenTab == 1 then
		drawNiceRect(bagViewScreenEdgeBezel, bagViewScreenEdgeBezel, bagViewScreenPanelWidth / 2, bagViewScreenTabSelectedHeight)
		normalItemTabImg:draw(bagViewScreenEdgeBezel + bagViewScreenPanelWidth / 4 - 30, bagViewTabIconHeight + 5)
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillRoundRect(bagViewScreenEdgeBezel + 1, bagViewScreenEdgeBezel + 1, bagViewScreenPanelWidth/2 - boxOutlineSize, bagViewScreenTabSelectedHeight - boxOutlineSize, boxOutlineSize)
		gfx.setColor(gfx.kColorBlack)
	else
		drawNiceRect(bagViewScreenEdgeBezel, bagViewScreenEdgeBezel, bagViewScreenPanelWidth / 2, bagViewScreenTabHeight)
		normalItemTabImg:draw(bagViewScreenEdgeBezel + bagViewScreenPanelWidth / 4 - 30, bagViewTabIconHeight)
	end

	if bagMenuChosenTab == 2 then
		drawNiceRect(bagViewScreenEdgeBezel + (bagViewScreenPanelWidth/2), bagViewScreenEdgeBezel, bagViewScreenPanelWidth / 2, bagViewScreenTabSelectedHeight)
		keyItemTabImg:draw(bagViewScreenEdgeBezel + bagViewScreenPanelWidth / 4 - 30 + (bagViewScreenPanelWidth/2), bagViewTabIconHeight + 5)
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillRoundRect(bagViewScreenEdgeBezel + 1 + (bagViewScreenPanelWidth/2), bagViewScreenEdgeBezel + 1, bagViewScreenPanelWidth/2 - boxOutlineSize, bagViewScreenTabSelectedHeight - boxOutlineSize, boxOutlineSize)
		gfx.setColor(gfx.kColorBlack)
	else
		drawNiceRect(bagViewScreenEdgeBezel+ (bagViewScreenPanelWidth/2), bagViewScreenEdgeBezel, bagViewScreenPanelWidth / 2, bagViewScreenTabHeight)
		keyItemTabImg:draw(bagViewScreenEdgeBezel + bagViewScreenPanelWidth / 4 - 30+ (bagViewScreenPanelWidth/2), bagViewTabIconHeight)
	end
end

function switchBagTab()
	if bagMenuChosenTab == 1 then
		bagMenuChosenTab = 2
	else
		bagMenuChosenTab = 1
	end
	bagMenuIdx = 1
end

function updateBagViewScreen()
	if playdate.buttonJustPressed(playdate.kButtonLeft) or playdate.buttonJustPressed(playdate.kButtonRight) then
		switchBagTab()
	end
	if playdate.buttonJustPressed(playdate.kButtonB ) then
		fadeOutTimer = 15
		fadeDest = 0
	end
end