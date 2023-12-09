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
    local create = vector.create2d
    local color = colors.color
    local colorRGB = colors.colorRGB
    local colorScalar = colors.colorScalar
    local AABB = __TS__Class()
    AABB.name = "AABB"
    function AABB.prototype.____constructor(self, offset, size, anchor)
        self.offset = offset
        self.size = size
        self.anchor = anchor
    end
    function AABB.prototype.pointWithin(self, point)
        local windowSize = mineos.getSystem():getRenderer().frameBufferSize
        local pos = create(self.anchor.x * windowSize.x + self.offset.x, self.anchor.y * windowSize.y + self.offset.y)
        return point.x > pos.x and point.x < pos.x + self.size.x and point.y > pos.y and point.y < pos.y + self.size.y
    end
    local Focus = __TS__Class()
    Focus.name = "Focus"
    function Focus.prototype.____constructor(self, name)
        self.name = name
    end
    local RunProcedure = __TS__Class()
    RunProcedure.name = "RunProcedure"
    __TS__ClassExtends(RunProcedure, mineos.Program)
    function RunProcedure.prototype.____constructor(self, system, renderer, audio)
        RunProcedure.____super.prototype.____constructor(self, system, renderer, audio)
        self.desktopLoaded = false
        self.startMenuFlag = false
        self.startMenuOpened = false
        self.oldFrameBufferSize = create(0, 0)
        self.mousePosition = create(0, 0)
        self.focused = true
        self.menuComponents = {BitsBattle = "Bit's Battle"}
        self.acceleration = 250
    end
    function RunProcedure.prototype.toggleStartMenu(self)
        if self.startMenuOpened then
            for ____, ____value in ipairs(__TS__ObjectEntries(self.menuComponents)) do
                local name = ____value[1]
                local progNameNice = ____value[2]
                self.renderer:removeComponent(name)
            end
        else
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
    function RunProcedure.prototype.getTimeString(self)
        local hour = tostring(tonumber(os.date(
            "%I",
            os.time()
        )))
        return hour .. os.date(
            ":%M %p",
            os.time()
        )
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
                z_index = -3
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
                z_index = -2
            }
        )
        self.renderer:addElement(
            "time_box",
            {
                name = "time_box",
                hud_elem_type = HudElementType.image,
                position = create(1, 1),
                text = "time_box.png",
                scale = create(1, 1),
                alignment = create(-1, 1),
                offset = create(-2, -29),
                z_index = -1
            }
        )
        self.renderer:addElement(
            "time",
            {
                name = "time",
                hud_elem_type = HudElementType.text,
                scale = create(1, 1),
                text = self:getTimeString(),
                number = colors.colorHEX(0, 0, 0),
                position = create(1, 1),
                alignment = create(0, -1),
                offset = create(-42, -5),
                z_index = 0
            }
        )
        self.renderer:addElement(
            "mouse",
            {
                name = "mouse",
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = "mouse.png",
                scale = create(1, 1),
                alignment = create(1, 1),
                offset = create(0, 0),
                z_index = 10000
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
        local screenSize = self.renderer.frameBufferSize
        local mouseDelta = self.system:getMouseDelta()
        local ____self_mousePosition_0, ____x_1 = self.mousePosition, "x"
        ____self_mousePosition_0[____x_1] = ____self_mousePosition_0[____x_1] + mouseDelta.x * self.acceleration
        local ____self_mousePosition_2, ____y_3 = self.mousePosition, "y"
        ____self_mousePosition_2[____y_3] = ____self_mousePosition_2[____y_3] + mouseDelta.y * self.acceleration
        if self.mousePosition.x >= screenSize.x then
            self.mousePosition.x = screenSize.x
        elseif self.mousePosition.x < 0 then
            self.mousePosition.x = 0
        end
        if self.mousePosition.y >= screenSize.y then
            self.mousePosition.y = screenSize.y
        elseif self.mousePosition.y < 0 then
            self.mousePosition.y = 0
        end
        if self.oldFrameBufferSize.x ~= screenSize.x or self.oldFrameBufferSize.y ~= screenSize.y then
            print("updating fbuffer for desktop")
            self.mousePosition = create(screenSize.x / 2, screenSize.y / 2)
            print(dump(self.mousePosition))
            self.oldFrameBufferSize = screenSize
        end
        local finalizedMousePos = create(self.mousePosition.x - 1, self.mousePosition.y - 1)
        self.renderer:setElementComponentValue("mouse", "offset", finalizedMousePos)
        local startMenuAABB = __TS__New(
            AABB,
            create(0, -32),
            create(66, 32),
            create(0, 1)
        )
        if startMenuAABB:pointWithin(self.mousePosition) then
            print("mouse is in " .. tostring(math.random()))
        end
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
        self:getTimeString()
    end
    mineos.System:registerProgram(RunProcedure)
end
