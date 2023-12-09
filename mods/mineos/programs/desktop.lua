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
                AABB,
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
            if self.system:isMouseClicked() then
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
    function StartMenuEntry.prototype.____constructor(self, name, program, text, icon)
        self.name = name
        self.program = program
        self.text = text
        self.collisionBox = __TS__New(
            AABB,
            create(1, StartMenuEntry.yOffset),
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
            "bitsBattle",
            "BitsBattle",
            "Bit's Battle",
            "minetest.png"
        )
        local ____self_menuEntries_1 = self.menuEntries
        ____self_menuEntries_1[#____self_menuEntries_1 + 1] = __TS__New(
            StartMenuEntry,
            "fezSphere",
            "FezSphere",
            "Fez Sphere",
            "minetest.png"
        )
        local ____self_menuEntries_2 = self.menuEntries
        ____self_menuEntries_2[#____self_menuEntries_2 + 1] = __TS__New(
            StartMenuEntry,
            "gong",
            "Gong",
            "Gong",
            "minetest.png"
        )
        local ____self_menuEntries_3 = self.menuEntries
        ____self_menuEntries_3[#____self_menuEntries_3 + 1] = __TS__New(
            StartMenuEntry,
            "sledLiberty",
            "SledLiberty",
            "Sled Liberty",
            "minetest.png"
        )
        for ____, entry in ipairs(self.menuEntries) do
            local offset = entry.collisionBox.offset
            print(dump(entry))
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
    local DesktopEnvironment = __TS__Class()
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
        local ____self_components_4 = self.components
        ____self_components_4[#____self_components_4 + 1] = __TS__New(
            DesktopComponent,
            __TS__New(
                AABB,
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
        local ____self_mousePosition_5, ____x_6 = self.mousePosition, "x"
        ____self_mousePosition_5[____x_6] = ____self_mousePosition_5[____x_6] + mouseDelta.x * self.acceleration
        local ____self_mousePosition_7, ____y_8 = self.mousePosition, "y"
        ____self_mousePosition_7[____y_8] = ____self_mousePosition_7[____y_8] + mouseDelta.y * self.acceleration
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
            self.icons:corral()
        end
        local finalizedMousePos = create(self.mousePosition.x - 1, self.mousePosition.y - 1)
        self.renderer:setElementComponentValue("mouse", "offset", finalizedMousePos)
        if self.system:isMouseClicked() then
            for ____, element in ipairs(self.components) do
                if element.collisionBox:pointWithin(self.mousePosition) then
                    element:onClick(self)
                end
            end
        end
    end
    function DesktopEnvironment.prototype.main(self, delta)
        if not self.desktopLoaded then
            self:loadDesktop()
        end
        self.renderer:update()
        self:update()
        self.icons:main(delta)
        self:updateTime()
    end
    mineos.System:registerProgram(DesktopEnvironment)
end
