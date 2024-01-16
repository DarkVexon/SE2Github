class('Big').extends(Mark)

function Big:init()
	Big.super.init(self, "Big")
end

function Big:applyToStats(stats)
	stats[1] = stats[1] * 1.2
end