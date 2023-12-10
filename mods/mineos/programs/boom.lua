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
    local v3f = vector.create
    local v2f = vector.create2d
    local create = vector.create2d
    local color = colors.color
    local Vertex = __TS__Class()
    Vertex.name = "Vertex"
    function Vertex.prototype.____constructor(self, x, y, z, r, g, b)
        self.x = x
        self.y = y
        self.z = z
        self.r = r
        self.g = g
        self.b = b
    end
    function Vertex.prototype.__eq(self, other)
        error(
            __TS__New(Error, "Method not implemented."),
            0
        )
    end
    function Vertex.prototype.__unm(self)
        error(
            __TS__New(Error, "Method not implemented."),
            0
        )
    end
    function Vertex.prototype.__add(self, other)
        error(
            __TS__New(Error, "Method not implemented."),
            0
        )
    end
    function Vertex.prototype.__sub(self, other)
        error(
            __TS__New(Error, "Method not implemented."),
            0
        )
    end
    function Vertex.prototype.__mul(self, other)
        error(
            __TS__New(Error, "Method not implemented."),
            0
        )
    end
    function Vertex.prototype.__div(self, other)
        error(
            __TS__New(Error, "Method not implemented."),
            0
        )
    end
    local function vert(x, y, z, r, g, b)
        return __TS__New(
            Vertex,
            x,
            y,
            z,
            r,
            g,
            b
        )
    end
    local TriangleEquations = __TS__Class()
    TriangleEquations.name = "TriangleEquations"
    function TriangleEquations.prototype.____constructor(self, v0, v1, v2)
        self.drawn = true
        self.e0 = __TS__New(EdgeEquation, v0, v1)
        self.e1 = __TS__New(EdgeEquation, v1, v2)
        self.e2 = __TS__New(EdgeEquation, v2, v0)
        self.area = 0.5 * (self.e0.c + self.e1.c + self.e2.c)
        if self.area < 0 then
            self.drawn = false
        else
            self.drawn = true
        end
        self.r = __TS__New(
            ParameterEquation,
            v0.r,
            v1.r,
            v2.r,
            self.e0,
            self.e1,
            self.e2,
            self.area
        )
        self.g = __TS__New(
            ParameterEquation,
            v0.g,
            v1.g,
            v2.g,
            self.e0,
            self.e1,
            self.e2,
            self.area
        )
        self.b = __TS__New(
            ParameterEquation,
            v0.b,
            v1.b,
            v2.b,
            self.e0,
            self.e1,
            self.e2,
            self.area
        )
    end
    local PixelData = __TS__Class()
    PixelData.name = "PixelData"
    function PixelData.prototype.____constructor(self)
        self.r = 0
        self.g = 0
        self.b = 0
    end
    function PixelData.prototype.init(self, eqn, x, y)
        self.r = eqn.r:evaluate(x, y)
        self.g = eqn.g:evaluate(x, y)
        self.b = eqn.b:evaluate(x, y)
    end
    stepX()
    local TriangleEquations
    bit.band(____, eqn)
    do
        r = eqn.r.stepX(r)
        g = eqn.g.stepX(g)
        b = eqn.b.stepX(b)
    end
    stepY()
    local TriangleEquations
    bit.band(____, eqn)
    do
        r = eqn.r.stepY(r)
        g = eqn.g.stepY(g)
        b = eqn.b.stepY(b)
    end
end
EdgeEquation = __TS__Class()
EdgeEquation.name = "EdgeEquation"
function EdgeEquation.prototype.____constructor(self, v0, v1)
    self.a = v0.y - v1.y
    self.b = v1.x - v0.x
    self.c = -(self.a * (v0.x + v1.x) + self.b * (v0.y + v1.y)) / 2
    local ____temp_0
    if self.a ~= 0 then
        ____temp_0 = self.a > 0
    else
        ____temp_0 = self.b > 0
    end
    self.tie = ____temp_0
end
function EdgeEquation.prototype.evaluate(self, x, y)
    return self.a * x + self.b * y + self.c
