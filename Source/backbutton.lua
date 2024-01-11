globalBack = gfx.image.new("img/globalBack")

backBtnWidth, backBtnHeight = globalBack:getSize()
local globalBackX <const> = 400 - backBtnWidth - 1
local globalBackY <const> = 240 - backBtnHeight - 1

function drawBackButton()
	globalBack:drawIgnoringOffset(globalBackX, globalBackY)
end

function drawBackAt(x, y)
	globalBack:draw(x, y)
end