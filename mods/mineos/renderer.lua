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
    local create = vector.create2d
    mineos.Renderer = __TS__Class()
    local Renderer = mineos.Renderer
    Renderer.name = "Renderer"
    function Renderer.prototype.____constructor(self, system)
        self.clearColor = vector.create(0, 0, 0)
        self.shouldDraw = true
        self.frameBufferSize = create(0, 0)
        self.frameBufferScale = 1
        self.system = system
    end
    function Renderer.prototype.clearMemory(self)
    end
    function Renderer.prototype.removeComponent(self, name)
    end
    function Renderer.prototype.internalUpdateClearColor(self)
    end
    function Renderer.prototype.setClearColor(self, r, g, b)
        self.clearColor.x = r
        self.clearColor.y = g
        self.clearColor.z = b
        self:internalUpdateClearColor()
    end
    print("renderer loaded.")
end
