import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/math"
import "CoreLibs/keyboard"

gfx = playdate.graphics
sfx = playdate.sound

gameFont = gfx.font.new("font/coreTextFont")
smallerFont = gfx.font.new("font/coreTextSmall")
gfx.setFont(gameFont)

import "constants"
import "helpers"
import "script"
import "npc"
import "maps"
import "move"
import "monster"
import "type"
import "mark"
import "ability"
import "overworld"
import "menu"
import "transitions"
import "bag"
import "summary"
import "partyview"
import "popup"
import "backbutton"
import "textbox"
import "combat"
import "visual"
import "animation"
import "status"
import "item"
import "postcapture"
import "options"
import "dex"
import "player"
import "dexsingleview"
import "vfx"
import "storageview"

isCrankUp = false

function initialize()
	gfx.setLineWidth(LINE_WIDTH)
	loadMap("testtown", 1)
end

curScreen = 0
-- 0: main gameplay
-- 1: monster screen
-- 2: individual monster screen
-- 3: combat screen
-- 4: bag screen
-- 5: Post capture screen
-- 6: Options menu screen
-- 7: Monsterdex total screen
-- 8: Monsterdex single screen
-- 9: Monster storage view screen

skipNextRender = false

function playdate.update()
	updateNonGameplayRelated()

	if (fadeOutTimer > 0 or fadeInTimer > 0) then
		updateFade()
		renderFade()
	else
		if popupUp then
			updatePopupMenu()
		else
			if curScreen == 0 then
				updateOverworld()
			elseif curScreen == 1 then
				updatePartyViewMenu()
			elseif curScreen == 2 then
				updateSingleMonsterViewMenu()
			elseif curScreen == 3 then
				updateInCombat()
			elseif curScreen == 4 then
				updateBagViewScreen()
			elseif curScreen == 5 then
				updatePostCaptureScreen()
			elseif curScreen == 6 then
				updateOptionsMenu()
			elseif curScreen == 7 then
				updateDexMenu()
			elseif curScreen == 8 then
				updateDexSingleView()
			elseif curScreen == 9 then
				updateStorageView()
			end
		end

		if skipNextRender then
			skipNextRender = false
		else
			render()
		end
	end
end

local DEBUG_ACTION_QUEUE_X <const> = 5
local DEBUG_ACTION_QUEUE_Y <const> = 5
local DEBUG_ACTION_QUEUE_WIDTH <const> = 390
local DEBUG_ACTION_QUEUE_HEIGHT <const> = 18
local DEBUG_ACTION_QUEUE_SPACEBETWEEN <const> = 2

function drawDebugActionQueue()
	for i=1, #scriptStack do
		drawNiceRect(DEBUG_ACTION_QUEUE_X, DEBUG_ACTION_QUEUE_Y + (i-1) * (DEBUG_ACTION_QUEUE_HEIGHT + DEBUG_ACTION_QUEUE_SPACEBETWEEN), DEBUG_ACTION_QUEUE_WIDTH, DEBUG_ACTION_QUEUE_HEIGHT)
		gfx.drawText(i .. ": " .. scriptStack[i].name, DEBUG_ACTION_QUEUE_X + 1, DEBUG_ACTION_QUEUE_Y + (i-1) * (DEBUG_ACTION_QUEUE_HEIGHT + DEBUG_ACTION_QUEUE_SPACEBETWEEN) + 1)
	end
end

function render()
	gfx.clear()

	if curScreen == 0 then
		drawInOverworld()
	elseif curScreen == 1 then
		drawMonsterMenu()
	elseif curScreen == 2 then
		drawSingleMonsterView()
	elseif curScreen == 3 then
		drawInCombat()
	elseif curScreen == 4 then
		drawBagViewScreen()
	elseif curScreen == 5 then
		drawPostCaptureScreen()
	elseif curScreen == 6 then
		drawOptionsMenu()
	elseif curScreen == 7 then
		drawDexMenu()
	elseif curScreen == 8 then
		drawDexSingleView()
	elseif curScreen == 9 then
		drawStorageView()
	end

	if popupUp then
		drawPopupMenu()
	end

	if isDebug then
		drawDebugActionQueue()
		--playdate.drawFPS(5, 5)
	end
end

initialize()