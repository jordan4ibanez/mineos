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

local function __TS__StringIncludes(self, searchString, position)
    if not position then
        position = 1
    else
        position = position + 1
    end
    local index = string.find(self, searchString, position, true)
    return index ~= nil
end

local Error, RangeError, ReferenceError, SyntaxError, TypeError, URIError
do
    local function getErrorStack(self, constructor)
        if debug == nil then
            return nil
        end
        local level = 1
        while true do
            local info = debug.getinfo(level, "f")
            level = level + 1
            if not info then
                level = 1
                break
            elseif info.func == constructor then
                break
            end
        end
        if __TS__StringIncludes(_VERSION, "Lua 5.0") then
            return debug.traceback(("[Level " .. tostring(level)) .. "]")
        else
            return debug.traceback(nil, level)
        end
    end
    local function wrapErrorToString(self, getDescription)
        return function(self)
            local description = getDescription(self)
            local caller = debug.getinfo(3, "f")
            local isClassicLua = __TS__StringIncludes(_VERSION, "Lua 5.0") or _VERSION == "Lua 5.1"
            if isClassicLua or caller and caller.func ~= error then
                return description
            else
                return (description .. "\n") .. tostring(self.stack)
            end
        end
    end
    local function initErrorClass(self, Type, name)
        Type.name = name
        return setmetatable(
            Type,
            {__call = function(____, _self, message) return __TS__New(Type, message) end}
        )
    end
    local ____initErrorClass_1 = initErrorClass
    local ____class_0 = __TS__Class()
    ____class_0.name = ""
    function ____class_0.prototype.____constructor(self, message)
        if message == nil then
            message = ""
        end
        self.message = message
        self.name = "Error"
        self.stack = getErrorStack(nil, self.constructor.new)
        local metatable = getmetatable(self)
        if metatable and not metatable.__errorToStringPatched then
            metatable.__errorToStringPatched = true
            metatable.__tostring = wrapErrorToString(nil, metatable.__tostring)
        end
    end
    function ____class_0.prototype.__tostring(self)
        return self.message ~= "" and (self.name .. ": ") .. self.message or self.name
    end
    Error = ____initErrorClass_1(nil, ____class_0, "Error")
    local function createErrorClass(self, name)
        local ____initErrorClass_3 = initErrorClass
        local ____class_2 = __TS__Class()
        ____class_2.name = ____class_2.name
        __TS__ClassExtends(____class_2, Error)
        function ____class_2.prototype.____constructor(self, ...)
            ____class_2.____super.prototype.____constructor(self, ...)
            self.name = name
        end
        return ____initErrorClass_3(nil, ____class_2, name)
    end
    RangeError = createErrorClass(nil, "RangeError")
    ReferenceError = createErrorClass(nil, "ReferenceError")
    SyntaxError = createErrorClass(nil, "SyntaxError")
    TypeError = createErrorClass(nil, "TypeError")
    URIError = createErrorClass(nil, "URIError")
end

local function __TS__ObjectGetOwnPropertyDescriptors(object)
    local metatable = getmetatable(object)
    if not metatable then
        return {}
    end
    return rawget(metatable, "_descriptors") or ({})
end

