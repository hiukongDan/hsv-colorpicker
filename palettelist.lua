local palettebox = require("palettebox")
local boundcheck = require("boundcheck")

local insert = table.insert

local palettelist = {}
palettelist.__index = palettelist

-- @param number number of paletteboxes
-- @bound {x=,y=,w=,h=}
function palettelist:new(number, bound, onselectslot)
    local obj = {}
    setmetatable(obj, palettelist)

    obj.number = number
    obj.bound = bound
    obj.onselectslot = onselectslot or function() end

    obj.list = {}
    obj.selected = 1    -- current selected slot

    local hsv = {h=1, s=0, v=1}
    local x,y,w,h = bound.x, bound.y, bound.w, bound.w
    local margin = 10

    for i = 1, number do
        local pb = palettebox:new({h=hsv.h, s=hsv.s, v=hsv.v}, {x=x, y=y, w=w, h=h})
        y = y + h + margin
        insert(obj.list, pb)
    end

    -- select first
    obj:select(1)

    return obj
end


function palettelist:onhsvchange(hsv)
    if #self.list >= self.selected then
        self.list[self.selected].hsv.h = hsv.h
        self.list[self.selected].hsv.s = hsv.s
        self.list[self.selected].hsv.v = hsv.v
    end
end


function palettelist:currentHSV()
    if #self.list >= self.selected then
        local hsv = self.list[self.selected].hsv
        return hsv.h, hsv.s, hsv.v
    else
        return 1, 0, 1
    end
end


function palettelist:select(index)
    if #self.list >= index then
        self.list[self.selected].selected = false
        self.selected = index
        self.list[index].selected = true
        self:onselectslot()
    end
end


function palettelist:onmousepressed(x,y,btn)
    local hit = {x=x, y=y}
    if btn == 1 then
        for i = 1, #self.list do
            if boundcheck.pointin(hit, self.list[i].bound) then
                self:select(i)
                break
            end
        end
    end
end


function palettelist:draw()
    for i = 1, #self.list do
        self.list[i]:draw()
    end
end


return palettelist