class('Tough').extends(Mark)

function Tough:init()
	Tough.super.init(self, "Tough")
end

function Tough:applyToStats(stats)
	stats[3] = stats[3] * 1.2
end