class('VFX').extends()

function VFX:init()
	self.isDone = false
	self.renderBehind = false
end

function VFX:render()

end

function VFX:update()

end

-- IMPORTS

import "vfx/damageoutwardline"
import "vfx/damagepaf"
import "vfx/levelupwardsline"
import "vfx/damagenumber"

import "vfx/grassshakesparkle"