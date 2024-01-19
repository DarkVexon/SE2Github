class('KenedarMap').extends(Item)

function KenedarMap:init()
	KenedarMap.super.init(self, "Kenedar Map")
end

function KenedarMap:use()
	startFade(openWorldMap)
end