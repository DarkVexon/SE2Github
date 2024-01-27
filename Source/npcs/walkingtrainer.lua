class('WalkingTrainer').extends(Trainer)

function WalkingTrainer:init(name, x, y, facing, combat, textIn, textAfterFought, flagID, distHoriz, distVert, isClockwise)
	WalkingTrainer.super.init(self, name, x, y, facing, combat, textIn, textAfterFought, flagID)
	if not contains(playerBeatenTrainers, self.flagID) then
		self.startTimer = 5
	else
		self.startTimer = 0
	end
	self.distMoved = 0
	self.distHoriz = distHoriz
	self.distVert = distVert
	self.clockwise = isClockwise
end

function WalkingTrainer:update()
	WalkingTrainer.super.update(self)
	if self.startTimer >= 0 then
		self.startTimer -= 1
		if self.startTimer == 0 then
			self:moveForwards()
		end
	end
end

function WalkingTrainer:onMoveEnd()
	WalkingTrainer.super.onMoveEnd(self)
	self.distMoved += 1
	if not fightStarting then
		print(self.distMoved)
		print(self.distVert)
		print(self.distHoriz)
		if (self.facing == 2 or self.facing == 0) and (self.distMoved == self.distVert) then
			if self.clockwise then
				if self.facing == 2 then
					self:setFacing(1)
				else
					self:setFacing(3)
				end
			else
				if self.facing == 2 then
					self:setFacing(3)
				else
					self:setFacing(1)
				end
			end
			self.distMoved = 0
		elseif (self.facing == 1 or self.facing == 3) and (self.distMoved == self.distHoriz) then
			if self.clockwise then
				if self.facing == 1 then
					self:setFacing(0)
				else
					self:setFacing(2)
				end
			else
				if self.facing == 1 then
					self:setFacing(2)
				else
					self:setFacing(0)
				end
			end
			self.distMoved = 0
		end
		self.startTimer = 1
	end
end