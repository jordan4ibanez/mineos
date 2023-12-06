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
    local function sendStartMenuSignal(_)
        local system = mineos.getSystem()
        local currProg = system.currentProgram
        currProg.startMenuFlag = true
    end
    local RunProcedure = __TS__Class()
    RunProcedure.name = "RunProcedure"
    __TS__ClassExtends(RunProcedure, mineos.Program)
    function RunProcedure.prototype.____constructor(self, ...)
        RunProcedure.____super.prototype.____constructor(self, ...)
        self.desktopLoaded = false
        self.startMenuFlag = false
        self.startMenuOpened = false
        self.menuComponents = {_bitsBattle = "Bit's Battle", _fezSphere = "Fez Sphere", _gong = "Gong 96", _sledQuickly = "Sled Liberty"}
    end
    function RunProcedure.prototype.toggleStartMenu(self)
        if self.startMenuOpened then
            for ____, ____value in ipairs(__TS__ObjectEntries(self.menuComponents)) do
                local name = ____value[1]
                local progNameNice = ____value[2]
                self.renderer:removeComponent(name)
            end
            local background = self.renderer:getElement("background")
            background.position.x = 0
            self.renderer:removeComponent("backgroundDuctTape")
        else
            local background = self.renderer:getElement("background")
            background.position.x = 6.25
            self.renderer:addElement(
                "backgroundDuctTape",
                __TS__New(
                    gui.Box,
                    {
                        position = create2d(0, 0),
                        size = create2d(6.25, 5.5),
                        color = colorRGB(1, 130, 129)
                    }
                )
            )
            local i = 0
            for ____, ____value in ipairs(__TS__ObjectEntries(self.menuComponents)) do
                local name = ____value[1]
                local progNameNice = ____value[2]
                self.renderer:addElement(
                    name,
                    __TS__New(
                        gui.Button,
                        {
                            position = create2d(0, 6 + i * 2.5),
                            size = create2d(6.25, 1),
                            name = name,
                            label = progNameNice
                        }
                    )
                )
                i = i + 1
            end
        end
        self.startMenuOpened = not self.startMenuOpened
        self.startMenuFlag = false
        print("start clicked!")
    end
    function RunProcedure.prototype.loadDesktop(self)
        mineos.System.out:println("loading desktop environment")
        self.system:clearCallbacks()
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
                    position = create2d(2, self.renderer.frameBufferScale.y * 15.5),
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
        self.system:registerCallback("startButton", sendStartMenuSignal)
        self.desktopLoaded = true
        mineos.System.out:println("desktop environment loaded")
    end
    function RunProcedure.prototype.main(self, delta)
        if not self.desktopLoaded then
            self:loadDesktop()
        end
        if self.startMenuFlag then
            self:toggleStartMenu()
        end
    end
    mineos.System:registerProgram(RunProcedure)
end
