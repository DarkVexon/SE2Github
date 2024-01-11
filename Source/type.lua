local typeImgWidth <const> = 66
local typeImgHeight <const> = 22
local typeImgBevel <const> = 5
local typeBetweenBufferHoriz <const> = 8
local typeBetweenBufferVert <const> = 5

types = {
	"fire",
	"water",
	"plant",
	"alien",
	"tech",
	"fear",
	"drake",
	"ice",
	"magic",
	"bug",
	"stone",
	"wind",
	"poison",
	"love",
	"knight",
	"teeth"
}

dealsDoubleTo = {
	["fire"] = {"plant"},
	["water"] = {"fire"},
	["plant"] = {"water"},
	["alien"] = {},
	["tech"] = {},
	["fear"] = {},
	["drake"] = {},
	["ice"] = {},
	["magic"] = {},
	["bug"] = {},
	["stone"] = {},
	["wind"] = {},
	["poison"] = {},
	["love"] = {},
	["knight"] = {},
	["teeth"] = {}
}

dealsHalfTo = {
	["fire"] = {"fire", "water"},
	["water"] = {"water", "plant"},
	["plant"] = {"plant", "fire"},
	["alien"] = {},
	["tech"] = {},
	["fear"] = {},
	["drake"] = {},
	["ice"] = {},
	["magic"] = {},
	["bug"] = {},
	["stone"] = {},
	["wind"] = {},
	["poison"] = {},
	["love"] = {},
	["knight"] = {},
	["teeth"] = {}
}

dealsNoneTo = {
	["fire"] = {},
	["water"] = {},
	["plant"] = {},
	["alien"] = {},
	["tech"] = {},
	["fear"] = {},
	["drake"] = {},
	["ice"] = {},
	["magic"] = {},
	["bug"] = {},
	["stone"] = {},
	["wind"] = {},
	["poison"] = {},
	["love"] = {},
	["knight"] = {},
	["teeth"] = {}
}

function typeMatchupResult(offense, defense)
	if contains(dealsDoubleTo[offense], defense) then
		return 2
	elseif contains(dealsHalfTo[offense], defense) then
		return 0.5
	elseif contains(dealsNoneTo[offense], defense) then
		return 0
	else
		return 1
	end
end

function totalMult(offenseType, defenseTypes)
	local result = 1
	for k, v in pairs(defenseTypes) do
		result *= typeMatchupResult(offenseType, v)
	end
	return result
end

function generateTypeImg(type)
	local newImg = gfx.image.new(typeImgWidth, typeImgHeight)
	gfx.pushContext(newImg)
	gfx.fillRoundRect(0, 0, typeImgWidth, typeImgHeight, typeImgBevel)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextAligned(string.upper(type), typeImgWidth / 2, typeImgHeight/6, kTextAlignment.center)
	gfx.popContext()
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	return newImg
end

typeImgs = {}
for k, v in pairs(types) do
	typeImgs[v] = generateTypeImg(v)
end

function renderType(type, x, y)
	typeImgs[type]:draw(x, y)
end

function renderTypesHoriz(types, x, y)
	for i, v in ipairs(types) do
		renderType(v, (x + ((i-1) * typeImgWidth) + ((i-1) * typeBetweenBufferHoriz)), y)
	end
end
