local colorhelper = require("colorhelper")
local insert = table.insert

local gradient = {
    _default = {
        shader = "shaders/gradient.glsl",
        uvs = {
            gradient = {{0,1}, {1,1}, {0,0}, {1,0}},
            linear = {{0,0},{1,1},{0,0},{1,1}}
        }

    }
}
gradient.__index = gradient


-- @param colors {r=,g=,b=} table of 4 colors from topleft, topright, bottomleft, bottomright
-- @param bound {x=,y=,w=,h=}
-- @param uvs table of uvs, from topleft, topright, bottomleft, bottomright
function gradient:newQuad(color, bound, uvs, shader)
    local obj = {}
    setmetatable(obj, gradient)

    uvs = uvs or gradient._default.uvs.gradient
    shader = shader or gradient._default.shader

    obj.color = color
    obj.bound = bound
    local r,g,b = colorhelper.unpackrgb(color)
    local verts = {}
    insert(verts, {
        bound.x, bound.y, uvs[1][1], uvs[1][2], r,g,b, 1
    })
    insert(verts, {
        bound.x+bound.w, bound.y, uvs[2][1], uvs[2][2], r,g,b, 1
    })
    insert(verts, {
        bound.x, bound.y+bound.h, uvs[3][1], uvs[3][2], r,g,b, 1
    })
    insert(verts, {
        bound.x+bound.w, bound.y+bound.h, uvs[4][1], uvs[4][2], r,g,b, 1
    })

    obj.mesh = love.graphics.newMesh(verts, "strip", "dynamic")

    obj.shader = love.graphics.newShader(shader, shader)
    if obj.shader:hasUniform("gradientColor") then
        obj.shader:sendColor("gradientColor", {r,g,b})
    end

    return obj
end


-- @param colors {r=,g=,b=} table of 4 colors from topleft, topright, bottomleft, bottomright
function gradient:setColors(colors)
    self.colors = colors
    for i = 1, #colors do
        local c = colors[i]
        local x,y,u,v = self.mesh:getVertex(i)
        self.mesh:setVertex(i, x,y,u,v, colorhelper.unpackrgb(c))
    end
end


-- draw gradient
function gradient:draw(hsv)
    hsv = hsv or {h=1,s=1,v=1}
    -- self:setColors(self.colors)
    if self.shader:hasUniform("ColorHSV") then
        local h,s,v = colorhelper.unpackhsv(hsv)
        self.shader:sendColor("ColorHSV", {h,s,v})
    end
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.mesh)
    love.graphics.setShader()
end


return gradient