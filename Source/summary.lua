local singleViewImgDrawX <const> = 10
local singleViewImgDrawY <const> = 10

local singleViewNameDrawX <const> = 125
local singleViewNameDrawY <const> = 10

local singleViewLevelDrawX <const> = 125
local singleViewLevelDrawY <const> = 30

local singleViewLevelBarDrawX <const> = 175
local singleViewLevelBarDrawY <const> = 32
local singleViewLevelBarWidth <const> = 60
local singleViewLevelBarHeight <const> = 12

local singleViewHealthDrawX <const> = 125
local singleViewHealthDrawY <const> = 50
local singleViewHealthBarWidth <const> = 80
local singleViewHealthBarHeight <const> = 12

local singleViewTypesDrawX <const> = 245
local singleViewTypesDrawY <const> = 35

local singleViewStatsDrawX <const> = 10
local singleViewStatsDrawY <const> = 125
local singleViewSpaceBetweenStatsVert <const> = 25

local singleViewNatureDrawX <const> = 245
local singleViewNatureDrawY <const> = 65

local singleViewMarkDrawX <const> = 125
singleViewMarkImgWidth = 60
singleViewMarkDistBetweenImgAndExplanation = 5
local singleViewMarkDrawY <const> = 90

local singleViewAbilityDrawX <const> = 90
local singleViewAbilityDrawY <const> = 115
local singleViewAbilityBoxWidth <const> = 400 - singleViewAbilityDrawX - GLOBAL_BEZEL
local singleViewAbilityBoxHeight <const> = 40

local singleViewMovesDrawX <const> = 95
local singleViewMovesDrawY <const> = 155

local singleViewSingleMoveWidth <const> = 275
local singleViewSingleMoveHeight <const> = 30
local singleViewSingleMoveDistBetween <const> = 5

local singleViewScreenEndScrollAmt <const> = 60

singleViewScrollAmt = 0

function openSingleMonsterView()
	curScreen = 2
	monsterSingleViewSelection = 1
	singleViewScrollAmt = 0
end

function drawSingleMonsterViewMove(x, y, move)
	drawNiceRect(x, y, singleViewSingleMoveWidth, singleViewSingleMoveHeight)
	if move ~= nil then
		renderType(move.type, x + 3, y + 3)
		gfx.drawText(move.name, x + 10 + 70, y + 7)
		if move.basePower ~= nil then
			gfx.drawText(move.basePower, x + 230, y + 7)
		else
			gfx.drawText("N/A", x + 230, y + 7)
		end
	end
end

function drawSingleMonsterView()
	singleViewMonster.img:draw(singleViewImgDrawX, singleViewImgDrawY)
	local nameDisplay = singleViewMonster.name
	if singleViewMonster.name ~= singleViewMonster.speciesName then
		nameDisplay = nameDisplay .. " (" .. singleViewMonster.speciesName .. ")"
	end
	gfx.drawText(nameDisplay, singleViewNameDrawX, singleViewNameDrawY)
	gfx.drawText("LV. " .. singleViewMonster.level, singleViewLevelDrawX, singleViewLevelDrawY)
	drawBar(singleViewLevelBarDrawX, singleViewLevelBarDrawY, singleViewLevelBarWidth, singleViewLevelBarHeight, singleViewMonster.exp - xpNeededForLevel(monsterInfo[singleViewMonster.speciesName]["lvlspeed"], singleViewMonster.level), xpNeededForLevel(monsterInfo[singleViewMonster.speciesName]["lvlspeed"], singleViewMonster.level+1) - xpNeededForLevel(monsterInfo[singleViewMonster.speciesName]["lvlspeed"], singleViewMonster.level))
	drawHealthBar(singleViewHealthDrawX, singleViewHealthDrawY, singleViewHealthBarWidth, singleViewHealthBarHeight, singleViewMonster.curHp, singleViewMonster.maxHp)
	renderTypesHoriz(singleViewMonster.types, singleViewTypesDrawX, singleViewTypesDrawY)

	gfx.drawText("ATK: " .. singleViewMonster.attack, singleViewStatsDrawX, singleViewStatsDrawY)
	gfx.drawText("DEF: " .. singleViewMonster.defense, singleViewStatsDrawX, singleViewStatsDrawY + (singleViewSpaceBetweenStatsVert))
	gfx.drawText("SPD: " .. singleViewMonster.speed, singleViewStatsDrawX, singleViewStatsDrawY + (singleViewSpaceBetweenStatsVert*2))

	gfx.drawText("Acts " .. string.lower(singleViewMonster.nature) .. ".", singleViewNatureDrawX, singleViewNatureDrawY)

	if singleViewMonster.mark ~= nil then
		singleViewMonster.mark.img:draw(singleViewMarkDrawX, singleViewMarkDrawY)
		gfx.drawText(singleViewMonster.mark.name .. ": " .. singleViewMonster.mark.description, singleViewMarkDrawX + singleViewMarkImgWidth + singleViewMarkDistBetweenImgAndExplanation, singleViewMarkDrawY)
	end
	
	gfx.drawTextInRect(singleViewMonster.ability.name .. ": " .. singleViewMonster.ability.description, singleViewAbilityDrawX, singleViewAbilityDrawY, singleViewAbilityBoxWidth, singleViewAbilityBoxHeight)

	for i=1, 4 do
		drawSingleMonsterViewMove(singleViewMovesDrawX, singleViewMovesDrawY + ((i-1)*singleViewSingleMoveHeight + (i-1) * singleViewSingleMoveDistBetween), singleViewMonster.moves[i])
	end

	drawBackButton()
end

function updateSingleMonsterViewMenu()
	local change, accel = playdate.getCrankChange()
	if change ~= 0 then
		singleViewScrollAmt += change
		if singleViewScrollAmt < 0 then
			singleViewScrollAmt = 0
		end
		if singleViewScrollAmt > singleViewScreenEndScrollAmt then
			singleViewScrollAmt = singleViewScreenEndScrollAmt
		end
		gfx.setDrawOffset(0, -singleViewScrollAmt)
	end
	if playdate.buttonJustPressed(playdate.kButtonB) then
		gfx.setDrawOffset(0, 0)
		skipNextRender = true
		startFade(openMonsterScreen)
	end
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		monsterScreenSelectionIdx -= 1
		if monsterScreenSelectionIdx < 1 then
			monsterScreenSelectionIdx = #playerMonsters
		end
		singleViewMonster = playerMonsters[monsterScreenSelectionIdx]
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		monsterScreenSelectionIdx += 1
		if monsterScreenSelectionIdx > #playerMonsters then
			monsterScreenSelectionIdx = 1
		end
		singleViewMonster = playerMonsters[monsterScreenSelectionIdx]
	end
end