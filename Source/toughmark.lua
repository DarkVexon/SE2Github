class('ToughMark').extends(MonsterMark)

function ToughMark:init()
	ToughMark.super.init(self, "Tough")
end

function ToughMark:applyToStats(stats)
	stats[1] = stats[1] * 1.2
end