class("SpeedDown").extends(OrbitingStatus)

function SpeedDown:init(target)
	SpeedDown.super.init(self, "Speed Down", 0, target)
end

function SpeedDown:modifySpeed(speed)
	return speed - (self.owner.speed * 0.1)
end