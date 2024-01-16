class('MonsterStorageAccessor').extends(NPC)

function MonsterStorageAccessor:init(x, y)
	MonsterStorageAccessor.super.init(self, "monsterstorageaccessor", x, y)
	self:loadImg("monsterstorageaccessor")
end

function fullyRestoreMonsters()
	for k, v in pairs(playerMonsters) do
		v.curHp = v.maxHp
	end
end

function MonsterStorageAccessor:onInteract()
	if #playerMonsterStorage > 0 then
		startFade(openStorageView)
	else
		addScript(TextScript("And this is where I'd access stored Kenemon... if I HAD any!!!"))
		nextScript()
	end
end