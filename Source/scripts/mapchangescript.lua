class('MapChangeScript').extends(Script)

function MapChangeScript:init(tarMap, tarTransloc)
	MapChangeScript.super.init(self, "Map change to " .. tarMap .. " transloc " .. transLoc)
	self.map = tarMap
	self.transloc = tarTransloc
end

function MapChangeScript:execute()
	startFade(loadNextMap)
	nextMap = self.map
	nextTransloc = self.transloc
end