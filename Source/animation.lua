class('Animation').extends()

function Animation:init()
	self.isDone = false
end

function Animation:update()

end

-- Imports
import "animations/hpbaranim"
import "animations/faintanim"
import "animations/attackanim"
import "animations/moveofforonanim"