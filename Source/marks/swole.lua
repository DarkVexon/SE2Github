class('Swole').extends(Mark)

function Swole:init()
	Swole.super.init(self, "Swole")
end

function Swole:applyToStats(stats)
	stats[2] = stats[2] * 1.2
end