class('ThrowCubeAnim').extends(Animation)

local CUBE_START_X <const> = -33
local CUBE_START_Y <const> = 180
local CUBE_INIT_SPEED_X <const> = 7
local CUBE_INIT_SPEED_Y <const> = -10
local CUBE_Y_DRAG <const> = 0.4
local CUBE_STOPAT_X <const> = 195
local CUBE_WAITAT_STOPAT <const> = 30
local CUBE_SUCK_DISTX <const> = 205
local CUBE_SUCK_DISTY <const> = 120
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
	self.startSparks = self.numSparks
	self.wasCaught = numSparks == 4
end

function ThrowCubeAnim:update()
	if self.phase == 0 then
		self.posX += self.speedX
		self.posY += self.speedY
		self.speedY += CUBE_Y_DRAG
		if self.posX >= CUBE_STOPAT_X then
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
		enemyMonsterPosX = playdate.math.lerp(enemyMonsterEndX, self.posX + 10, timeLeft(self.phaseTimer, CUBE_SUCKIN_TIME))
		enemyMonsterPosY = playdate.math.lerp(enemyMonsterY, self.posY + 10, timeLeft(self.phaseTimer, CUBE_SUCKIN_TIME))
		enemyMonsterDrawScale = playdate.math.lerp(1.0, CUBE_SUCK_MIN_SIZE, timeLeft(self.phaseTimer, CUBE_SUCKIN_TIME))
		if self.phaseTimer == 0 then
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
				self.speedY = -4
			end
		end
	elseif self.phase == 4 then
		if self.speedY < 0 then
			self.posY += self.speedY
			self.speedY += CUBE_Y_DRAG
		end
		self.phaseTimer -= 1
		if self.phaseTimer == 0 then
			if self.numSparks > 0 then
				self.numSparks -= 1
				self.phaseTimer = CUBE_SWIRL_TIME
				self.speedY = -4
			else
				if self.wasCaught then
					self.phase = 5
					self.phaseTimer = 20
				else
					self.phase = 6
					self.phaseTimer = 20
				end
			end
		end
	elseif self.phase == 5 then
		self.phaseTimer -= 1
		if self.phaseTimer == 0 then
			self.isDone = true
		end
	elseif self.phase == 6 then
		self.phaseTimer -= 1
		if self.phaseTimer == 0 then
			self.phase = 7
			self.phaseTimer = 25
			self.speedX = math.random(-3, 3)
			self.speedY = math.random(-5, -3)
		end
	elseif self.phase == 7 then
		self.phaseTimer -= 1
		self.posX += self.speedX
		self.posY += self.speedY
		self.speedY += 1

		enemyMonsterPosX = playdate.math.lerp(self.posX, enemyMonsterEndX, timeLeft(self.phaseTimer, 25))
		enemyMonsterPosY = playdate.math.lerp(self.posY, enemyMonsterY, timeLeft(self.phaseTimer, 25))
		enemyMonsterDrawScale = playdate.math.lerp(CUBE_SUCK_MIN_SIZE, 1.0, timeLeft(self.phaseTimer, 25))
		if self.phaseTimer == 0 then
			self.isDone = true
		end
	end
end

function ThrowCubeAnim:renderBehind()
	if self.phase == 1 then
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillTriangle(self.posX, self.posY, self.posX + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTX, self.posY + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTY, self.posX + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTX/2, self.posY + playdate.math.lerp(0, 1, timeLeft(self.phaseTimer, CUBE_WAITAT_STOPAT)) * CUBE_SUCK_DISTY)
		gfx.setColor(gfx.kColorBlack)
	elseif self.phase == 2 then
		gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
		gfx.fillTriangle(self.posX, self.posY, self.posX + CUBE_SUCK_DISTX, self.posY + CUBE_SUCK_DISTY, self.posX + CUBE_SUCK_DISTX/2, self.posY + CUBE_SUCK_DISTY)
		gfx.setColor(gfx.kColorBlack)
	end
end

function ThrowCubeAnim:render()
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