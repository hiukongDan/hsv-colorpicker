local insert = table.insert
local remove = table.remove

local observer = {}
observer.__index = observer


-- @summary instantiate a new observer table
function observer:new()
    local obj = {}
    setmetatable(obj, observer)

    obj.list = {}
    obj.list.default = {}

    return obj
end


-- @summary subscribe to the event
-- @param func function subscribed to the event
-- @param event name, default is default
function observer:subscribe(event, func)
    event = event or "default"
    if self.list[event] == nil then self.list[event] = {} end
    insert(self.list[event], func)
end


-- @summary unsubscribed to the event
-- @param func function unsubscribed to the event
-- @param event name, default is default
function observer:unsubscribe(event, func)
    event = event or "default"
    if self.list[event] == nil then return end
    local index = -1
    for i in 1, #self.list[event] do
        if self.list[event][i] == func then
            index = i
        end
    end
    if index ~= -1 then remove(self.list[event], index) end
end


-- @summary fire the event with parameters, by calling func(...)
-- @param event event name, default is default
function observer:fire(event, ...)
    event = event or "default"
    if self.list[event] == nil then return end
    for i = 1, #self.list[event] do
        self.list[event][i](...)
    end
end


return observer