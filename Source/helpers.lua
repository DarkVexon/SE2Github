function numKeys(test)
	local result = 0
	for k, v in pairs(test) do
		result += 1
	end
	return result
end

function contains(test, item)
	for i,v in ipairs(test) do
		if (v==item) then
			return true
		end
	end
	return false
end

function containsKey(key)
	for k, v in pairs(table) do
		if (k==key) then
			return true
		end
	end
	return false
end

function startsWith(test, start)
	return string.sub(test, 1, #start) == start
end

function getTableKeys(inputTable)
	keys = {}
	for k, v in pairs(inputTable) do
		table.insert(keys, k)
	end
	return keys
end

function randomKey(inputTable)
	local keys = getTableKeys(inputTable)
	return keys[math.random(#keys)]
end

function clear(inputTable)
	for k, v in pairs(inputTable) do
		inputTable[k] = nil
	end
end

function toRadians(degrees)
	return degrees * (math.pi/180)
end

function timeLeft(timer, total)
	return (total - timer) / total
end

function widthOfWidest(strings)
	local widest = 0
	for i, v in ipairs(strings) do
		local result = gfx.getTextSize(v)
		if result > widest then
			widest = result
		end
	end
	return widest
end

function fromRightEdge(bevel)
	return 400 - bevel*2
end

function fromBot(bevel)
	return 240 - bevel*2
end

function drawNiceRect(x, y, width, height)
	gfx.drawRoundRect(x, y, width, height, boxOutlineSize)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRoundRect(x + (boxOutlineSize/2), y + (boxOutlineSize/2), width - boxOutlineSize, height - boxOutlineSize, boxOutlineSize)
	gfx.setColor(gfx.kColorBlack)
end

function rightFacingTriangle(x, y, size)
	gfx.fillTriangle(x, y, x + size, y + size/2, x, y + size)
end

function downFacingTriangle(x, y, size)
	gfx.fillTriangle(x, y, x + size, y, x + size/2, y + size)
end

local selectionBorderFillAmt <const> = 8

function drawSelectedRect(x, y, width, height)
	gfx.drawRoundRect(x, y, width, height, boxOutlineSize)
	gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
	gfx.fillRoundRect(x + (boxOutlineSize/2), y + (boxOutlineSize/2), width - boxOutlineSize, height - boxOutlineSize, boxOutlineSize)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRoundRect(x + (boxOutlineSize/2) + selectionBorderFillAmt, y + (boxOutlineSize/2) + selectionBorderFillAmt, width - boxOutlineSize - (selectionBorderFillAmt*2), height - boxOutlineSize- (selectionBorderFillAmt*2), boxOutlineSize)
	gfx.setColor(gfx.kColorBlack)
end

local hpText <const> = gfx.imageWithText("HP:", 100, 50)
local hpTextWidth, hpTextHeight = hpText:getSize()

function drawBar(x, y, width, height, cur, max)
	gfx.fillRoundRect(x + healthBarSquish, y, width, height, healthBarSquish)
	if (cur > 0) then
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(x + (healthBarSquish/2) + healthBarSquish, y + (healthBarSquish/2), (width * playdate.math.lerp(0, 1, cur/max)) - healthBarSquish, height - healthBarSquish, healthBarSquish)
		gfx.setColor(gfx.kColorBlack)
	end
end

function drawHealthBar(x, y, width, height, health, max)
	hpText:draw(x, y)
	drawBar(x + hpTextWidth, y + hpTextHeight/6, width, height, health, max)
	gfx.drawText(health .. "/" .. max, x + hpTextWidth + healthBarSquish, y + hpTextHeight)
end