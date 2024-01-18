class('ThrowCubeAnim').extends(Animation)

local CUBE_START_X <const> = -33
local CUBE_START_Y <const> = 180
local CUBE_INIT_SPEED_X <const> = 6
local CUBE_INIT_SPEED_Y <const> = -10
local CUBE_Y_DRAG <const> = 0.4
local CUBE_STOPAT_X <const> = 195
local CUBE_WAITAT_STOPAT <const> = 30
local CUBE_SUCK_DISTX <const> = 200
local CUBE_SUCK_DISTY <const> = 105
local CUBE_SUCKIN_TIME <const> = 40
local CUBE_SUCK_MIN_SIZE <const> = 0
local CUBE_DROP_SPEED <const> = -4
local CUBE_DROP_Y <const> = 150
local CUBE_SWIRL_TIME <const> = 40

function ThrowCubeAnim:init(numSparks)
	ThrowCubeAnim.super.init(self)
	self.posX = CUBE_START_X
	self.posY = CUBE_START_Y
	self.speedX = CUBE_INIT_SPEED_X
	self.speedY = CUBE_INIT_SPEED_Y
	self.phaseTimer = 0
	self.phase = 0
	self.numSparks = numSparks
end

function ThrowCubeAnim:update()
	if self.phase == 0 then
		self.posX += self.speedX
		self.posY += self.speedY
		self.speedY += CUBE_Y_DRAG
		if self.posX >= CUBE_STOPAT_X then
			self.renderBehind = true
			self.phaseTimer = CUBE_WAITAT_STOPAT
			self.phase = 1
		end
	elseif self.phase == 1 then
		self.phaseTimer -= 1
		if self.phaseTimer == 0 then
			self.phase = 2
			self.phaseTimer = CUBE_SUCKIN_TIME
		end
	elseif self.phase == 2 then
		self.phaseTimer -= 1
		enemyMonsterPosX = playdate.math.lerp(enemyMonsterEndX, self.posX + 5, timeLeft(self.phaseTimer, CUBE_SUCKIN_TIME))
		enemyMonsterDrawScale = playdate.math.lerp(1.0, CUBE_SUCK_MIN_SIZE, timeLeft(self.phaseTimer, CUBE_SUCKIN_TIME))
		if self.phaseTimer == 0 then
			self.renderBehind = false
			self.speedY = CUBE_DROP_SPEED
			self.phase = 3
		end
	elseif self.phase == 3 then
		self.posY += self.speedY
		self.speedY += CUBE_Y_DRAG * 1.5
		if self.posY >= CUBE_DROP_Y then
			if self.numSparks > 0 then
				self.numSparks -= 1
				self.phase = 4
				self.phaseTimer = CUBE_SWIRL_TIME
			end
		end
	elseif self.phase == 4 then
		self.phaseTimer -= 1
		if self.phaseTimer == 0 then
			self.phaseTimer = CUBE_SWIRL_TIME
		end
	end
end

function ThrowCubeAnim:render()
	if self.phase == 1 then
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillTriangle(self.posX, self.posY, self.posX + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTX, self.posY + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTY, self.posX + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTX/2, self.posY + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTY)
		gfx.setColor(gfx.kColorBlack)
	elseif self.phase == 2 then
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillTriangle(self.posX, self.posY, self.posX + CUBE_SUCK_DISTX, self.posY + CUBE_SUCK_DISTY, self.posX + CUBE_SUCK_DISTX/2, self.posY + CUBE_SUCK_DISTY)
		gfx.setColor(gfx.kColorBlack)
	end
	CAPTURE_CUBE_COMBAT_IMG:draw(self.posX, self.posY)
	if self.phase == 4 then
		for i=0, 3 do
			local destDegrees = playdate.math.lerp(0, 360, timeLeft(self.phaseTimer, CUBE_SWIRL_TIME))
			destDegrees += (360/4) * i
			destDegrees = destDegrees % 360
	        local destRads = toRadians(destDegrees)
	        local circRadius = playdate.math.lerp(fadeCircEndpoint, 0, timeLeft(self.phaseTimer, CUBE_SWIRL_TIME))
	        local destX = (circRadius) * math.cos(destRads) + self.posX
			local destY = (circRadius) * math.sin(destRads) + self.posY
			CAPTURE_CUBE_COMBAT_IMG:draw(destX, destY)
		end
	end
end