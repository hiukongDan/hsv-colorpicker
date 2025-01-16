local colorhelper = require("colorhelper")
local boundcheck = require("boundcheck")
local helper = require("helper")


local pointin = boundcheck.pointin
local clamp = helper.clamp

local hsvbox = {}
hsvbox.__index = hsvbox


-- @param gradient object of gradient
-- @param bound bounding box {x,y,w,h}
-- @param onupdatehsv callback when hsv changed: function(hsv) end, where hsv {h=,s=,v=}
-- @param cursor current cursor position
-- @param cursorbound {w,h}
function hsvbox:new(gradient, bound, onupdatehsv, cursor, cursorbound)
    local obj = {}
    setmetatable(obj, hsvbox)

    obj.gradient = gradient
    obj.bound = bound
    obj.onupdatehsv = onupdatehsv or function(hsv) end
    obj.cursor = cursor or {x=bound.x+bound.w/2, y=bound.y+bound.h/2}
    obj.cursorbound = cursorbound or {w=10, h=10}
    obj.selected = false

    return obj
end


function hsvbox:onmousepressed(x,y,btn)
    local hit = {x=x, y=y}
	if btn == 1 and pointin(hit, self.bound) then
		self.selected = true
		love.mouse.setVisible(false)
		self.cursor.x, self.cursor.y = x, y

        local s = (self.cursor.x - self.bound.x) / self.bound.w
		local v = 1 - (self.cursor.y - self.bound.y) / self.bound.h
        self.onupdatehsv({h=0, s=s, v=v})
	end
end


function hsvbox:onmousereleased(x,y,btn)
    if btn == 1 and self.selected then
		love.mouse.setVisible(true)
		self.selected = false
	end
end


function hsvbox:onmousemoved(x,y,dx,dy)
    local hit = {x=x, y=y}
	if love.mouse.isDown(1) and self.selected then

		if (pointin({x=self.cursor.x+dx, y=self.cursor.y+dy}, self.bound)) then
			self.cursor.x, self.cursor.y = self.cursor.x+dx, self.cursor.y+dy
		else
			self.cursor.x = clamp(self.cursor.x+dx, self.bound.x, self.bound.x+self.bound.w)
			self.cursor.y = clamp(self.cursor.y+dy, self.bound.y, self.bound.y+self.bound.h)
		end

		local s = (self.cursor.x - self.bound.x) / self.bound.w
		local v = 1 - (self.cursor.y - self.bound.y) / self.bound.h
        self.onupdatehsv({h=0, s=s, v=v})
	end
end


function hsvbox:update(dt)

end


-- @param hsv {h=,s=,v=}
function hsvbox:draw(hsv)
    self.gradient:draw({h=hsv.h, s=1, v=1})

    love.graphics.setColor(1,1,1)
    -- bounding box
    love.graphics.rectangle("line", self.bound.x, self.bound.y, self.bound.w, self.bound.h)
    -- cursor
    love.graphics.rectangle("line", self.cursor.x-self.cursorbound.w/2, self.cursor.y-self.cursorbound.h/2,
        self.cursorbound.w, self.cursorbound.h)
end


return hsvbox