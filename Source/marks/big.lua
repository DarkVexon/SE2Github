class('BigMark').extends(Mark)

function BigMark:init()
	BigMark.super.init(self, "Big")
end

function BigMark:applyToStats(stats)
	stats[1] = stats[1] * 1.2
end