end
function EdgeEquation.prototype.test(self, x, y)
    if y then
        return self:test(self:evaluate(x, y))
    else
        return x > 0 or x == 0 and self.tie
    end
end
function EdgeEquation.prototype.stepX(self, v, stepSize)
    if stepSize then
        return v + self.a * stepSize
    else
        return v + self.a
    end
end
function EdgeEquation.prototype.stepY(self, v, stepSize)
    if stepSize then
        return v + self.b * stepSize
    else
        return v + self.b
    end
end
ParameterEquation = __TS__Class()
ParameterEquation.name = "ParameterEquation"
function ParameterEquation.prototype.____constructor(self, p0, p1, p2, e0, e1, e2, area)
    local factor = 1 / (2 * area)
    self.a = factor * (p0 * e0.a + p1 * e1.a + p2 * e2.a)
    self.b = factor * (p0 * e0.b + p1 * e1.b + p2 * e2.b)
    self.c = factor * (p0 * e0.c + p1 * e1.c + p2 * e2.c)
end
function ParameterEquation.prototype.evaluate(self, x, y)
    return self.a * x + self.b * y + self.c
end
function swap(i, z)
    local oldI = i
    i = z
    z = oldI
    return {i, z}
end
function v2swap(i, z)
    local oldI = i
    i = z
    z = oldI
    return {i, z}
end
function v2add(a, b)
    return v2f(a.x + b.x, a.y + b.y)
end
function v2sub(a, b)
    return v2f(a.x - b.x, a.y - b.y)
end
function v2mul(a, scalar)
    return v2f(a.x * scalar, a.y * scalar)
end
function v3pow(a, b)
    return v3f(
        bit.bxor(a.x, b.x),
        bit.bxor(a.y, b.y),
        bit.bxor(a.z, b.z)
    )
end
function v3fxor(a, b)
    return v3f(
        bit.bxor(a.x, b.x),
        bit.bxor(a.y, b.y),
        bit.bxor(a.z, b.z)
    )
