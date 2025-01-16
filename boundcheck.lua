local boundcheck = {}

-- @summary check if point is within bound
-- @param p = {x=, y=} point
-- @param b = {x=, y=, w=, h=} bound
function boundcheck.pointin(p, b)
    return p.x > b.x and
           p.x < b.x + b.w and
           p.y > b.y and
           p.y < b.y + b.h
end

-- @summary move p along with a side of bound if dx,dy makes it out of bound
-- @param p = {x=, y=} point
-- @param b = {x=, y=, w=, h=} bound
-- @param dx movement along x axis
-- @param dy movement along y axis
-- @returns x, y solved point within bound or along one side of the bound
-- function boundcheck.solveconstraint(p, b, dx, dy)
--     local t = {}
--     t.x, t.y = p.x+dx, p.y+dy
--     if boundcheck.pointin(t, b) then return t.x, t.y end
--     if t.x < b.x or t.x > b.x+b.w then return p.x, p.y+dy end

-- end


return boundcheck