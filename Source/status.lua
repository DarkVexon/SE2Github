class('Status').extends()

-- STATUS TYPES
-- 0: Debuff
-- 1: Buff

function Status:init(name, type, owner)
	self.name = name
	self.type = type
	self.owner = owner
end

function Status:modifyAttack(attack)
	return attack
end

function Status:modifySpeed(speed)
	return speed
end

function Status:modifyDefense(defense)
	return defense
end

function Status:preUseMove()
	return true
end

function Status:update()

end

function Status:render()

end

function Status:modifyOutgoingDamage(damage, damageType)
	return damage
end

-- IMPORTS

import "statuses/orbitingstatus"
import "statuses/attackdown"
import "statuses/speedup"
import "statuses/defensedown"
import "statuses/speeddown"
import "statuses/defenseup"
import "statuses/attackup"
import "statuses/daze"
import "statuses/charmed"