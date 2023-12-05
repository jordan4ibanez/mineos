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
        self.memory = {}
        self.shouldDraw = true
        print("hello I am a renderer")
    end
    function Renderer.prototype.getBuffer(self)
        return self.buffer
    end
    function Renderer.prototype.grabRef(self, name)
        return self.memory[name] or nil
    end
    function Renderer.prototype.update(self)
    end
    function Renderer.prototype.draw(self)
        self.shouldDraw = not self.shouldDraw
        if not self.shouldDraw then
            return
        end
        print("showing")
        minetest.show_formspec("singleplayer", "mineos", self.buffer)
    end
    print("renderer loaded.")
end
