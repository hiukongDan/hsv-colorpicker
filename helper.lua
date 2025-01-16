local helper = {}

local min, max = math.min, math.max

-- @param x value to clamp
-- @param a min value
-- @param b max value
-- @returns clamped value between a,b
function helper.clamp(x,a,b) return min(b, max(a, x)) end

-- @param x number
-- @param ... numbers
-- @returns average value
function helper.average(x, ...)
    local sum = x or 0
    local rest = {...}
    for i = 1, #rest do
        sum = sum + rest[i]
    end
    return sum/(1+#rest)
end

-- @param d value
-- @param a,b old range
-- @param x,y new range
-- @returns map value d in (a,b) to the value in (x,y)
function helper.remap(d, a,b, x,y)
    return (d-a)/(b-a) * (y-x) + x
end


return helper