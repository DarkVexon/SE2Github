class('SpeedyMark').extends(Mark)

function SpeedyMark:init()
	SpeedyMark.super.init(self, "Speedy")
end

function SpeedyMark:applyToStats(stats)
	stats[4] = stats[4] * 1.2
end