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
import "npcs/standstilltalker"
import "npcs/door"
import "npcs/healingmachine"
import "npcs/nocreaturesgoback"
import "npcs/tablecube"
import "npcs/genericrival"
import "npcs/trainer"
import "npcs/turningtrainer"
import "npcs/walkingtrainer"
import "npcs/monsterstorageaccessor"
import "npcs/founditem"
import "npcs/wanderingperson"
import "npcs/shopopener"
import "npcs/spawnintroman"
import "npcs/rivalcatchtutorial"
import "npcs/cantleavetetrayet"
import "npcs/typemasterfire"

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
		newNpc = Trainer(info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
	elseif npcType == "monsterstorageaccessor" then
		newNpc = MonsterStorageAccessor(info[2], info[3])
	elseif npcType == "founditem" then
		newNpc = FoundItem(info[2], info[3], info[4], info[5])
	elseif npcType == "wanderingperson" then
		newNpc = WanderingPerson(info[2], info[3], info[4], info[5])
	elseif npcType == "shopopener" then
		newNpc = ShopOpener(info[2], info[3])
	elseif npcType == "spawnintroman" then
		newNpc = SpawnIntroMan(info[2], info[3])
	elseif npcType == "rivalcatchtutorial" then
		newNpc = RivalCatchTutorial(info[2], info[3])
	elseif npcType == "standstilltalker" then
		newNpc = StandStillTalker(info[2], info[3], info[4], info[5], info[6])
	elseif npcType == "cantleavetetrayet" then
		newNpc = CantLeaveTetraYet(info[2], info[3])
	elseif npcType == "turningtrainer" then
		newNpc = TurningTrainer(info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
	elseif npcType == "walkingtrainer" then
		newNpc = WalkingTrainer(info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9], info[10], info[11], info[12])
	elseif npcType == "typemasterfire" then
		newNpc = TypeMasterFire(info[2], info[3], info[4])
	end
	if newNpc:shouldSpawn() then
		table.insert(objs, newNpc)
	end
end