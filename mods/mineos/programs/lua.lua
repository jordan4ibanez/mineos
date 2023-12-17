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

local function __TS__StringTrim(self)
    local result = string.gsub(self, "^[%s ﻿]*(.-)[%s ﻿]*$", "%1")
    return result
end

local __TS__StringSplit
do
    local sub = string.sub
    local find = string.find
    function __TS__StringSplit(source, separator, limit)
        if limit == nil then
            limit = 4294967295
        end
        if limit == 0 then
            return {}
        end
        local result = {}
        local resultIndex = 1
        if separator == nil or separator == "" then
            for i = 1, #source do
                result[resultIndex] = sub(source, i, i)
                resultIndex = resultIndex + 1
            end
        else
            local currentPos = 1
            while resultIndex <= limit do
                local startPos, endPos = find(source, separator, currentPos, true)
                if not startPos then
                    break
                end
                result[resultIndex] = sub(source, currentPos, startPos - 1)
                resultIndex = resultIndex + 1
                currentPos = endPos + 1
            end
            if resultIndex <= limit then
                result[resultIndex] = sub(source, currentPos)
            end
        end
        return result
    end
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create
    local function ____print(...)
        mineos.System.out:println(...)
    end
    local LuaVM = __TS__Class()
    LuaVM.name = "LuaVM"
    __TS__ClassExtends(LuaVM, mineos.WindowProgram)
    function LuaVM.prototype.____constructor(self, ...)
        LuaVM.____super.prototype.____constructor(self, ...)
        self.loaded = false
        self.instance = 0
        self.myCoolProgram = ""
        self.version = 5.100000000000015
    end
    function LuaVM.prototype.charInput(self, char)
        if #char > 1 then
            error(
                __TS__New(Error, "How did this even happen?"),
                0
            )
        end
        self.myCoolProgram = table.concat(
            __TS__StringSplit(
                __TS__StringTrim(self.myCoolProgram .. char),
                "\n",
                3
            ),
            ","
        )
    end
    function LuaVM.prototype.charDelete(self)
        local length = #self.myCoolProgram - 1
        if length < 0 then
            length = 0
        end
        local finalResult = string.sub(self.myCoolProgram, 1, -2)
        self.myCoolProgram = finalResult
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
        self:charInput("1")
        ____print(self.myCoolProgram)
        self:charDelete()
        ____print(self.myCoolProgram)
        self.instance = LuaVM.nextInstance
        LuaVM.nextInstance = LuaVM.nextInstance + 1
        self.loaded = true
    end
    function LuaVM.prototype.floatError(self)
        if math.random() > 0.5 then
            self.version = self.version + 1e-14
        else
            self.version = self.version - 1e-14
        end
        self:setWindowTitle("LuaJIT " .. tostring(self.version))
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
        self:floatError()
    end
    LuaVM.nextInstance = 0
    mineos.DesktopEnvironment:registerProgram(LuaVM)
end
