-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local Renderer = __TS__Class()
    Renderer.name = "Renderer"
    function Renderer.prototype.____constructor(self)
        print("hello I am a renderer")
    end
    __TS__New(Renderer)
    print("renderer loaded.")
end
