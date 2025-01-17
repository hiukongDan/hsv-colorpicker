local colorhelper = require("colorhelper")
local ValueSelectionBox = require("valueselectionbox")
local helper = require("helper")
local gradient = require("gradient")
local hsvbox = require("hsvbox")
local colorbox = require("colorbox")
local observer = require("observer")
local infobox = require("infobox")
local palettelist = require("palettelist")

local insert = table.insert


function love.load()
	g_backgroundcolor = {r=32/255,g=48/255,b=38/255}
	g_hsv = {h=0.5, s=0.5, v=0.5}
	-- g_box = {x=10, y=10, w=500, h=500}

	g_observer = observer:new()

	-- gradient
	local gradientinit = {r=0,g=0,b=1}
	local box = {x=10, y=10, w=200, h=200}
	local gradient = gradient:newQuad(gradientinit, box)
	local hsvboxcallback =
		function(hsv)
			local _,s,v = colorhelper.unpackhsv(hsv)
			g_hsv.s, g_hsv.v = s, v
			g_observer:fire("saturation", s)
			g_observer:fire("value", v)
		end
	g_hsvbox = hsvbox:new(gradient, box, hsvboxcallback)
	g_observer:subscribe("hue", function(h) g_hsv.h = h end)
	g_observer:subscribe("saturation",
		function(s)
			local x, y = g_hsvbox.bound.x, g_hsvbox.bound.x + g_hsvbox.bound.w
			g_hsvbox.cursor.x = helper.remap(s, 0, 1, x, y)
		end	
	)
	g_observer:subscribe("value",
		function(v)
			local x, y = g_hsvbox.bound.y, g_hsvbox.bound.y + g_hsvbox.bound.h
			g_hsvbox.cursor.y = helper.remap(v, 1, 0, x, y)
		end	
	)
	

	-- color box
	g_colorbox = colorbox:new({x=10, y=220, w=200, h=50}, g_hsv)

	
	-- hue
	local huebound = {x=10, y=280, w=200, h=50}
	local huebox = gradient:newQuad({r=1, g=0, b=0}, huebound, gradient._default.uvs.linear, "shaders/hue.glsl")
	local onhuevaluechanged =
		function(value)
			g_hsv.h = value
			g_observer:fire("hue", value)
		end
	g_huebox = ValueSelectionBox:new(huebound, 0, 1, true, true, onhuevaluechanged)
	g_huebox.drawcallback = function()
		huebox:draw()
	end
	g_observer:subscribe("hue",
		function(h)
			local x, y = g_huebox.bound.x, g_huebox.bound.x + g_huebox.bound.w
			g_huebox.cursor.x = helper.remap(h, 0, 1, x, y)
		end
	)
	


	-- saturation
	local saturationbound = {x=10, y=340, w=200, h=50}
	g_saturation = gradient:newQuad({r=1, g=0, b=0}, saturationbound, gradient._default.uvs.linear, "shaders/saturation.glsl")
	local onsaturationcallback = 
		function(value)
			g_hsv.s = value
			g_observer:fire("saturation", value)
		end
	g_saturationbox = ValueSelectionBox:new(saturationbound, 0, 1, true, true, onsaturationcallback)
	g_saturationbox.drawcallback = function()
		g_saturation:draw(g_hsv)
	end
	g_observer:subscribe("saturation",
		function(s)
			local x, y = g_saturationbox.bound.x, g_saturationbox.bound.x + g_saturationbox.bound.w
			g_saturationbox.cursor.x = helper.remap(s, 0, 1, x, y)
		end
	)


	-- value
	local valuebound = {x=10, y=400, w=200, h=50}
	g_valuegradient = gradient:newQuad({r=1, g=0, b=0}, valuebound, gradient._default.uvs.linear, "shaders/value.glsl")
	local onvaluecallback = 
		function(value)
			g_hsv.v = value
			g_observer:fire("value", value)
		end
	g_valuebox = ValueSelectionBox:new(valuebound, 0, 1, true, true, onvaluecallback)
	g_valuebox.drawcallback = function()
		g_valuegradient:draw(g_hsv)
	end
	g_observer:subscribe("value",
		function(v)
			local x, y = g_valuebox.bound.x, g_valuebox.bound.x + g_valuebox.bound.w
			g_valuebox.cursor.x = helper.remap(v, 0, 1, x, y)
		end	
	)

	
	-- information
	-- hsv 01
	g_info01 = infobox:new(colorhelper.hsvtostring(g_hsv), {x=10, y=460, w=200, h=20})
	local info01callback = function(v) g_info01.text = colorhelper.hsvtostring(g_hsv) end
	g_observer:subscribe("hue",info01callback)
	g_observer:subscribe("saturation",info01callback)
	g_observer:subscribe("value",info01callback)
	-- hsv 255
	g_info255 = infobox:new(colorhelper.hsvto255string(g_hsv), {x=10, y=490, w=200, h=20})
	local info255callback = function(v) g_info255.text = colorhelper.hsvto255string(g_hsv) end
	g_observer:subscribe("hue",info255callback)
	g_observer:subscribe("saturation",info255callback)
	g_observer:subscribe("value",info255callback)
	-- rgb 01
	g_inforgb01 = infobox:new(colorhelper.hsvtorgbstring(g_hsv), {x=10, y=520, w=200, h=20})
	local inforgb01callback = function(v) g_inforgb01.text = colorhelper.hsvtorgbstring(g_hsv) end
	g_observer:subscribe("hue",inforgb01callback)
	g_observer:subscribe("saturation",inforgb01callback)
	g_observer:subscribe("value",inforgb01callback)
	-- rgb 255
	g_inforgb255 = infobox:new(colorhelper.hsvtorgb255string(g_hsv), {x=10, y=550, w=200, h=20})
	local inforgb255callback = function(v) g_inforgb255.text = colorhelper.hsvtorgb255string(g_hsv) end
	g_observer:subscribe("hue",inforgb255callback)
	g_observer:subscribe("saturation",inforgb255callback)
	g_observer:subscribe("value",inforgb255callback)

	g_infolist = {}
	insert(g_infolist, g_info01)
	insert(g_infolist, g_info255)
	insert(g_infolist, g_inforgb01)
	insert(g_infolist, g_inforgb255)
	
	
	-- palettelist
	g_palettelist = palettelist:new(19, {x=220, y=10, w=20, h=560})
	g_palettelist.onselectslot =
		function()
			g_hsv.h,g_hsv.s, g_hsv.v = g_palettelist:currentHSV()
			g_observer:fire("hue", g_hsv.h)
			g_observer:fire("saturation", g_hsv.s)
			g_observer:fire("value", g_hsv.v)
		end
	local palettecallback = function(v) g_palettelist:onhsvchange(g_hsv) end
	g_observer:subscribe("hue", palettecallback)
	g_observer:subscribe("saturation", palettecallback)
	g_observer:subscribe("value", palettecallback)

