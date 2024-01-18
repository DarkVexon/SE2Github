class('Animation').extends()

function Animation:init()
	self.isDone = false
	self.renderBehind = false
end

function Animation:update()

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