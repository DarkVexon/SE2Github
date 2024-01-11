import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/math"

gfx = playdate.graphics
sfx = playdate.sound

gameFont = gfx.font.new("font/Sasser Slab/Sasser-Slab-Bold")
gfx.setFont(gameFont)

import "constants"
import "helpers"
import "gameobject"
import "gamescript"
import "npcs"
import "maps"
import "monster"
import "type"
import "monstermark"
import "ability"
import "move"
import "images"
import "overworld"
import "menu"
import "transitions"

isCrankUp = false

-- VARIABLES THAT ALWAYS IMPORTANT
playerMonsters = {randomEncounterMonster("Palpillar"), randomEncounterMonster("Dubldraker")}
playerItems = {}

-- 1: Map
-- 2: Monsters Screen
-- 3: Individual Monster Screen
-- 4: Combat Screen

scriptStack = {}

function nextScript()
	if #scriptStack == 0 then
		if curScreen == 3 then
			getNextCombatActions()
		end
	else
		local nextFound = table.remove(scriptStack, 1)
		nextFound:execute()
	end
end

function getNextCombatActions()
	if movesExecuting then
		movesExecuting = false
	end
end

function initialize()
	gfx.setLINE_WIDTH(LINE_WIDTH)
	loadMap("testtown", 1)
end


curScreen = 0
-- 0: main gameplay
-- 1: monster screen
-- 2: individual monster screen
-- 3: combat screen
-- 4: bag screen

bobTime = 0

skipNextRender = false

function updateNonGameplayRelated()
	bobTime += 0.15
end

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