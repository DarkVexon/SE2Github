class('SwoleMark').extends(Mark)

function SwoleMark:init()
	SwoleMark.super.init(self, "Swole")
end

function SwoleMark:applyToStats(stats)
	stats[2] = stats[2] * 1.2
end