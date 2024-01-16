class('Speedy').extends(Mark)

function Speedy:init()
	Speedy.super.init(self, "Speedy")
end

function Speedy:applyToStats(stats)
	stats[4] = stats[4] * 1.2
end