end
Boom = __TS__Class()
Boom.name = "Boom"
__TS__ClassExtends(Boom, WindowProgram)
function Boom.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
    self.BUFFER_SIZE = 100
    self.BUFFERS_ARRAY_WIDTH = 5
    self.loaded = false
    self.currentPixelCount = 0
    self.clearColor = v3f(100, 100, 100)
    self.pixelMemory = {}
    self.zIndex = 0
    self.cache = create(0, 0)
    self.buffers = {}
    self.model = {
        vert(
            0,
            200,
            0,
            1,
            0,
            0
        ),
        vert(
            150,
            0,
            0,
            0,
            0,
            1
        ),
        vert(
            300,
            200,
            0,
            0,
            1,
            0
        )
    }
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
                    local ____self_buffers_1 = self.buffers
                    ____self_buffers_1[#____self_buffers_1 + 1] = __TS__ArrayFrom(
                        {length = size},
                        function(____, _, i) return "red" end
                    )
                    self.renderer.addElement(
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
function Boom.prototype.drawModel(self)
    local width = 200
    local height = 200
    local offset = v2f(100, 100)
    self:drawTriangle(self.model[1], self.model[2], self.model[3], "red")
end
function Boom.prototype.drawTriangle(self, v0, v1, v2, color)
    local minX = math.min(
        math.min(v0.x, v1.x),
        v2.x
    )
    local maxX = math.max(
        math.max(v0.x, v1.x),
        v2.x
    )
    local minY = math.min(
        math.min(v0.y, v1.y),
        v2.y
    )
    local maxY = math.max(
        math.max(v0.y, v1.y),
        v2.y
    )
    local m_minX = 0
    local m_minY = 0
    local m_maxX = 300
    local m_maxY = 300
    minX = math.max(minX, m_minX)
    maxX = math.min(maxX, m_maxX)
    minY = math.max(minY, m_minY)
    maxY = math.min(maxY, m_maxY)
    local e0 = __TS__New(EdgeEquation, v1, v2)
    local e1 = __TS__New(EdgeEquation, v2, v0)
    local e2 = __TS__New(EdgeEquation, v0, v1)
    local area = 0.5 * (e0.c + e1.c + e2.c)
    if area < 0 then
        return
    end
    local r = __TS__New(
        ParameterEquation,
        v0.r,
        v1.r,
        v2.r,
        e0,
        e1,
        e2,
        area
    )
    local g = __TS__New(
        ParameterEquation,
        v0.g,
        v1.g,
        v2.g,
        e0,
        e1,
        e2,
        area
    )
    local b = __TS__New(
        ParameterEquation,
        v0.b,
        v1.b,
        v2.b,
        e0,
        e1,
        e2,
        area
    )
    do
        local x = minX + 0.5
        local xm = maxX + 0.5
        while x <= xm do
            do
                local y = minY + 0.5
                local ym = maxY + 0.5
                while y <= ym do
                    if e0:test(x, y) and e1:test(x, y) and e2:test(x, y) then
                        local rint = r:evaluate(x, y) * 100
                        local gint = g:evaluate(x, y) * 100
                        local bint = b:evaluate(x, y) * 100
                        self:drawPixel(
                            x,
                            y,
                            rint,
                            gint,
                            bint
                        )
                    end
                    y = y + 1
                end
            end
            x = x + 1
        end
    end
end
function Boom.prototype.drawLine(self, x0, y0, x1, y1, color)
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
                self:drawPixelString(y, x, color)
            else
                self:drawPixelString(x, y, color)
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
function Boom.prototype.bufferKey(self, x, y)
    return x % self.BUFFERS_ARRAY_WIDTH + y * self.BUFFERS_ARRAY_WIDTH
end
function Boom.prototype.clear(self)
    local clearString = color(self.clearColor.x, self.clearColor.y, self.clearColor.z)
    do
        local x = 0
        while x < self.windowSize.x do
            do
                local y = 0
                while y < self.windowSize.y do
                    self:drawPixelString(x, y, clearString)
                    y = y + 1
                end
            end
            x = x + 1
        end
    end
end
function Boom.prototype.drawPixelString(self, x, y, ____string)
    x = math.round(x)
    y = math.round(y)
    local bufferX = math.floor(x / self.BUFFER_SIZE)
    local bufferY = math.floor(y / self.BUFFER_SIZE)
    local inBufferX = x % self.BUFFER_SIZE
    local inBufferY = y % self.BUFFER_SIZE
    local currentBuffer = self.buffers[self:bufferKey(bufferX, bufferY) + 1]
    currentBuffer[inBufferX % self.BUFFER_SIZE + inBufferY * self.BUFFER_SIZE + 1] = ____string
end
function Boom.prototype.drawPixel(self, x, y, r, g, b)
    x = math.round(x)
    y = math.round(y)
    local bufferX = math.floor(x / self.BUFFER_SIZE)
    local bufferY = math.floor(y / self.BUFFER_SIZE)
    local inBufferX = x % self.BUFFER_SIZE
    local inBufferY = y % self.BUFFER_SIZE
    local currentBuffer = self.buffers[self:bufferKey(bufferX, bufferY) + 1]
    currentBuffer[inBufferX % self.BUFFER_SIZE + inBufferY * self.BUFFER_SIZE + 1] = color(r, g, b)
end
function Boom.prototype.flushBuffers(self)
    do
        local x = 0
        while x < self.BUFFERS_ARRAY_WIDTH do
            do
                local y = 0
                while y < self.BUFFERS_ARRAY_WIDTH do
                    local currentBuffer = self.buffers[self:bufferKey(x, y) + 1]
                    local rawPNG = minetest.encode_png(self.BUFFER_SIZE, self.BUFFER_SIZE, currentBuffer, 9)
                    local rawData = minetest.encode_base64(rawPNG)
                    self.renderer.setElementComponentValue(
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
function Boom.prototype.render(self, delta)
    self:clear()
    self:drawModel()
    self:flushBuffers()
end
function Boom.prototype.load(self)
end
function Boom.prototype.main(self, delta)
    if not self.loaded then
        self:load()
    end
    self:render(delta)
end
DesktopEnvironment.registerProgram(Boom)
