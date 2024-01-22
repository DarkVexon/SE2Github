class('Animation').extends()

function Animation:init()
	self.isDone = false
end

function Animation:update()

end

function Animation:renderBehind()

end

function Animation:render()

end

-- Imports
import "animations/hpbaranim"
import "animations/faintanim"
import "animations/attackanim"
import "animations/moveofforonanim"
import "animations/movecapturedmonsteranim"
import "animations/launchboltanim"
import "animations/xpbaranim"
import "animations/throwcubeanim"
import "animations/showabilityanim"