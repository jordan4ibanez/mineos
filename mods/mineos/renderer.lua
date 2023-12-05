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
    function Renderer.prototype.____constructor(self)
        self.buffer = ""
        self.memory = {}
        self.shouldDraw = true
        print("pushing the thing")
        self.memory.backgroundColor = __TS__New(
            BGColor,
            {
                bgColor = colors.colorScalar(100),
                fullScreen = "both",
                fullScreenbgColor = colors.colorScalar(0)
            }
        )
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
                size = create(100, 60),
                elements = {}
            }
        )
        local ____obj_elements_0 = obj.elements
        ____obj_elements_0[#____obj_elements_0 + 1] = self.memory.backgroundColor
        self.buffer = generate(obj)
        print(self.buffer)
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
