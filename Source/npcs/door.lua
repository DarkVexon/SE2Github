class('Door').extends(Object)

function Door:init(x, y, map, transloc)
	Door.super.init(self, "door", x, y)
	self.targetMap = map
	self.targetTransloc = transloc
end

function Door:canMoveHere()
	return true
end

function Door:onOverlap()
	table.insert(MapChangeScript(self.targetMap, self.targetTransloc))
	nextScript()
end

function Door:allowImmediateMovementAfterStep()
	return false
end