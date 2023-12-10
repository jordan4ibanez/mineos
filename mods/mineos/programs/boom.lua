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

local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        asyncDispose = __TS__Symbol("Symbol.asyncDispose"),
        dispose = __TS__Symbol("Symbol.dispose"),
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local __TS__Iterator
do
    local function iteratorGeneratorStep(self)
        local co = self.____coroutine
        local status, value = coroutine.resume(co)
        if not status then
            error(value, 0)
        end
        if coroutine.status(co) == "dead" then
            return
        end
        return true, value
    end
    local function iteratorIteratorStep(self)
        local result = self:next()
        if result.done then
            return
        end
        return true, result.value
    end
    local function iteratorStringStep(self, index)
        index = index + 1
        if index > #self then
            return
        end
        return index, string.sub(self, index, index)
    end
    function __TS__Iterator(iterable)
        if type(iterable) == "string" then
            return iteratorStringStep, iterable, 0
        elseif iterable.____coroutine ~= nil then
            return iteratorGeneratorStep, iterable
        elseif iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            return iteratorIteratorStep, iterator
        else
            return ipairs(iterable)
        end
    end
end

local __TS__ArrayFrom
do
    local function arrayLikeStep(self, index)
        index = index + 1
        if index > self.length then
            return
        end
        return index, self[index]
    end
    local function arrayLikeIterator(arr)
        if type(arr.length) == "number" then
            return arrayLikeStep, arr, 0
        end
        return __TS__Iterator(arr)
    end
    function __TS__ArrayFrom(arrayLike, mapFn, thisArg)
        local result = {}
        if mapFn == nil then
            for ____, v in arrayLikeIterator(arrayLike) do
                result[#result + 1] = v
            end
        else
            for i, v in arrayLikeIterator(arrayLike) do
                result[#result + 1] = mapFn(thisArg, v, i - 1)
            end
        end
        return result
    end
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create2d
    local color = colors.color
    local Boom = __TS__Class()
    Boom.name = "Boom"
    __TS__ClassExtends(Boom, mineos.WindowProgram)
    function Boom.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
        self.BUFFER_SIZE = 100
        self.BUFFERS_ARRAY_WIDTH = 5
        self.loaded = false
        self.currentPixelCount = 0
        self.currentColor = color(0, 0, 0)
        self.pixelMemory = {}
        self.zIndex = 0
        self.cache = create(0, 0)
        self.buffers = {}
        self.offset = 0
        if windowSize.x ~= 500 or windowSize.y ~= 500 then
            error(
                __TS__New(Error, "BOOM MUST RUN IN 500 X 500!"),
                0
            )
        end
        Boom.____super.prototype.____constructor(
            self,
            system,
            renderer,
            audio,
            desktop,
            windowSize
        )
        local size = self.BUFFER_SIZE * self.BUFFER_SIZE
        do
            local x = 0
            while x < self.BUFFERS_ARRAY_WIDTH do
                do
                    local y = 0
                    while y < self.BUFFERS_ARRAY_WIDTH do
                        local ____self_buffers_0 = self.buffers
                        ____self_buffers_0[#____self_buffers_0 + 1] = __TS__ArrayFrom(
                            {length = size},
                            function(____, _, i) return "red" end
                        )
                        self.renderer:addElement(
                            (("boomBuffer" .. tostring(x)) .. " ") .. tostring(y),
                            {
                                name = (("boomBuffer" .. tostring(x)) .. " ") .. tostring(y),
                                hud_elem_type = HudElementType.image,
                                position = create(0, 0),
                                text = "pixel.png",
                                scale = create(1, 1),
                                alignment = create(1, 1),
                                offset = create(self.windowPosition.x + self.BUFFER_SIZE * x, self.windowPosition.y + self.BUFFER_SIZE * y),
                                z_index = self.zIndex
                            }
                        )
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
    end
    function Boom.prototype.bufferKey(self, x, y)
        return x % self.BUFFERS_ARRAY_WIDTH + y * self.BUFFERS_ARRAY_WIDTH
    end
    function Boom.prototype.clear(self)
    end
    function Boom.prototype.drawPixel(self, x, y, r, g, b)
        local bufferX = math.floor(x / self.BUFFER_SIZE)
        local bufferY = math.floor(y / self.BUFFER_SIZE)
        local inBufferX = x % self.BUFFER_SIZE
        local inBufferY = y % self.BUFFER_SIZE
        local currentBuffer = self.buffers[self:bufferKey(bufferX, bufferY) + 1]
        currentBuffer[inBufferX % self.BUFFER_SIZE + inBufferY * self.BUFFER_SIZE + 1] = color(r, g, b)
    end
    function Boom.prototype.flushBuffer(self)
    end
    function Boom.prototype.render(self, delta)
        self:clear()
        self.offset = self.offset + delta * 100
        do
            local x = 0
            while x < self.windowSize.x do
                do
                    local y = 0
                    while y < self.windowSize.y do
                        local calc = (x + self.offset) % self.windowSize.x / self.windowSize.x
                        self:drawPixel(
                            x,
                            y,
                            calc * 100,
                            1,
                            y / self.windowSize.y * 100
                        )
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
        do
            local x = 0
            while x < self.BUFFERS_ARRAY_WIDTH do
                do
                    local y = 0
                    while y < self.BUFFERS_ARRAY_WIDTH do
                        local currentBuffer = self.buffers[self:bufferKey(x, y) + 1]
                        local rawPNG = minetest.encode_png(self.BUFFER_SIZE, self.BUFFER_SIZE, currentBuffer, 9)
                        local rawData = minetest.encode_base64(rawPNG)
                        self.renderer:setElementComponentValue(
                            (("boomBuffer" .. tostring(x)) .. " ") .. tostring(y),
                            "text",
                            "[png:" .. rawData
                        )
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
    end
    function Boom.prototype.load(self)
    end
    function Boom.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        self:render(delta)
    end
    mineos.DesktopEnvironment:registerProgram(Boom)
end
