globalBack = gfx.image.new("img/ui/globalBack")

BACK_BTN_WIDTH, BACK_BTN_HEIGHT = globalBack:getSize()
local GLOBAL_BACK_X <const> = 400 - BACK_BTN_WIDTH - 1
local GLOBAL_BACK_Y <const> = 240 - BACK_BTN_HEIGHT - 1

function drawBackButton()
	globalBack:drawIgnoringOffset(GLOBAL_BACK_X, GLOBAL_BACK_Y)
end

function drawBackAt(x, y)
	globalBack:draw(x, y)
end