local colorhelper = require("colorhelper")

local palettebox = {}
palettebox.__index = palettebox


-- @param hsv initial hsv value {h=,s=,v=}
-- @param bound bound {x=,y=,w=,h=}
function palettebox:new(hsv, bound)
    local obj = {}
    setmetatable(obj, palettebox)

    obj.hsv = hsv
    obj.bound = bound
    obj.selected = false

    return obj
end


function palettebox:onmousepressed(x,y,btn)

end


function palettebox:onmousereleased(x,y,btn)

end


function palettebox:onmousemoved(x,y,dx,dy)

end


function palettebox:update(dt)

end


function palettebox:draw()
    local x,y,w,h = self.bound.x, self.bound.y, self.bound.w, self.bound.h
    -- color box
    love.graphics.setColor(colorhelper.HSVtoRGB(colorhelper.unpackhsv(self.hsv)))
    love.graphics.rectangle("fill", x,y,w,h)
    -- bound
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", x,y,w,h)

    if self.selected then
        local d = 5
        love.graphics.line(x-d, y, x+w+d, y)
        love.graphics.line(x-d, y+h, x+w+d, y+h)
        love.graphics.line(x, y-d, x, y+h+d)
        love.graphics.line(x+w, y-d, x+w, y+h+d)
    end
end


return palettebox