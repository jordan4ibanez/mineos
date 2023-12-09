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
    local create = vector.create2d
    local color = colors.color
    local colorRGB = colors.colorRGB
    local colorScalar = colors.colorScalar
    local RunProcedure = __TS__Class()
    RunProcedure.name = "RunProcedure"
    __TS__ClassExtends(RunProcedure, mineos.Program)
    function RunProcedure.prototype.____constructor(self, ...)
        RunProcedure.____super.prototype.____constructor(self, ...)
        self.desktopLoaded = false
        self.startMenuFlag = false
        self.startMenuOpened = false
        self.menuComponents = {BitsBattle = "Bit's Battle"}
    end
    function RunProcedure.prototype.toggleStartMenu(self)
        if self.startMenuOpened then
            self.renderer:setClearColor(0, 0, 0)
            for ____, ____value in ipairs(__TS__ObjectEntries(self.menuComponents)) do
                local name = ____value[1]
                local progNameNice = ____value[2]
                self.renderer:removeComponent(name)
            end
            self.renderer:removeComponent("backgroundDuctTape")
        else
            self.renderer:setClearColor(48, 48, 48)
            local i = 0
            for ____, ____value in ipairs(__TS__ObjectEntries(self.menuComponents)) do
                local name = ____value[1]
                local progNameNice = ____value[2]
                i = i + 1
            end
        end
        self.startMenuOpened = not self.startMenuOpened
        self.startMenuFlag = false
        print("start clicked!")
    end
    function RunProcedure.prototype.loadDesktop(self)
        mineos.System.out:println("loading desktop environment")
        self.audioController:playSound("osStartup", 0.9)
        self.renderer:clearMemory()
        self.renderer:setClearColor(0, 0, 0)
        self.renderer:setClearColor(0.39215686274, 50.9803921569, 50.5882352941)
        self.renderer:addElement(
            "taskbar",
            {
                name = "taskbar",
                hud_elem_type = HudElementType.image,
                position = create(0, 1),
                text = "task_bar.png",
                scale = create(1, 1),
                alignment = create(1, -1),
                offset = create(0, 0),
                z_index = -1
            }
        )
        self.renderer:addElement(
            "start_button",
            {
                name = "start_button",
                hud_elem_type = HudElementType.image,
                position = create(0, 1),
                text = "start_button.png",
                scale = create(1, 1),
                alignment = create(1, 1),
                offset = create(2, -29),
                z_index = 0
            }
        )
        self.desktopLoaded = true
        mineos.System.out:println("desktop environment loaded")
    end
    function RunProcedure.prototype.update(self)
        self.renderer:setElementComponentValue(
            "taskbar",
            "scale",
            create(self.renderer.frameBufferSize.x, 1)
        )
    end
    function RunProcedure.prototype.main(self, delta)
        if not self.desktopLoaded then
            self:loadDesktop()
        end
        if self.startMenuFlag then
            self:toggleStartMenu()
        end
        self.renderer:update()
        self:update()
    end
    mineos.System:registerProgram(RunProcedure)
end
