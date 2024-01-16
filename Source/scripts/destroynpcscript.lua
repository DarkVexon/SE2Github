class('DestroyNPCScript').extends(Script)

function DestroyNPCScript:init(npc)
	DestroyNPCScript.super.init(self, "Destroy " .. npc.name)
	self.npc = npc
end

function DestroyNPCScript:execute()
	table.remove(objs, indexValue(objs, self.npc))
	nextScript()
end