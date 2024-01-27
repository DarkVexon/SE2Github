class('WandWaver').extends(Ability)

local WAND_WAVER_POS_X_PLAYER <const> = 120
local WAND_WAVER_POS_Y_PLAYER <const> = 10
local WAND_WAVER_POS_X_ENEMY <const> = 250
local WAND_WAVER_POS_Y_ENEMY <const> = 10
local WAND_WAVER_WIDTH <const> = 15
local WAND_WAVER_HEIGHT <const> = 50

local WAND_WAVER_IMG <const> = gfx.image.new("img/ui/star")

function WandWaver:init(owner)
	WandWaver.super.init(self, "Wand Waver", owner)
end

function WandWaver:onEnterCombat()
	self.charge = 0
end

function WandWaver:onUseMove(move, target)
	if move.basePower == nil and not isCombatEnding then
		addScript(LambdaScript("Charge up wand waver", function ()
			self.charge += 1
			if self.charge == 2 then
				self:displaySelf()
				addScript(CalculatedDamageScript(self.owner, 40, "magic", self.owner:getFoe()))
				self.charge = 0
			else
				addScript(TextScript(self.owner:messageBoxName() .. " 's " .. self.name .. " is charging up!"))
			end
			nextScript()
		end))
	end
end

function WandWaver:render()
	if self.owner:isFriendly() then
		WAND_WAVER_IMG:draw(WAND_WAVER_POS_X_PLAYER - 3, WAND_WAVER_POS_Y_PLAYER - 3)
		drawNiceRect(WAND_WAVER_POS_X_PLAYER, WAND_WAVER_POS_Y_PLAYER + 20, WAND_WAVER_WIDTH, WAND_WAVER_HEIGHT)
		if self.charge == 1 then
			gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
			gfx.fillRoundRect(WAND_WAVER_POS_X_PLAYER + (BOX_OUTLINE_SIZE/2), WAND_WAVER_POS_Y_PLAYER + 20 + (WAND_WAVER_HEIGHT/2) + (BOX_OUTLINE_SIZE/2), WAND_WAVER_WIDTH, WAND_WAVER_HEIGHT / 2, BOX_OUTLINE_SIZE)
			gfx.setColor(gfx.kColorBlack)
		end
	else
		WAND_WAVER_IMG:draw(WAND_WAVER_POS_X_ENEMY - 3, WAND_WAVER_POS_Y_PLAYER - 3)
		drawNiceRect(WAND_WAVER_POS_X_ENEMY, WAND_WAVER_POS_Y_PLAYER + 20, WAND_WAVER_WIDTH, WAND_WAVER_HEIGHT)
		if self.charge == 1 then
			gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
			gfx.fillRoundRect(WAND_WAVER_POS_X_ENEMY + (BOX_OUTLINE_SIZE/2), WAND_WAVER_POS_Y_PLAYER + 20 + (WAND_WAVER_HEIGHT/2) + (BOX_OUTLINE_SIZE/2), WAND_WAVER_WIDTH, WAND_WAVER_HEIGHT / 2, BOX_OUTLINE_SIZE)
			gfx.setColor(gfx.kColorBlack)
		end
	end
end