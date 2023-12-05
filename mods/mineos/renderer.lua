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
    local create = vector.create2d
    local generate = gui.generate
    local FormSpec = gui.FormSpec
    local BackGround = gui.Background
    local BGColor = gui.BGColor
    local List = gui.List
    local ListColors = gui.ListColors
    local ListRing = gui.ListRing
    mineos.Renderer = __TS__Class()
    local Renderer = mineos.Renderer
    Renderer.name = "Renderer"
    function Renderer.prototype.____constructor(self, system)
        self.buffer = ""
        self.clearColor = vector.create(0, 0, 0)
        self.memory = {}
        self.shouldDraw = true
        self.frameBufferSize = create(0, 0)
        self.frameBufferScale = create(0, 0)
        self.system = system
        self.memory.backgroundColor = __TS__New(
            BGColor,
            {
                bgColor = colors.color(self.clearColor.x, self.clearColor.y, self.clearColor.z),
                fullScreen = "both",
                fullScreenbgColor = colors.colorScalar(50)
            }
        )
    end
    function Renderer.prototype.setClearColor(self, r, g, b)
        self.clearColor.x = r
        self.clearColor.y = g
        self.clearColor.z = b
    end
    function Renderer.prototype.getBuffer(self)
        return self.buffer
    end
    function Renderer.prototype.grabRef(self, name)
        return self.memory[name] or nil
    end
    function Renderer.prototype.finalizeBuffer(self)
        local obj = __TS__New(
            FormSpec,
            {
                size = self.frameBufferScale,
                padding = create(-0.01, -0.01),
                elements = {}
            }
        )
        local ____obj_elements_0 = obj.elements
        ____obj_elements_0[#____obj_elements_0 + 1] = self.memory.backgroundColor
        self.buffer = generate(obj)
    end
    function Renderer.prototype.update(self)
        self:finalizeBuffer()
    end
    function Renderer.prototype.draw(self)
        self.shouldDraw = not self.shouldDraw
        if not self.shouldDraw then
            return
        end
        self:update()
        minetest.show_formspec("singleplayer", "mineos", self.buffer)
    end
    print("renderer loaded.")
end
