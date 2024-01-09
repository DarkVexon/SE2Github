local typeImgWidth <const> = 60
local typeImgHeight <const> = 24
local typeImgBevel <const> = 5
local typeBetweenBufferHoriz <const> = 8
local typeBetweenBufferVert <const> = 5

types = {
	["fire"] = {"plant", "tech", "ice", "bug"},
	["water"] = {"fire", "tech", "stone"},
	["plant"] = {"water", "stone"},
	["alien"] = {"alien", "tech", "dragon", "knight"},
	["tech"] = {"water", "fear", "magic", "poison", "love"},
	["fear"] = {"fear", "magic", "love"},
	["dragon"] = {"fire", "dragon", "wind"},
	["ice"] = {"water", "plant", "dragon", "wind"},
	["magic"] = {"tech", "poison", "knight"},
	["bug"] = {"plant", "magic", "poison"},
	["stone"] = {"fire", "ice", "wind", "poison", "teeth"},
	["wind"] = {"plant", "bug", "knight"},
	["poison"] = {"plant", "love", "teeth"},
	["love"] = {"alien", "fear", "ice", "knight"},
	["knight"] = {"fear", "dragon", "stone", "knight"},
	["teeth"] = {"alien", "ice", "bug", "love"}
}

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
	typeImgs[k] = generateTypeImg(k)
end

function renderType(type, x, y)
	typeImgs[type]:draw(x, y)
end

function renderTypesHoriz(types, x, y)
	for i, v in ipairs(types) do
		renderType(v, (x + ((i-1) * typeImgWidth) + ((i-1) * typeBetweenBufferHoriz)), y)
	end
end
