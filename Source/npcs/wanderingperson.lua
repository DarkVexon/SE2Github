class('WanderingPerson').extends(Person)

local TIME_BETWEEN_WANDERS_MIN <const> = 100
local TIME_BETWEEN_WANDERS_MAX <const> = 175
local MAX_WANDERDIST <const> = 4

function WanderingPerson:init(name, x, y, talkText)
	WanderingPerson.super.init(self, name, x, y, 2)
	self.timeToWander = math.random(TIME_BETWEEN_WANDERS_MIN, TIME_BETWEEN_WANDERS_MAX)
	self.text = talkText
end

function WanderingPerson:canMoveThere(x, y)
	if math.abs(x - self.startX) >= MAX_WANDERDIST or math.abs(y - self.startY) >= MAX_WANDERDIST then
		return false
	else
		return WanderingPerson.super.canMoveThere(self, x, y)
	end
end

function WanderingPerson:update()
	WanderingPerson.super.update(self)
	self.timeToWander -= 1
	if self.timeToWander <= 0 then
		self:wander()
		self.timeToWander = math.random(TIME_BETWEEN_WANDERS_MIN, TIME_BETWEEN_WANDERS_MAX)
	end
end

function WanderingPerson:wander()
	local validDirs = {}
	for x=-1, 1 do
		for y=-1, 1 do
			if math.abs(x) ~= math.abs(y) then
				if self:canMoveThere(x + self.posX, y + self.posY) then
					table.insert(validDirs, {x, y})
				end
			end
		end
	end
	if #validDirs > 0 then
		local next = validDirs[math.random(#validDirs)]
		self:moveBy(next[1], next[2])
	end
end

function WanderingPerson:onInteract()
	self:turnToFacePlayer()
	addScript(TextScript(self.text))
	nextScript()
end