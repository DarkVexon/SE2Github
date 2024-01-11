class('ToughMark').extends(MonsterMark)

function ToughMark:init()
	ToughMark.super.init(self, "Tough")
end

function ToughMark:applyToStats(stats)
	stats[3] = stats[3] * 1.2
end