class('NPC').extends()

objectImgs = {}

function NPC:loadImg(imgName)
	if (containsKey(objectImgs, imgName)) then
		self.img = objectImgs[imgName]
	else
		objectImgs[imgName] = gfx.image.new("img/overworld/npc/" .. imgName)
		self.img = objectImgs[imgName]
	end
end

function NPC:init(name, x, y)
	self.name = name
	self.posX = x
	self.startX = x
	self.posY = y
	self.startY = y
	self.visDestX = (self.posX-1) * 40
	self.visDestY = (self.posY-1) * 40
	self.visX = self.visDestX
	self.visY = self.visDestY
	self.speed = 4
	self.width = 0
	self.height = 0
end

function NPC:render()
	if self.img ~= nil then
		if self:shouldRender() then
			self.img:draw(self.visX + cameraOffsetX, self.visY + cameraOffsetY)
		end
	end
end

function NPC:update()

end

function NPC:shouldRender()
	return (cameraOffsetGridX <= self.posX+1 and cameraOffsetGridX + camWidth >= self.posX-1 and cameraOffsetGridY <= self.posY+1 and cameraOffsetGridY + camHeight >= self.posY-1)
end

function NPC:canMoveHere()
	return false
end

function NPC:onInteract()

end

function NPC:onOverlap()

end

function NPC:allowImmediateMovementAfterStep()
	return true
end

function NPC:shouldSpawn()
	return true
end

function NPC:occupies(x, y)
	if self.width == 0 and self.height == 0 then
		return self.posX == x and self.posY == y
	else
		return x >= self.posX and x <= self.posX + self.width and y >= self.posY and y <= self.posY + self.width
	end
end

function NPC:onPlayerEndMove()

end

-- IMPORTS
import "npcs/signpost"
import "npcs/person"
import "npcs/door"
import "npcs/healingmachine"
import "npcs/nocreaturesgoback"
import "npcs/letter"
import "npcs/tablecube"
import "npcs/rivalfirstencounter"
import "npcs/trainer"
import "npcs/monsterstorageaccessor"

function loadNpc(info)
	local npcType = info[1]
	local newNpc
	if npcType == "signpost" then
		newNpc = Signpost(info[2], info[3], info[4])
	elseif npcType == "person" then
		newNpc = Person(info[2], info[3], info[4], info[5])
	elseif npcType == "door" then
		newNpc = Door(info[2], info[3], info[4], info[5])
	elseif npcType == "healmachine" then
		newNpc = HealingMachine(info[2], info[3])
	elseif npcType == "nocreaturesgoback" then
		newNpc = NoCreaturesGoBack(info[2], info[3])
	elseif npcType == "letter" then
		newNpc = Letter(info[2], info[3], info[4])
	elseif npcType == "tablecube" then
		newNpc = Tablecube(info[2], info[3])
	elseif npcType == "trainer" then
		newNpc = Trainer(info[2], info[3], info[4], info[5], info[6], info[7], info[8])
	elseif npcType == "monsterstorageaccessor" then
		newNpc = MonsterStorageAccessor(info[2], info[3])
	end
	if newNpc:shouldSpawn() then
		table.insert(objs, newNpc)
	end
end