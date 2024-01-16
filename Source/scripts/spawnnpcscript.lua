class('SpawnNPCScript').extends(Script)

function SpawnNPCScript:init(npc)
	SpawnNPCScript.super.init(self, "Spawn in " .. npc.name)
	self.npc = npc
end

function SpawnNPCScript:execute()
	table.insert(objs, self.npc)
	nextScript()
end