class('TurningTrainer').extends(Trainer)

function TurningTrainer:init(name, x, y, facing, combat, textIn, textAfterFought, flagID)
	TurningTrainer.super.init(self, name, x, y, facing, combat, textIn, textAfterFought, flagID)
	self.turnTimer = math.random(70, 120)
end

function TurningTrainer:update()
	TurningTrainer.super.update(self)
	self.turnTimer -= 1
	if self.turnTimer <= 0 then
		self.turnTimer = math.random(70, 120)
		local validFacings = {}
		if canMoveThere(self.posX + 1, self.posY) then
			table.insert(validFacings, 1)
		end
		if canMoveThere(self.posX - 1, self.posY) then
			table.insert(validFacings, 3)
		end
		if canMoveThere(self.posX, self.posY - 1) then
			table.insert(validFacings, 0)
		end
		if canMoveThere(self.posX, self.posY + 1) then
			table.insert(validFacings, 1)
		end
		if #validFacings > 0 then
			self:setFacing(validFacings[math.random(#validFacings)])
			self:checkForEyeContact()
		end
	end
end