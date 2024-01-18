class('SumupsAnim').extends(Animation)

function SumupsAnim:init()
	SumupsAnim.super.init(self)
	self.started = false
end

function SumupsAnim:update()
	if not self.started then
		self.started = true
		nextSumup()
	end
	updateSumups()
	if sumupsOver then
		sumupsOver = false
		isDone = true
	end
end

function SumupsAnim:render()
	drawSumups()
end