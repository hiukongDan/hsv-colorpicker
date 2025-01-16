local boundcheck = require("boundcheck")

local pointin = boundcheck.pointin
local max = math.max

local infobox = {}
infobox.__index = infobox


-- @param text text to print
-- @param bound {x=,y=,w=,h=}
function infobox:new(text, bound)
    local obj = {}
    setmetatable(obj, infobox)

    obj.text = text
    obj.bound = bound

    obj.flashtime = 0.1
    obj.flash = 0

    return obj
end


function infobox:draw()
    love.graphics.print(self.text, self.bound.x + 10, self.bound.y+2)
    love.graphics.setColor(1,1,1)
    local mode
    if self.flash == 0 then mode = "line" else mode = "fill" end
    love.graphics.rectangle(mode, self.bound.x, self.bound.y, self.bound.w, self.bound.h)
    -- flash info
    if self.flash > 0 then
        love.graphics.print("copied", 10, 575)
    end
end


function infobox:onmousepressed(x,y,btn)
    if btn == 1 and self.flash == 0 and pointin({x=x,y=y}, self.bound) then
        self.flash = self.flashtime
        -- TODO copy to clipboard
        love.system.setClipboardText(self.text)
    end
end

function infobox:update(dt)
    self.flash = max(self.flash - dt, 0)
end


return infobox