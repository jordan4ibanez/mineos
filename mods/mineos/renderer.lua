-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    mineos.Renderer = __TS__Class()
    local Renderer = mineos.Renderer
    Renderer.name = "Renderer"
    function Renderer.prototype.____constructor(self)
        self.buffer = ""
        print("hello I am a renderer")
    end
    function Renderer.prototype.getBuffer(self)
        return self.buffer
    end
    print("renderer loaded.")
end
