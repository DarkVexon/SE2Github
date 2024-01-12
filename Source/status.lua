class('Status').extends()

-- STATUS TYPES
-- 0: Debuff
-- 1: Buff

function Status:init(name, type)
	self.name = name
	self.type = type
end

function Status:modifyAttack()

end

-- IMPORTS

import "statuses/offensedown"