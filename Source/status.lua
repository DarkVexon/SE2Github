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

-- IMPORTS

import "statuses/offensedown"