end


function love.update(dt)
	-- g_hsv.h = (g_hsv.h + dt * 0.1) % 1

	g_huebox:update(dt)
	g_saturationbox:update(dt)
	for i = 1, #g_infolist do
		g_infolist[i]:update(dt)
	end
end



function love.draw()
	-- background color
	love.graphics.clear(colorhelper.unpackrgb(g_backgroundcolor))
	
	-- gradient
	g_hsvbox:draw(g_hsv)

	-- current color
	g_colorbox:draw(g_hsv)

	-- hue
	g_huebox:draw()

	-- saturation 
	g_saturationbox:draw()

	-- value
	g_valuebox:draw()

	-- information
	for i = 1, #g_infolist do
		g_infolist[i]:draw()
	end

	-- palette list
	g_palettelist:draw()
end


function love.mousepressed(x, y, btn)
	g_hsvbox:onmousepressed(x,y,btn)
	g_saturationbox:onmousepressed(x,y,btn)
	g_huebox:onmousepressed(x,y,btn)
	g_valuebox:onmousepressed(x,y,btn)

	for i = 1, #g_infolist do
		g_infolist[i]:onmousepressed(x,y,btn)
	end

	g_palettelist:onmousepressed(x,y,btn)

end


function love.mousereleased(x, y, btn)
	g_hsvbox:onmousereleased(x,y,btn)
	g_saturationbox:onmousereleased(x,y,btn)
	g_huebox:onmousereleased(x,y,btn)
	g_valuebox:onmousereleased(x,y,btn)
end


function love.mousemoved(x, y, dx, dy)
	g_hsvbox:onmousemoved(x,y,dx,dy)
	g_saturationbox:onmousemoved(x,y, dx,dy)
	g_huebox:onmousemoved(x,y,dx,dy)
	g_valuebox:onmousemoved(x,y,dx,dy)
end


function love.keypressed(key, scancode, isrepeat)

	-- quit
	if (love.keyboard.isDown("lctrl") and scancode == 'c') then
		love.event.push('quit')
	end

	--Debug
	if love.keyboard.isDown("lctrl") and scancode == '`' then --set to whatever key you want to use
		debug.debug()
	end

end

