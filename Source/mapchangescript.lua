class('MapChangeScript').extends(GameScript)

function MapChangeScript:init(map, transloc)
	MapChangeScript.super.init(self)
	self.map = map
	self.transloc = transloc
end

function MapChangeScript:execute()
	fadeOutTimer = 15
	fadeDest = 1
	nextMap = self.map
	nextTransloc = self.transloc
end