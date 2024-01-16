class('Letter').extends(NPC)

function Letter:init(x, y, text)
	Letter.super.init(self, "letter", x, y)
	self:loadImg("letter")
	self.text = text
end

function Letter:shouldSpawn()
	return playerFlag == 1
end

function Letter:canInteract()
	return playerFlag == 1
end

function Letter:onInteract()
	if playerFlag == 1 then
		playerFlag = 2
		addScript(TextScript(self.text))
		addScript(DestroyNPCScript(self))
		nextScript()
	end
end