class("SpeedUp").extends(OrbitingStatus)

function SpeedUp:init(target)
	SpeedUp.super.init(self, "Speed Up", 1, target)
end

function SpeedUp:modifySpeed(speed)
	return speed + (self.owner.speed * 0.1)
end