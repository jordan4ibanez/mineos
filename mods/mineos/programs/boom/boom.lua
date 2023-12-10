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

local function __TS__StringAccess(self, index)
    if index >= 0 and index < #self then
        return string.sub(self, index + 1, index + 1)
    end
end

local __TS__MathModf = math.modf

local __TS__NumberToString
do
    local radixChars = "0123456789abcdefghijklmnopqrstuvwxyz"
    function __TS__NumberToString(self, radix)
        if radix == nil or radix == 10 or self == math.huge or self == -math.huge or self ~= self then
            return tostring(self)
        end
        radix = math.floor(radix)
        if radix < 2 or radix > 36 then
            error("toString() radix argument must be between 2 and 36", 0)
        end
        local integer, fraction = __TS__MathModf(math.abs(self))
        local result = ""
        if radix == 8 then
            result = string.format("%o", integer)
        elseif radix == 16 then
            result = string.format("%x", integer)
        else
            repeat
                do
                    result = __TS__StringAccess(radixChars, integer % radix) .. result
                    integer = math.floor(integer / radix)
                end
            until not (integer ~= 0)
        end
        if fraction ~= 0 then
            result = result .. "."
            local delta = 1e-16
            repeat
                do
                    fraction = fraction * radix
                    delta = delta * radix
                    local digit = math.floor(fraction)
                    result = result .. __TS__StringAccess(radixChars, digit)
                    fraction = fraction - digit
                end
            until not (fraction >= delta)
        end
        if self < 0 then
            result = "-" .. result
        end
        return result
    end
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local v3f = vector.create
    local v2f = vector.create2d
    local create = vector.create2d
    local color = colors.color
    local floor = math.floor
    local abs = math.abs
    local char = string.char
    local concat = table.concat
    local encode_png = minetest.encode_png
    local encode_base64 = minetest.encode_base64
    local random = math.random
    local cos = math.cos
    local sin = math.sin
    local CHANNELS = 4
    local function swap(i, z)
        local oldI = i
        i = z
        z = oldI
        return {i, z}
    end
    local function v2swap(i, z)
        local oldI = i
        i = z
        z = oldI
        return {i, z}
    end
    local Boom = __TS__Class()
    Boom.name = "Boom"
    __TS__ClassExtends(Boom, mineos.WindowProgram)
    function Boom.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
        self.BUFFER_SIZE_Y = 100
        self.BUFFER_SIZE_X = self.BUFFER_SIZE_Y * CHANNELS
        self.BUFFERS_ARRAY_WIDTH = 5
        self.loaded = false
        self.currentPixelCount = 0
        self.clearColor = v3f(0, 0, 0)
        self.pixelMemory = {}
        self.zIndex = 0
        self.cache = create(0, 0)
        self.auxWasPressed = false
        self.frameAccum = 0
        self.buffering = 0
        self.buffers = {}
        self.playerPos = create(22, 12)
        self.playerDir = create(-1, 0)
        self.time = 0
        self.oldTime = 0
        self.planeX = 0
        self.planeY = 0.66
        self.texWidth = 64
        self.texHeight = 64
        self.mapWidth = 24
        self.mapHeight = 24
        self.textures = mineos.loadFile("programs/boom/png_data").fileData
        self.worldMap = {
            {
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                7,
                7,
                7,
                7,
                7,
                7,
                7,
                7
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                7
            },
            {
                4,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                7
            },
            {
                4,
                0,
                2,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                7
            },
            {
                4,
                0,
                3,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                7
            },
            {
                4,
                0,
                4,
                0,
                0,
                0,
                0,
                5,
                5,
                5,
                5,
                5,
                5,
                5,
                5,
                5,
                7,
                7,
                0,
                7,
                7,
                7,
                7,
                7
            },
            {
                4,
                0,
                5,
                0,
                0,
                0,
                0,
                5,
                0,
                5,
                0,
                5,
                0,
                5,
                0,
                5,
                7,
                0,
                0,
                0,
                7,
                7,
                7,
                1
            },
            {
                4,
                0,
                6,
                0,
                0,
                0,
                0,
                5,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                5,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                8
            },
            {
                4,
                0,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                7,
                7,
                7,
                1
            },
            {
                4,
                0,
                8,
                0,
                0,
                0,
                0,
                5,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                5,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                8
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                5,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                5,
                7,
                0,
                0,
                0,
                7,
                7,
                7,
                1
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                5,
                5,
                5,
                5,
                0,
                5,
                5,
                5,
                5,
                7,
                7,
                7,
                7,
                7,
                7,
                7,
                1
            },
            {
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                0,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6
            },
            {
                8,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                4
            },
            {
                6,
                6,
                6,
                6,
                6,
                6,
                0,
                6,
                6,
                6,
                6,
                0,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6,
                6
            },
            {
                4,
                4,
                4,
                4,
                4,
                4,
                0,
                4,
                4,
                4,
                6,
                0,
                6,
                2,
                2,
                2,
                2,
                2,
                2,
                2,
                3,
                3,
                3,
                3
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                4,
                6,
                0,
                6,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                0,
                0,
                0,
                2
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                6,
                2,
                0,
                0,
                5,
                0,
                0,
                2,
                0,
                0,
                0,
                2
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                4,
                6,
                0,
                6,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                2,
                0,
                2,
                2
            },
            {
                4,
                0,
                6,
                0,
                6,
                0,
                0,
                0,
                0,
                4,
                6,
                0,
                0,
                0,
                0,
                0,
                5,
                0,
                0,
                0,
                0,
                0,
                0,
                2
            },
            {
                4,
                0,
                0,
                5,
                0,
                0,
                0,
                0,
                0,
                4,
                6,
                0,
                6,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                2,
                0,
                2,
                2
            },
            {
                4,
                0,
                6,
                0,
                6,
                0,
                0,
                0,
                0,
                4,
                6,
                0,
                6,
                2,
                0,
                0,
                5,
                0,
                0,
                2,
                0,
                0,
                0,
                2
            },
            {
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                4,
                6,
                0,
                6,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                0,
                0,
                0,
                2
            },
            {
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                4,
                1,
                1,
                1,
                2,
                2,
                2,
                2,
                2,
                2,
                3,
                3,
                3,
                3,
                3
            }
        }
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
        for ____, arr in ipairs(self.textures) do
            print("Length: " .. tostring(#arr))
            print("GOAL: " .. tostring(self.texHeight * self.texWidth * CHANNELS))
            assert(#arr == self.texHeight * self.texWidth * CHANNELS)
        end
        error(
            __TS__New(Error, "poop"),
            0
        )
        local size = self.BUFFER_SIZE_X * self.BUFFER_SIZE_Y
        do
            local x = 0
            while x < self.BUFFERS_ARRAY_WIDTH do
                do
                    local y = 0
                    while y < self.BUFFERS_ARRAY_WIDTH do
                        local ____self_buffers_0 = self.buffers
                        ____self_buffers_0[#____self_buffers_0 + 1] = __TS__ArrayFrom(
                            {length = size},
                            function(____, _, i) return (i + 1) % 4 == 0 and char(255) or char(0) end
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
                                offset = create(self.windowPosition.x + self.BUFFER_SIZE_Y * x, self.windowPosition.y + self.BUFFER_SIZE_Y * y),
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
        do
            local x = 0
            while x < self.windowSize.x do
                do
                    local y = 0
                    while y < self.windowSize.y do
                        self:drawPixel(
                            x,
                            y,
                            self.clearColor.x,
                            self.clearColor.y,
                            self.clearColor.z
                        )
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
    end
    function Boom.prototype.drawPixel(self, x, y, r, g, b)
        x = floor(x)
        y = floor(y)
        local bufferX = floor(x / self.BUFFER_SIZE_Y)
        local bufferY = floor(y / self.BUFFER_SIZE_Y)
        local currentBuffer = self.buffers[self:bufferKey(bufferX, bufferY) + 1]
        local inBufferX = x % self.BUFFER_SIZE_Y
        local inBufferY = y % self.BUFFER_SIZE_Y
        local index = (inBufferX % self.BUFFER_SIZE_Y + inBufferY * self.BUFFER_SIZE_Y) * CHANNELS
        currentBuffer[index + 1] = char(floor(r))
        currentBuffer[index + 1 + 1] = char(floor(g))
        currentBuffer[index + 2 + 1] = char(floor(b))
        currentBuffer[index + 3 + 1] = char(floor(255))
    end
    function Boom.prototype.drawPixelUint_16(self, x, y, val)
        x = floor(x)
        y = floor(y)
        local bufferX = floor(x / self.BUFFER_SIZE_Y)
        local bufferY = floor(y / self.BUFFER_SIZE_Y)
        local currentBuffer = self.buffers[self:bufferKey(bufferX, bufferY) + 1]
        local inBufferX = x % self.BUFFER_SIZE_Y
        local inBufferY = y % self.BUFFER_SIZE_Y
        local index = (inBufferX % self.BUFFER_SIZE_Y + inBufferY * self.BUFFER_SIZE_Y) * CHANNELS
        local hex = __TS__NumberToString(val, 16)
    end
    function Boom.prototype.flushBuffers(self)
        self.frameAccum = self.frameAccum + 1
        if self.frameAccum > self.buffering then
            self.frameAccum = 0
        else
            return
        end
        do
            local x = 0
            while x < self.BUFFERS_ARRAY_WIDTH do
                do
                    local y = 0
                    while y < self.BUFFERS_ARRAY_WIDTH do
                        local currentBuffer = self.buffers[self:bufferKey(x, y) + 1]
                        local stringThing = concat(currentBuffer)
                        local rawPNG = encode_png(self.BUFFER_SIZE_Y, self.BUFFER_SIZE_Y, stringThing, 9)
                        local rawData = encode_base64(rawPNG)
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
    function Boom.prototype.drawLine(self, x0, y0, x1, y1, r, b, g)
        local steep = false
        if math.abs(x0 - x1) < math.abs(y0 - y1) then
            x0, y0 = unpack(swap(x0, y0))
            x1, y1 = unpack(swap(x1, y1))
            steep = true
        end
        if x0 > x1 then
            x0, x1 = unpack(swap(x0, x1))
            y0, y1 = unpack(swap(y0, y1))
        end
        local dx = x1 - x0
        local dy = y1 - y0
        local derror2 = math.abs(dy) * 2
        local error2 = 0
        local y = y0
        do
            local x = x0
            while x <= x1 do
                if steep then
                    self:drawPixel(
                        y,
                        x,
                        r,
                        g,
                        b
                    )
                else
                    self:drawPixel(
                        x,
                        y,
                        r,
                        g,
                        b
                    )
                end
                error2 = error2 + derror2
                if error2 > dx then
                    y = y + (y1 > y0 and 1 or -1)
                    error2 = error2 - dx * 2
                end
                x = x + 1
            end
        end
    end
    function Boom.prototype.playerControls(self, delta)
        local auxPressed = self.system:isKeyDown("aux1")
        if auxPressed and not self.auxWasPressed then
            if self.desktop:isMouseLocked() then
                self.desktop:unlockMouse()
            else
                self.desktop:lockMouse()
            end
        end
        self.auxWasPressed = auxPressed
        if not self.desktop:isMouseLocked() then
            return
        end
        local moveSpeed = delta * 5
        if self.system:isKeyDown("up") then
            if self.worldMap[floor(self.playerPos.x + self.playerDir.x * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_1, ____x_2 = self.playerPos, "x"
                ____self_playerPos_1[____x_2] = ____self_playerPos_1[____x_2] + self.playerDir.x * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y + self.playerDir.y * moveSpeed) + 1] == 0 then
                local ____self_playerPos_3, ____y_4 = self.playerPos, "y"
                ____self_playerPos_3[____y_4] = ____self_playerPos_3[____y_4] + self.playerDir.y * moveSpeed
            end
        end
        if self.system:isKeyDown("down") then
            if self.worldMap[floor(self.playerPos.x - self.playerDir.x * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_5, ____x_6 = self.playerPos, "x"
                ____self_playerPos_5[____x_6] = ____self_playerPos_5[____x_6] - self.playerDir.x * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y - self.playerDir.y * moveSpeed) + 1] == 0 then
                local ____self_playerPos_7, ____y_8 = self.playerPos, "y"
                ____self_playerPos_7[____y_8] = ____self_playerPos_7[____y_8] - self.playerDir.y * moveSpeed
            end
        end
        if self.system:isKeyDown("right") then
            if self.worldMap[floor(self.playerPos.x + self.planeX * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_9, ____x_10 = self.playerPos, "x"
                ____self_playerPos_9[____x_10] = ____self_playerPos_9[____x_10] + self.planeX * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y + self.planeY * moveSpeed) + 1] == 0 then
                local ____self_playerPos_11, ____y_12 = self.playerPos, "y"
                ____self_playerPos_11[____y_12] = ____self_playerPos_11[____y_12] + self.planeY * moveSpeed
            end
        end
        if self.system:isKeyDown("left") then
            if self.worldMap[floor(self.playerPos.x - self.planeX * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_13, ____x_14 = self.playerPos, "x"
                ____self_playerPos_13[____x_14] = ____self_playerPos_13[____x_14] - self.planeX * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y - self.planeY * moveSpeed) + 1] == 0 then
                local ____self_playerPos_15, ____y_16 = self.playerPos, "y"
                ____self_playerPos_15[____y_16] = ____self_playerPos_15[____y_16] - self.planeY * moveSpeed
            end
        end
        local rotSpeed = self.system:getMouseDelta().x
        local oldDirX = self.playerDir.x
        self.playerDir.x = self.playerDir.x * cos(-rotSpeed) - self.playerDir.y * sin(-rotSpeed)
        self.playerDir.y = oldDirX * sin(-rotSpeed) + self.playerDir.y * cos(-rotSpeed)
        local oldPlaneX = self.planeX
        self.planeX = self.planeX * cos(-rotSpeed) - self.planeY * sin(-rotSpeed)
        self.planeY = oldPlaneX * sin(-rotSpeed) + self.planeY * cos(-rotSpeed)
    end
    function Boom.prototype.rayCast(self)
        local posX = self.playerPos.x
        local posY = self.playerPos.y
        local dirX = self.playerDir.x
        local dirY = self.playerDir.y
        local planeX = self.planeX
        local planeY = self.planeY
        local w = self.windowSize.x
        local h = self.windowSize.y
        do
            local x = 0
            while x < w do
                local cameraX = 2 * x / w - 1
                local rayDirX = dirX + planeX * cameraX
                local rayDirY = dirY + planeY * cameraX
                local mapX = floor(posX)
                local mapY = floor(posY)
                local sideDistX = 0
                local sideDistY = 0
                local deltaDistX = rayDirX == 0 and 1e+30 or abs(1 / rayDirX)
                local deltaDistY = rayDirY == 0 and 1e+30 or abs(1 / rayDirY)
                local perpWallDist = 0
                local stepX = 0
                local stepY = 0
                local hit = 0
                local side = 0
                if rayDirX < 0 then
                    stepX = -1
                    sideDistX = (posX - mapX) * deltaDistX
                else
                    stepX = 1
                    sideDistX = (mapX + 1 - posX) * deltaDistX
                end
                if rayDirY < 0 then
                    stepY = -1
                    sideDistY = (posY - mapY) * deltaDistY
                else
                    stepY = 1
                    sideDistY = (mapY + 1 - posY) * deltaDistY
                end
                while hit == 0 do
                    if sideDistX < sideDistY then
                        sideDistX = sideDistX + deltaDistX
                        mapX = mapX + stepX
                        side = 0
                    else
                        sideDistY = sideDistY + deltaDistY
                        mapY = mapY + stepY
                        side = 1
                    end
                    if self.worldMap[mapX + 1][mapY + 1] > 0 then
                        hit = 1
                    end
                end
                if side == 0 then
                    perpWallDist = sideDistX - deltaDistX
                else
                    perpWallDist = sideDistY - deltaDistY
                end
                local lineHeight = floor(h / perpWallDist)
                local drawStart = -lineHeight / 2 + h / 2
                if drawStart < 0 then
                    drawStart = 0
                end
                local drawEnd = lineHeight / 2 + h / 2
                if drawEnd >= h then
                    drawEnd = h - 1
                end
                local wallX
                if side == 0 then
                    wallX = posY + perpWallDist * rayDirY
                else
                    wallX = posX + perpWallDist * rayDirX
                end
                wallX = wallX - floor(wallX)
                local texX = floor(wallX * self.texWidth)
                if side == 0 and rayDirX > 0 then
                    texX = self.texWidth - texX - 1
                end
                if side == 1 and rayDirY < 0 then
                    texX = self.texWidth - texX - 1
                end
                local color = v3f()
                repeat
                    local ____switch65 = self.worldMap[mapX + 1][mapY + 1]
                    local ____cond65 = ____switch65 == 1
                    if ____cond65 then
                        color = v3f(255, 0, 0)
                        break
                    end
                    ____cond65 = ____cond65 or ____switch65 == 2
                    if ____cond65 then
                        color = v3f(0, 255, 0)
                        break
                    end
                    ____cond65 = ____cond65 or ____switch65 == 3
                    if ____cond65 then
                        color = v3f(0, 0, 255)
                        break
                    end
                    ____cond65 = ____cond65 or ____switch65 == 4
                    if ____cond65 then
                        color = v3f(255, 255, 255)
                        break
                    end
                    do
                        color = v3f(255, 255, 0)
                        break
                    end
                until true
                local texNum = self.worldMap[mapX + 1][mapY + 1] - 1
                print(texNum)
                local step = 1 * self.texHeight / lineHeight
                local texPos = (drawStart - h / 2 + lineHeight / 2) * step
                do
                    local y = drawStart
                    while y < drawEnd do
                        local texY = bit.band(
                            floor(texPos),
                            self.texHeight - 1
                        )
                        texPos = texPos + step
                        local container = self.textures[texNum + 1]
                        print(container)
                        local index = self.texHeight * texY + texX
                        local r = container[index + 1]
                        print(r, r, r)
                        self:drawPixel(
                            x,
                            y,
                            r,
                            r,
                            r
                        )
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
    end
    function Boom.prototype.render(self, delta)
        self:clear()
        self:rayCast()
        self:flushBuffers()
    end
    function Boom.prototype.load(self)
        self.desktop:lockMouse()
        self.loaded = true
    end
    function Boom.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        self:playerControls(delta)
        self:render(delta)
    end
    mineos.DesktopEnvironment:registerProgram(Boom)
end
