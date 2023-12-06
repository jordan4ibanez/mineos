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
    local generate = gui.generate
    local FormSpec = gui.FormSpec
    local BackGround = gui.Background
    local BGColor = gui.BGColor
    local List = gui.List
    local ListColors = gui.ListColors
    local ListRing = gui.ListRing
    mineos.Renderer = __TS__Class()
    local Renderer = mineos.Renderer
    Renderer.name = "Renderer"
    function Renderer.prototype.____constructor(self, system)
        self.buffer = ""
        self.clearColor = vector.create(0, 0, 0)
        self.memory = {}
        self.shouldDraw = true
        self.frameBufferSize = create(0, 0)
        self.frameBufferScale = create(0, 0)
        self.system = system
    end
    function Renderer.prototype.clearMemory(self)
        for ____, ____value in ipairs(__TS__ObjectEntries(self.memory)) do
            local name = ____value[1]
            local _ = ____value[2]
            do
                if name == "backgroundColor" then
                    goto __continue5
                end
                __TS__Delete(self.memory, name)
            end
            ::__continue5::
        end
    end
    function Renderer.prototype.removeComponent(self, name)
        __TS__Delete(self.memory, name)
    end
    function Renderer.prototype.internalUpdateClearColor(self)
        self.memory.backgroundColor = __TS__New(
            BGColor,
            {
                bgColor = colors.color(self.clearColor.x, self.clearColor.y, self.clearColor.z),
                fullScreen = "both",
                fullScreenbgColor = colors.colorScalar(50)
            }
        )
    end
    function Renderer.prototype.setClearColor(self, r, g, b)
        self.clearColor.x = r
        self.clearColor.y = g
        self.clearColor.z = b
        self:internalUpdateClearColor()
    end
    function Renderer.prototype.getBuffer(self)
        return self.buffer
    end
    function Renderer.prototype.addElement(self, name, element)
        self.memory[name] = element
    end
    function Renderer.prototype.getElement(self, name)
        return self.memory[name]
    end
    function Renderer.prototype.grabRef(self, name)
        return self.memory[name] or nil
    end
    function Renderer.prototype.finalizeBuffer(self)
        local obj = __TS__New(
            FormSpec,
            {
                size = self.frameBufferScale,
                padding = create(-0.01, -0.01),
                elements = {}
            }
        )
        local ____obj_elements_0 = obj.elements
        ____obj_elements_0[#____obj_elements_0 + 1] = self.memory.backgroundColor
        for ____, ____value in ipairs(__TS__ObjectEntries(self.memory)) do
            local name = ____value[1]
            local elem = ____value[2]
            do
                if name == "backgroundColor" then
                    goto __continue16
                end
                local ____obj_elements_1 = obj.elements
                ____obj_elements_1[#____obj_elements_1 + 1] = elem
            end
            ::__continue16::
        end
        self.buffer = generate(obj)
    end
    function Renderer.prototype.update(self)
        self:finalizeBuffer()
    end
    function Renderer.prototype.draw(self)
        self.shouldDraw = not self.shouldDraw
        if not self.shouldDraw then
            return
        end
        self:update()
        minetest.show_formspec("singleplayer", "mineos", self.buffer)
    end
    print("renderer loaded.")
end
