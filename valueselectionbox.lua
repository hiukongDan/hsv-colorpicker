local boundcheck = require("boundcheck")
local helper = require("helper")

local pointin = boundcheck.pointin
local average = helper.average
local remap = helper.remap
local clamp = helper.clamp


local ValueSelectionBox = {}
ValueSelectionBox.__index = ValueSelectionBox


-- @summary a value selection box for a range of values
-- @param bound {x=,y=,w=,h=}
-- @param min minimum value
-- @param max maximum value
-- @param isHorizontal is the range selection horizontal
-- @param isFromLeftTop does the smallest value start from left/top
-- @param onvaluechanged callback when value changed
-- @param *callbacks  callback functions for love mouse events and draw/update
function ValueSelectionBox:new(
    bound,
    min, max,
    isHorizontal,
    isFromLeftTop,
    onvaluechanged,
    mousepressedcallback,
    mousereleasedcallback,
    mousemovedcallback,
    drawcallback,
    updatecallback
)
    local obj = {}
    setmetatable(obj, ValueSelectionBox)

    obj.bound = bound or {x=0, y=0, w=10, h=10}
    obj.min = min or 0
    obj.max = max or 1
    obj.isHorizontal = isHorizontal or true
    obj.isFromLeftTop = isFromLeftTop or true
    obj.onvaluechanged = onvaluechanged or function(value) end
    obj.mousepressedcallback = mousepressedcallback or function(x,y,btn) end
    obj.mousereleasedcallback = mousereleasedcallback or function(x,y,btn) end
    obj.mousemovedcallback = mousemovedcallback or function(x,y) end
    obj.drawcallback = drawcallback or function() end
    obj.updatecallback = updatecallback or function(dt) end
    obj.selected = false
    obj.value = average(obj.min, obj.max)
    obj.cursor = {x=bound.x+bound.w/2, y=bound.y}

    return obj
end


function ValueSelectionBox:onmousepressed(x, y, btn)
    self.mousepressedcallback(x,y,btn)

    if btn == 1 and pointin({x=x,y=y}, self.bound) then
        self.selected = true
        self:clampmousevalue(x, y)
        self.onvaluechanged(self.value)
    end
end


function ValueSelectionBox:onmousereleased(x, y, btn)
    self.mousereleasedcallback(x, y, btn)
    self.selected = false
end


function ValueSelectionBox:onmousemoved(x, y, dx, dy)
    self.mousemovedcallback(x, y)
    if self.selected and love.mouse.isDown(1) then
        self:clampmousevalue(x, y)
        self.onvaluechanged(self.value)
    end
end


function ValueSelectionBox:drawbox()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", self.bound.x, self.bound.y, self.bound.w, self.bound.h)
end


function ValueSelectionBox:drawselectionbar()
    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(1,1,1)
    local w,h = 4, self.bound.h
    local x,y = self.cursor.x-w/2, self.bound.y
    local p, q = 4, 2
    love.graphics.rectangle("line", x,y,w,h)
    love.graphics.rectangle("fill", x-p, y-q, 2*p+w, q)
    love.graphics.rectangle("fill", x-p, y+h, 2*p+w, q)
    love.graphics.setColor(r,g,b)
end


function ValueSelectionBox:draw()
    self.drawcallback()
    self:drawbox()
    self:drawselectionbar()
end


function ValueSelectionBox:update(dt)
    self.updatecallback(dt)
end


function ValueSelectionBox:clampmousevalue(x,y)
    local a,b,c,d = self.bound.x, self.bound.x+self.bound.w, self.bound.y, self.bound.y+self.bound.h

    x = clamp(x, a, b)
    y = clamp(y, c, d)
    self.cursor.x = x
    self.cursor.y = y

    if self.isHorizontal then
        if self.isFromLeftTop then
            self.value = remap(x, a, b, self.min, self.max)
        else
            self.value = remap(x, b, a, self.min, self.max)
        end
    else
        if self.isFromLeftTop then
            self.value = remap(y, c, d, self.min, self.max)
        else
            self.value = remap(y, d, c, self.min, self.max)
        end
    end
end


return ValueSelectionBox