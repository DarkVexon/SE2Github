function contains(table, item)
	for i,v in ipairs(table) do
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

function drawNiceRect(x, y, width, height)
	gfx.drawRoundRect(x, y, width, height, boxOutlineSize)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRoundRect(x + (boxOutlineSize/2), y + (boxOutlineSize/2), width - boxOutlineSize, height - boxOutlineSize, boxOutlineSize)
	gfx.setColor(gfx.kColorBlack)
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