local function __TS__Delete(target, key)
    local descriptors = __TS__ObjectGetOwnPropertyDescriptors(target)
    local descriptor = descriptors[key]
    if descriptor then
        if not descriptor.configurable then
            error(
                __TS__New(
                    TypeError,
                    ((("Cannot delete property " .. tostring(key)) .. " of ") .. tostring(target)) .. "."
                ),
                0
            )
        end
        descriptors[key] = nil
        return true
    end
    target[key] = nil
    return true
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create2d
    local color = colors.color
    local colorRGB = colors.colorRGB
    local colorScalar = colors.colorScalar
    mineos.AABB = __TS__Class()
    local AABB = mineos.AABB
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
    local DesktopComponent = __TS__Class()
    DesktopComponent.name = "DesktopComponent"
    function DesktopComponent.prototype.____constructor(self, cbox, onClick, onHold)
        self.collisionBox = cbox
        self.onClick = onClick
        self.onHold = onHold
    end
    function DesktopComponent.prototype.onClick(self, desktop)
    end
    function DesktopComponent.prototype.onHold(self, desktop)
    end
    local Icon = __TS__Class()
    Icon.name = "Icon"
    function Icon.prototype.____constructor(self, name, cbox, texture)
        self.name = name
        self.collisionBox = cbox
        self.texture = texture
    end
    local DesktopIcons = __TS__Class()
    DesktopIcons.name = "DesktopIcons"
    __TS__ClassExtends(DesktopIcons, mineos.Program)
    function DesktopIcons.prototype.____constructor(self, system, renderer, audio, runProc)
        DesktopIcons.____super.prototype.____constructor(self, system, renderer, audio)
        self.icons = {}
        self.currentIcon = nil
        self.payload = false
        self.yOffset = 0
        self.desktop = runProc
        self:addIcon("trashIcon", "trash_icon.png")
        self:addIcon("emailIcon", "email_icon.png")
        self:addIcon("internetIcon", "internet_icon.png")
    end
    function DesktopIcons.prototype.addIcon(self, iconName, iconTexture)
        local icon = __TS__New(
            Icon,
            iconName,
            __TS__New(
                mineos.AABB,
                create(0, self.yOffset),
                create(40, 40),
                create(0, 0)
            ),
            iconTexture
        )
        self.renderer:addElement(
            iconName,
            {
                name = iconName,
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = icon.texture,
                scale = create(1, 1),
                alignment = create(1, 1),
                offset = icon.collisionBox.offset,
                z_index = 0
            }
        )
        self.icons[iconName] = icon
        self.yOffset = self.yOffset + 40
    end
    function DesktopIcons.prototype.corral(self)
        local windowSize = self.renderer.frameBufferSize
        if windowSize.x < 100 or windowSize.y < 100 then
            return
        end
        local limit = create(windowSize.x - 32, windowSize.y - 64)
        for ____, ____value in ipairs(__TS__ObjectEntries(self.icons)) do
            local name = ____value[1]
            local icon = ____value[2]
            local offset = icon.collisionBox.offset
            if offset.x > limit.x then
                offset.x = limit.x
            end
            if offset.y > limit.y then
                offset.y = limit.y
            end
            self.renderer:setElementComponentValue(name, "offset", offset)
        end
    end
    function DesktopIcons.prototype.load(self)
        print("loading desktop icons.")
        self.payload = true
        print("desktop icons loaded.")
    end
    function DesktopIcons.prototype.main(self, delta)
        if not self.payload then
            self:load()
        end
        local mousePos = self.desktop:getMousePos()
        local windowSize = self.renderer.frameBufferSize
        if self.currentIcon == nil then
            if self.system:isMouseClicked() and self.desktop.grabbedProgram == nil then
                for ____, ____value in ipairs(__TS__ObjectEntries(self.icons)) do
                    local name = ____value[1]
                    local icon = ____value[2]
                    if icon.collisionBox:pointWithin(mousePos) then
                        self.currentIcon = icon
                        break
                    end
                end
            end
        else
            if self.system:isMouseDown() then
                self.currentIcon.collisionBox.offset.x = mousePos.x - 20
                self.currentIcon.collisionBox.offset.y = mousePos.y - 20
                if self.currentIcon.collisionBox.offset.y > windowSize.y - 64 then
                    self.currentIcon.collisionBox.offset.y = windowSize.y - 64
                end
                self.renderer:setElementComponentValue(self.currentIcon.name, "offset", self.currentIcon.collisionBox.offset)
            else
                self.currentIcon = nil
            end
        end
    end
    local StartMenuEntry = __TS__Class()
    StartMenuEntry.name = "StartMenuEntry"
    function StartMenuEntry.prototype.____constructor(self, name, program, text, icon, yOffset)
        self.name = name
        self.program = program
        self.text = text
        self.collisionBox = __TS__New(
            mineos.AABB,
            create(1, yOffset or StartMenuEntry.yOffset),
            create(198, 32),
            create(0, 1)
        )
        self.icon = icon
        StartMenuEntry.yOffset = StartMenuEntry.yOffset + 33
    end
    StartMenuEntry.yOffset = -32 * 10 - 10
    local StartMenu = __TS__Class()
    StartMenu.name = "StartMenu"
    __TS__ClassExtends(StartMenu, mineos.Program)
    function StartMenu.prototype.____constructor(self, system, renderer, audio, desktop)
        StartMenu.____super.prototype.____constructor(self, system, renderer, audio)
        self.shown = false
        self.menuEntries = {}
        self.desktop = desktop
        self:load()
    end
    function StartMenu.prototype.load(self)
        self.renderer:addElement(
            "startMenu",
            {
                name = "startMenu",
                hud_elem_type = HudElementType.image,
                position = create(0, 1),
                text = "start_menu.png",
                scale = create(1, 1),
                alignment = create(1, 1),
                offset = create(-210, -332),
                z_index = -3
            }
        )
        local ____self_menuEntries_0 = self.menuEntries
        ____self_menuEntries_0[#____self_menuEntries_0 + 1] = __TS__New(
            StartMenuEntry,
            "boom",
            "Boom",
            "Boom",
            "minetest.png"
        )
        local ____self_menuEntries_1 = self.menuEntries
        ____self_menuEntries_1[#____self_menuEntries_1 + 1] = __TS__New(
            StartMenuEntry,
            "bitsBattle",
            "BitsBattle",
            "Bit's Battle",
            "minetest.png"
        )
        local ____self_menuEntries_2 = self.menuEntries
        ____self_menuEntries_2[#____self_menuEntries_2 + 1] = __TS__New(
            StartMenuEntry,
            "fezSphere",
            "FezSphere",
            "Fez Sphere",
            "minetest.png"
        )
        local ____self_menuEntries_3 = self.menuEntries
        ____self_menuEntries_3[#____self_menuEntries_3 + 1] = __TS__New(
            StartMenuEntry,
            "gong",
            "Gong",
            "Gong",
            "minetest.png"
        )
        local ____self_menuEntries_4 = self.menuEntries
        ____self_menuEntries_4[#____self_menuEntries_4 + 1] = __TS__New(
            StartMenuEntry,
            "sledLiberty",
            "SledLiberty",
            "Sled Liberty",
            "minetest.png"
        )
        local ____self_menuEntries_5 = self.menuEntries
        ____self_menuEntries_5[#____self_menuEntries_5 + 1] = __TS__New(
            StartMenuEntry,
            "shutDown",
            "",
            "Shut Down...",
            "minetest.png",
            -65
        )
        for ____, entry in ipairs(self.menuEntries) do
            local offset = entry.collisionBox.offset
            self.renderer:addElement(
                entry.name,
                {
                    name = entry.name,
                    hud_elem_type = HudElementType.image,
                    position = entry.collisionBox.anchor,
                    text = "start_menu_element.png",
                    scale = create(1, 1),
                    alignment = create(1, 1),
                    offset = create(-200, offset.y),
                    z_index = -2
                }
            )
            self.renderer:addElement(
                entry.name .. "text",
                {
                    name = "time",
                    hud_elem_type = HudElementType.text,
                    scale = create(1, 1),
                    text = entry.text,
                    number = colors.colorHEX(0, 0, 0),
                    position = entry.collisionBox.anchor,
                    alignment = create(1, 0),
                    offset = create(-240, offset.y + 16),
                    z_index = -1
                }
            )
        end
    end
    function StartMenu.prototype.trigger(self)
        self.shown = not self.shown
        if self.shown then
            self.renderer:setElementComponentValue(
                "startMenu",
                "offset",
                create(0, -332)
            )
            for ____, entry in ipairs(self.menuEntries) do
                local offset = entry.collisionBox.offset
                self.renderer:setElementComponentValue(
                    entry.name,
                    "offset",
                    create(1, offset.y)
                )
                self.renderer:setElementComponentValue(
                    entry.name .. "text",
                    "offset",
                    create(40, offset.y + 16)
                )
            end
        else
            self.renderer:setElementComponentValue(
                "startMenu",
                "offset",
                create(-210, -332)
            )
            for ____, entry in ipairs(self.menuEntries) do
                local offset = entry.collisionBox.offset
                self.renderer:setElementComponentValue(
                    entry.name,
                    "offset",
                    create(-200, offset.y)
                )
                self.renderer:setElementComponentValue(
                    entry.name .. "text",
                    "offset",
                    create(-241, offset.y)
                )
            end
        end
    end
    function StartMenu.prototype.main(self, delta)
        if not self.shown then
            return
        end
        if not self.system:isMouseClicked() then
            return
        end
        local mousePos = self.desktop:getMousePos()
        for ____, element in ipairs(self.menuEntries) do
            do
                if not element.collisionBox:pointWithin(mousePos) then
                    goto __continue44
                end
                if element.name == "shutDown" then
                    print("System shutting down...")
                    self.system:requestShutdown()
                else
                    print("Launching program " .. element.program)
                    self.desktop:launchProgram(
                        element.program,
                        create(540, 480)
                    )
                end
                self:trigger()
                break
            end
            ::__continue44::
        end
    end
    local programQueue = {}
    --- Base layer for the decoration is 0 to 1, don't draw into this.
    local handleHeight = 24
    local buttonSize = handleHeight - 1
    mineos.WindowProgram = __TS__Class()
    local WindowProgram = mineos.WindowProgram
    WindowProgram.name = "WindowProgram"
    __TS__ClassExtends(WindowProgram, mineos.Program)
    function WindowProgram.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
        WindowProgram.____super.prototype.____constructor(self, system, renderer, audio)
        self.windowPosition = create(100, 100)
        self.offset = create(0, 0)
        self.desktop = desktop
        self.windowSize = windowSize
        self.uuid = mineos.uuid()
        self.handle = __TS__New(
            mineos.AABB,
            create(self.windowPosition.x, self.windowPosition.y - handleHeight + 1),
            create(self.windowSize.x, handleHeight),
            create(0, 0)
        )
        local stringID = self.uuid .. "window_handle"
        self.renderer:addElement(
            stringID,
            {
                name = stringID,
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. color(50, 50, 50)) .. ":255",
                scale = self.handle.size,
                alignment = create(1, 1),
                offset = self.handle.offset,
                z_index = 0
            }
        )
        self.windowTitle = "a test title"
        local stringIDTitle = self.uuid .. "window_name"
        self.renderer:addElement(
            stringIDTitle,
            {
                name = stringIDTitle,
                hud_elem_type = HudElementType.text,
                scale = create(1, 1),
                text = self.windowTitle,
                number = colors.colorHEX(0, 0, 0),
                position = create(0, 0),
                alignment = create(1, 1),
                offset = create(self.handle.offset.x + 2, self.handle.offset.y + 3),
                z_index = 1
            }
        )
        local stringIDButton = self.uuid .. "window_button"
        self.renderer:addElement(
            stringIDButton,
            {
                name = stringIDButton,
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. color(60, 60, 60)) .. ":255",
                scale = create(buttonSize, buttonSize),
                alignment = create(1, 1),
                offset = create(self.handle.offset.x + self.handle.size.x - buttonSize, self.handle.offset.y),
                z_index = 1
            }
        )
        local stringIDButtonX = self.uuid .. "window_button_x"
        self.renderer:addElement(
            stringIDButtonX,
            {
                name = stringIDButtonX,
                hud_elem_type = HudElementType.text,
                scale = create(1, 1),
                text = "X",
                number = colors.colorHEX(0, 0, 0),
                position = create(0, 0),
                alignment = create(1, 1),
                offset = create(self.handle.offset.x + self.handle.size.x - buttonSize + 6, self.handle.offset.y + 3),
                z_index = 2
            }
        )
    end
    function WindowProgram.prototype.__INTERNALDELETION(self)
        self.renderer:removeElement(self.uuid .. "window_handle")
        self.renderer:removeElement(self.uuid .. "window_name")
        self.renderer:removeElement(self.uuid .. "window_button")
        self.renderer:removeElement(self.uuid .. "window_button_x")
    end
    function WindowProgram.prototype.setWindowPos(self, x, y)
        self.windowPosition.x = x
        self.windowPosition.y = y
        do
            self.handle.offset.x = self.windowPosition.x
            self.handle.offset.y = self.windowPosition.y - handleHeight + 1
        end
        local stringID = self.uuid .. "window_handle"
        self.renderer:setElementComponentValue(stringID, "offset", self.handle.offset)
        local stringIDTitle = self.uuid .. "window_name"
        self.renderer:setElementComponentValue(
            stringIDTitle,
            "offset",
            create(self.handle.offset.x + 2, self.handle.offset.y + 3)
        )
        local stringIDButton = self.uuid .. "window_button"
        self.renderer:setElementComponentValue(
            stringIDButton,
            "offset",
            create(self.handle.offset.x + self.handle.size.x - buttonSize, self.handle.offset.y)
        )
        local stringIDButtonX = self.uuid .. "window_button_x"
        self.renderer:setElementComponentValue(
            stringIDButtonX,
            "offset",
            create(self.handle.offset.x + self.handle.size.x - buttonSize + 6, self.handle.offset.y + 3)
        )
        self:move()
    end
    function WindowProgram.prototype.getPosX(self)
        return self.windowPosition.x
    end
    function WindowProgram.prototype.getPosY(self)
        return self.windowPosition.y
    end
    function WindowProgram.prototype.getWindowPosition(self)
        return create(self.windowPosition.x, self.windowPosition.y)
    end
    function WindowProgram.prototype.setWindowSize(self, x, y)
        self.windowSize.x = x
        self.windowSize.y = y
    end
    function WindowProgram.prototype.setWindowTitle(self, newTitle)
        self.windowTitle = newTitle
        local stringIDTitle = self.uuid .. "window_name"
        self.renderer:setElementComponentValue(stringIDTitle, "text", newTitle)
    end
    function WindowProgram.prototype.updateHandleWidth(self, width)
        local strindID = self.uuid .. "window_handle"
        self.handle.size.x = width
        self.renderer:setElementComponentValue(strindID, "scale", self.handle.size)
        local stringIDButton = self.uuid .. "window_button"
        self.renderer:setElementComponentValue(
            stringIDButton,
            "offset",
            create(self.handle.offset.x + self.handle.size.x - buttonSize, self.handle.offset.y)
        )
        local stringIDButtonX = self.uuid .. "window_button_x"
        self.renderer:setElementComponentValue(
            stringIDButtonX,
            "offset",
            create(self.handle.offset.x + self.handle.size.x - buttonSize + 6, self.handle.offset.y + 3)
        )
    end
    function WindowProgram.prototype.move(self)
        error(
            __TS__New(Error, "Move not implemented for " .. self.windowTitle),
            0
        )
    end
    mineos.DesktopEnvironment = __TS__Class()
    local DesktopEnvironment = mineos.DesktopEnvironment
    DesktopEnvironment.name = "DesktopEnvironment"
    __TS__ClassExtends(DesktopEnvironment, mineos.Program)
    function DesktopEnvironment.prototype.____constructor(self, system, renderer, audio)
        DesktopEnvironment.____super.prototype.____constructor(self, system, renderer, audio)
        self.desktopLoaded = false
        self.startMenuFlag = false
        self.startMenuOpened = false
        self.oldFrameBufferSize = create(0, 0)
        self.mousePosition = create(0, 0)
        self.components = {}
        self.focused = true
        self.programBlueprints = {}
        self.runningPrograms = {}
        self.grabbedProgram = nil
        self.mouseLocked = false
        self.acceleration = 250
        self.icons = __TS__New(
            DesktopIcons,
            system,
            renderer,
            audio,
            self
        )
        self.startMenu = __TS__New(
            StartMenu,
            system,
            renderer,
            audio,
            self
        )
        for ____, ____value in ipairs(__TS__ObjectEntries(programQueue)) do
            local name = ____value[1]
            local progBlueprint = ____value[2]
            self.programBlueprints[name] = progBlueprint
        end
    end
    function DesktopEnvironment.prototype.lockMouse(self)
        self.mouseLocked = true
    end
    function DesktopEnvironment.prototype.unlockMouse(self)
        self.mouseLocked = false
        local screenSize = self.renderer.frameBufferSize
        self.mousePosition = create(screenSize.x / 2, screenSize.y / 2)
    end
    function DesktopEnvironment.prototype.isMouseLocked(self)
        return self.mouseLocked
    end
    function DesktopEnvironment.registerProgram(self, progBlueprint)
        programQueue[progBlueprint.name] = progBlueprint
    end
    function DesktopEnvironment.prototype.launchProgram(self, progName, windowSize)
        local ____self_runningPrograms_6 = self.runningPrograms
        ____self_runningPrograms_6[#____self_runningPrograms_6 + 1] = __TS__New(
            self.programBlueprints[progName],
            self.system,
            self.renderer,
            self.audioController,
            self,
            windowSize
        )
    end
    function DesktopEnvironment.prototype.getMousePos(self)
        return self.mousePosition
    end
    function DesktopEnvironment.prototype.getTimeString(self)
        local hour = tostring(tonumber(os.date(
            "%I",
            os.time()
        )))
        return hour .. os.date(
            ":%M %p",
            os.time()
        )
    end
    function DesktopEnvironment.prototype.updateTime(self)
        self.renderer:setElementComponentValue(
            "time",
            "text",
            self:getTimeString()
        )
    end
    function DesktopEnvironment.prototype.loadDesktop(self)
        mineos.System.out:println("loading desktop environment")
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
                z_index = -4
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
                z_index = -3
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
                z_index = -3
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
                z_index = -2
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
        local ____self_components_7 = self.components
        ____self_components_7[#____self_components_7 + 1] = __TS__New(
            DesktopComponent,
            __TS__New(
                mineos.AABB,
                create(0, -32),
                create(66, 32),
                create(0, 1)
            ),
            function()
                self.startMenu:trigger()
            end,
            function()
            end
        )
        self:launchProgram(
            "Boom",
            create(500, 500)
        )
        self.desktopLoaded = true
        mineos.System.out:println("desktop environment loaded")
    end
    function DesktopEnvironment.prototype.update(self)
        self.renderer:setElementComponentValue(
            "taskbar",
            "scale",
            create(self.renderer.frameBufferSize.x, 1)
        )
        local screenSize = self.renderer.frameBufferSize
        local mouseDelta = self.system:getMouseDelta()
        local ____self_mousePosition_8, ____x_9 = self.mousePosition, "x"
        ____self_mousePosition_8[____x_9] = ____self_mousePosition_8[____x_9] + mouseDelta.x * self.acceleration
        local ____self_mousePosition_10, ____y_11 = self.mousePosition, "y"
        ____self_mousePosition_10[____y_11] = ____self_mousePosition_10[____y_11] + mouseDelta.y * self.acceleration
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
            self.oldFrameBufferSize = screenSize
            self.icons:corral()
        end
        if self.mouseLocked then
            self.mousePosition.x = 9000
            self.mousePosition.y = 9000
        end
        local finalizedMousePos = create(self.mousePosition.x - 1, self.mousePosition.y - 1)
        self.renderer:setElementComponentValue("mouse", "offset", finalizedMousePos)
        if self.grabbedProgram ~= nil then
            if self.system:isMouseDown() then
                self.grabbedProgram:setWindowPos(self.mousePosition.x - self.grabbedProgram.offset.x, self.mousePosition.y - self.grabbedProgram.offset.y)
            else
                self.grabbedProgram = nil
            end
        end
        if self.system:isMouseClicked() then
            local deleting = -1
            local index = 0
            for ____, winProgram in ipairs(self.runningPrograms) do
                if winProgram.handle:pointWithin(self.mousePosition) then
                    local XAABB = __TS__New(
                        mineos.AABB,
                        create(winProgram.handle.offset.x + winProgram.handle.size.x - buttonSize + 6, winProgram.handle.offset.y + 3),
                        create(buttonSize, buttonSize),
                        create(0, 0)
                    )
                    if XAABB:pointWithin(self.mousePosition) then
                        deleting = index
                    else
                        self.grabbedProgram = winProgram
                        self.grabbedProgram.offset.x = self.mousePosition.x - winProgram:getPosX()
                        self.grabbedProgram.offset.y = self.mousePosition.y - winProgram:getPosY()
                    end
                    break
                end
                index = index + 1
            end
            if deleting >= 0 then
                self.runningPrograms[deleting + 1]:__INTERNALDELETION()
                self.runningPrograms[deleting + 1]:destructor()
                __TS__Delete(self.runningPrograms, deleting + 1)
            end
            if self.grabbedProgram == nil then
                for ____, element in ipairs(self.components) do
                    if element.collisionBox:pointWithin(self.mousePosition) then
                        element:onClick(self)
                        break
                    end
                end
            end
        end
    end
    function DesktopEnvironment.prototype.runPrograms(self, delta)
        for ____, prog in ipairs(self.runningPrograms) do
            prog:main(delta)
        end
    end
    function DesktopEnvironment.prototype.main(self, delta)
        if not self.desktopLoaded then
            self:loadDesktop()
        end
        self.renderer:update()
        self:update()
        self.icons:main(delta)
        self.startMenu:main(delta)
        self:runPrograms(delta)
        self:updateTime()
    end
    mineos.System:registerProgram(mineos.DesktopEnvironment)
end
