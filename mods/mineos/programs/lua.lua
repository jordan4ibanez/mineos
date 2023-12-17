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
    local create = vector.create
    local function ____print(...)
        mineos.System.out:println("Ye" .. "he")
    end
    local LuaVM = __TS__Class()
    LuaVM.name = "LuaVM"
    __TS__ClassExtends(LuaVM, mineos.WindowProgram)
    function LuaVM.prototype.____constructor(self, ...)
        LuaVM.____super.prototype.____constructor(self, ...)
        self.loaded = false
        self.instance = 0
    end
    function LuaVM.prototype.load(self)
        self.renderer:addElement(
            "lua_bg_" .. tostring(self.instance),
            {
                name = "lua_bg_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(30, 30, 30)) .. ":255",
                scale = self.windowSize,
                alignment = create(1, 1),
                offset = create(
                    self:getPosX(),
                    self:getPosY()
                ),
                z_index = 1
            }
        )
        ____print()
        self.instance = LuaVM.nextInstance
        LuaVM.nextInstance = LuaVM.nextInstance + 1
        self.loaded = true
    end
    function LuaVM.prototype.move(self)
        self.renderer:setElementComponentValue(
            "lua_bg_" .. tostring(self.instance),
            "offset",
            self.windowPosition
        )
    end
    function LuaVM.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        ____print("ye")
    end
    LuaVM.nextInstance = 0
    mineos.DesktopEnvironment:registerProgram(LuaVM)
end
