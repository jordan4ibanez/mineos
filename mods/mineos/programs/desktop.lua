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
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local RunProcedure = __TS__Class()
    RunProcedure.name = "RunProcedure"
    __TS__ClassExtends(RunProcedure, mineos.Program)
    function RunProcedure.prototype.____constructor(self, ...)
        RunProcedure.____super.prototype.____constructor(self, ...)
        self.loadedDesktop = false
    end
    function RunProcedure.prototype.loadDesktop(self)
        mineos.System.out:println("loading desktop environment")
        mineos.System.out:println("hi there", "I'm java")
        mineos.System.out:println("desktop environment loaded")
    end
    function RunProcedure.prototype.main(self, delta)
        if not self.loadedDesktop then
            self:loadDesktop()
        end
    end
    mineos.System:registerProgram(RunProcedure)
end
