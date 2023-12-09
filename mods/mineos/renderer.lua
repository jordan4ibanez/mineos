-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
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

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
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
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create2d
    mineos.Renderer = __TS__Class()
    local Renderer = mineos.Renderer
    Renderer.name = "Renderer"
    function Renderer.prototype.____constructor(self, system)
        self.clearColor = vector.create(0, 0, 0)
        self.memory = {}
        self.shouldDraw = true
        self.frameBufferSize = create(0, 0)
        self.frameBufferScale = 1
        self.system = system
        self:addElement(
            "background",
            {
                name = "background",
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = "pixel.png",
                scale = create(0, 0),
                alignment = create(1, 1),
                offset = create(0, 0),
                z_index = -2
            }
        )
    end
    function Renderer.prototype.clearMemory(self)
    end
    function Renderer.prototype.removeComponent(self, name)
    end
    function Renderer.prototype.internalUpdateClearColor(self)
    end
    function Renderer.prototype.setClearColor(self, r, g, b)
        self.clearColor.x = r
        self.clearColor.y = g
        self.clearColor.z = b
        self:internalUpdateClearColor()
    end
    function Renderer.prototype.addElement(self, name, component)
        local driver = self.system:getDriver()
        self.memory[name] = driver:hud_add(component)
    end
    function Renderer.prototype.getElement(self, name)
        local driver = self.system:getDriver()
        local elementID = self.memory[name]
        if elementID == nil then
            error(
                __TS__New(Error, ("renderer: component " .. name) .. " does not exist."),
                0
            )
        end
        return driver:hud_get(elementID)
    end
    function Renderer.prototype.setElementComponentValue(self, name, component, value)
        local driver = self.system:getDriver()
        local elementID = self.memory[name]
        if elementID == nil then
            error(
                __TS__New(Error, ("renderer: component " .. name) .. " does not exist."),
                0
            )
        end
        driver:hud_change(elementID, component, value)
    end
    function Renderer.prototype.update(self)
        self:setElementComponentValue("background", "scale", self.frameBufferSize)
        self:setElementComponentValue(
            "background",
            "text",
            ("pixel.png^[colorize:" .. colors.color(self.clearColor.x, self.clearColor.y, self.clearColor.z)) .. ":255"
        )
    end
    print("renderer loaded.")
end
