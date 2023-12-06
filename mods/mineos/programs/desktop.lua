-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create
    local create2d = vector.create2d
    local color = colors.color
    local colorRGB = colors.colorRGB
    local colorScalar = colors.colorScalar
    local RunProcedure = __TS__Class()
    RunProcedure.name = "RunProcedure"
    __TS__ClassExtends(RunProcedure, mineos.Program)
    function RunProcedure.prototype.____constructor(self, ...)
        RunProcedure.____super.prototype.____constructor(self, ...)
        self.desktopLoaded = false
    end
    function RunProcedure.prototype.loadDesktop(self)
        mineos.System.out:println("loading desktop environment")
        self.renderer:setClearColor(0, 0, 0)
        self.renderer:addElement(
            "background",
            __TS__New(
                gui.Box,
                {
                    position = create2d(0, 0),
                    size = create2d(4000, 15.5),
                    color = colorRGB(1, 130, 129)
                }
            )
        )
        self.renderer:addElement(
            "menuBar",
            __TS__New(
                gui.Box,
                {
                    position = create2d(0, self.renderer.frameBufferScale.y * 15.5),
                    size = create2d(4000, 1),
                    color = colorScalar(70)
                }
            )
        )
        self.renderer:addElement(
            "startButton",
            __TS__New(
                gui.Button,
                {
                    position = create2d(0, 15.5),
                    size = create2d(2, 1),
                    name = "startButton",
                    label = "Start"
                }
            )
        )
        self.desktopLoaded = true
        mineos.System.out:println("desktop environment loaded")
    end
    function RunProcedure.prototype.main(self, delta)
        if not self.desktopLoaded then
            self:loadDesktop()
        end
    end
    mineos.System:registerProgram(RunProcedure)
end
