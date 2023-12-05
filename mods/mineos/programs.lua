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
    function Program.prototype.____constructor(self, system, renderer, audioController)
        self.iMem = 0
        self.system = system
        self.renderer = renderer
        self.audioController = audioController
    end
    function Program.prototype.main(self, delta)
    end
    local ____programFoundation_0 = programFoundation
    local BiosProcedure = __TS__Class()
    BiosProcedure.name = "BiosProcedure"
    __TS__ClassExtends(BiosProcedure, mineos.Program)
    function BiosProcedure.prototype.____constructor(self, ...)
        BiosProcedure.____super.prototype.____constructor(self, ...)
        self.timer = 0
        self.stateTimer = 0
        self.state = 0
        self.increments = 0.2
        self.memoryCounter = 0
    end
    function BiosProcedure.prototype.main(self, delta)
        if self.timer == 0 then
            print("bios started")
        end
        self.timer = self.timer + delta
        self.stateTimer = self.stateTimer + delta
        if self.state == 7 then
            self.stateTimer = -1
            local memCheck = self.renderer:getElement("memCheckProgress")
            print(dump(memCheck))
            self.memoryCounter = self.memoryCounter + (10 + math.floor(math.random() * 10))
            memCheck.label = tostring(self.memoryCounter) .. " KB"
            if self.memoryCounter >= 4096 then
                memCheck.label = tostring(4096) .. " KB"
                self.stateTimer = 10
            end
        end
        if self.stateTimer > self.increments then
            repeat
                local ____switch10 = self.state
                local ____cond10 = ____switch10 == 5
                if ____cond10 then
                    do
                        self.audioController:playSound("computerBeep", 1)
                        self.renderer:addElement(
                            "bioLogo",
                            __TS__New(
                                gui.Image,
                                {
                                    position = vector.create2d(0.5, 0.9),
                                    size = vector.create2d(2, 2),
                                    texture = "minetest.png"
                                }
                            )
                        )
                        self.renderer:addElement(
                            "biosText",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(3, 2),
                                    label = mineos.colorize(
                                        colors.color(100, 0, 0),
                                        "Minetest Megablocks"
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond10 = ____cond10 or ____switch10 == 6
                if ____cond10 then
                    do
                        self.renderer:addElement(
                            "memCheck",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(0.5, 5),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "Total Memory:"
                                    )
                                }
                            )
                        )
                        self.renderer:addElement(
                            "memCheckProgress",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(3.2, 5),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "0 KB"
                                    )
                                }
                            )
                        )
                        break
                    end
                end
            until true
            print(self.state)
            self.state = self.state + 1
            self.stateTimer = self.stateTimer - self.increments
        end
    end
    ____programFoundation_0.biosProcedure = BiosProcedure
    local ____programFoundation_1 = programFoundation
    local BootProcedure = __TS__Class()
    BootProcedure.name = "BootProcedure"
    __TS__ClassExtends(BootProcedure, mineos.Program)
    function BootProcedure.prototype.____constructor(self, ...)
        BootProcedure.____super.prototype.____constructor(self, ...)
        self.timer = 0
        self.color = 0
    end
    function BootProcedure.prototype.main(self, delta)
        self.timer = self.timer + delta
        if self.color < 45 then
            self.color = self.color + delta
            if self.color >= 45 then
                self.color = 45
            end
            self.renderer:setClearColor(self.color, self.color, self.color)
        end
    end
    ____programFoundation_1.bootProcedure = BootProcedure
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
