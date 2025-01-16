local colorhelper = require("colorhelper")

local colorbox = {}
colorbox.__index = colorbox


-- @param bound {x=,y=,w=,h=}
-- @param hsv {h=,s=,v=}
function colorbox:new(bound, hsv)
    local obj = {}
    setmetatable(obj, colorbox)

    obj.bound = bound
    obj.hsv = hsv

    return obj
end

function colorbox:draw(hsv)
    hsv = hsv or self.hsv

    love.graphics.setColor(colorhelper.HSVtoRGB(hsv.h, hsv.s, hsv.v))
    love.graphics.rectangle("fill", self.bound.x, self.bound.y, self.bound.w, self.bound.h)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", self.bound.x, self.bound.y, self.bound.w, self.bound.h)
end


return colorbox