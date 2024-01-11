import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/math"

gfx = playdate.graphics
sfx = playdate.sound

gameFont = gfx.font.new("font/coreTextFont")
gfx.setFont(gameFont)

import "constants"
import "helpers"
import "script"
import "npc"
import "maps"
import "monster"
import "type"
import "mark"
import "ability"
import "move"
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
import "player"
import "animation"

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
			end
		end

		if skipNextRender then
			skipNextRender = false
		else
			render()
		end
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
	end

	if popupUp then
		drawPopupMenu()
	end
end

initialize()