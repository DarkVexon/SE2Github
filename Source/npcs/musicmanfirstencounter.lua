class('MusicManFirstEncounter').extends(Person)

local DRSYTE_COMBAT_BACKSIDE <const> = gfx.image.new("img/combat/combatRival")

function MusicManFirstEncounter:init(x, y)
	MusicManFirstEncounter.super.init(self, "musicnote", x, y, 0)
end

function MusicManFirstEncounter:shouldSpawn()
	return playerFlag == 4
end

function MusicManFirstEncounter:onPlayerEndMove()
	if playerFlag == 4 then
		if (playerX == self.posX and playerY == self.posY - 3) then
			addScript(MoveNPCScript(self, -1, 0))
			addScript(MoveNPCScript(self, -1, 0))
			addScript(TextScript(""))
		end
	end
end