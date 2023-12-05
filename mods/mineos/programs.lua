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

local function __TS__ObjectEntries(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = {key, obj[key]}
    end
    return result
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local programFoundation = {}
    mineos.Program = __TS__Class()
    local Program = mineos.Program
    Program.name = "Program"
    function Program.prototype.____constructor(self, system, renderer)
        self.system = system
        self.renderer = renderer
    end
    function Program.prototype.main(self, delta)
    end
    local ____programFoundation_0 = programFoundation
    local BootProcedure = __TS__Class()
    BootProcedure.name = "BootProcedure"
    __TS__ClassExtends(BootProcedure, mineos.Program)
    function BootProcedure.prototype.____constructor(self, ...)
        BootProcedure.____super.prototype.____constructor(self, ...)
        self.memoryTest = 0
    end
    function BootProcedure.prototype.main(self, delta)
        self.memoryTest = self.memoryTest + delta
        print("booting! " .. tostring(self.memoryTest))
    end
    ____programFoundation_0.bootProcedure = BootProcedure
    minetest.register_on_mods_loaded(function()
        for ____, ____value in ipairs(__TS__ObjectEntries(programFoundation)) do
            local name = ____value[1]
            local clazz = ____value[2]
            mineos.getSystem():registerProgram(name, clazz)
        end
    end)
    function mineos.grabFoundationalPrograms()
        return programFoundation
    end
end
