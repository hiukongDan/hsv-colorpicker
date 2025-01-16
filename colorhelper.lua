local colorhelper = {}

local abs = math.abs
local floor = math.floor

-- Hue: Red, orange, yellow, green, teal, blue, violet, purple, magenta, red
-- range 0-1
function colorhelper.HSVtoRGB(h, s, v)
    if (s == 0) then return v,v,v end   -- saturation is 0
    h = h * 6
    local x, y = v*s, v*(1-s)
    local r, g, b = 0, 0, 0
    local distance = (1-abs(h%2-1))
    local x, y, z = x+y, x*distance+y, y
    if h < 1 then
        r, g, b = x, y, z
    elseif h < 2 then
        r, g, b = y, x, z
    elseif h < 3 then
        r, g, b = z, x, y
    elseif h < 4 then
        r, g, b = z, y, x
    elseif h < 5 then
        r, g, b = y, z, x
    else
        r, g, b = x, z, y
    end
    return r, g, b
end

-- @param hsv = {h=,s=,v=}
-- @returns h,s,v
function colorhelper.unpackhsv(hsv)
    return hsv.h, hsv.s, hsv.v
end

-- @param h,s,v
-- @returns {h=h, s=s, v=v}
function colorhelper.packhsv(h,s,v)
    return {h=h, s=s, v=v}
end

-- @param rgb = {r=,g=,b=}
-- @returns r,g,b
function colorhelper.unpackrgb(rgb)
    return rgb.r, rgb.g, rgb.b
end

-- @param r,g,b
-- @returns rgb = {r=,g=,b=}
function colorhelper.packrgb(r,g,b)
    return {r=r, g=g, b=b}
end


function colorhelper.complementary(h, s, v)
    return (h*6+2)%6/6, 1-s, 1-v
end

function colorhelper.HSVtoRGB255(h, s, v)
    local r,g,b = colorhelper.HSVtoRGB(h,s,v)
    return floor(r*255), floor(g*255), floor(b*255)
end


function colorhelper.hsvtostring(hsv)
    local res = string.format("hsv (%.3f,%.3f,%.3f)", hsv.h, hsv.s, hsv.v)
    return res
end

function colorhelper.hsvto255string(hsv)
    local h,s,v = floor(hsv.h*255), floor(hsv.s*255), floor(hsv.v*255)
    local res = string.format("hsv (%d,%d,%d)", h, s, v)
    return res
end

function colorhelper.hsvtorgbstring(hsv)
    local r,g,b = colorhelper.HSVtoRGB(hsv.h, hsv.s, hsv.v)
    local res = string.format("rgb (%.3f,%.3f,%.3f)", r, g, b)
    return res
end

function colorhelper.hsvtorgb255string(hsv)
    local r,g,b = colorhelper.HSVtoRGB255(hsv.h, hsv.s, hsv.v)
    local res = string.format("rgb (%d,%d,%d)", r,g,b)
    return res
end



return colorhelper