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
    local color = colors.colorHEX
    local Boom = __TS__Class()
    Boom.name = "Boom"
    __TS__ClassExtends(Boom, mineos.WindowProgram)
    function Boom.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
        Boom.____super.prototype.____constructor(
            self,
            system,
            renderer,
            audio,
            desktop,
            windowSize
        )
        self.loaded = false
        self.currentPixelCount = 0
        self.currentColor = color(0, 0, 0)
        self.pixelMemory = {}
        self.zIndex = 0
        self.cache = create(0, 0)
        local size = windowSize.x * windowSize.y
        self.buffer = __TS__ArrayFrom(
            {length = size},
            function(____, _, i) return "red" end
        )
        self.renderer:addElement(
            "boomBuffer",
            {
                name = "boomBuffer",
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = "pixel.png",
                scale = create(1, 1),
                alignment = create(1, 1),
                offset = self.windowPosition,
                z_index = self.zIndex
            }
        )
    end
    function Boom.prototype.test(self)
    end
    function Boom.prototype.clear(self)
    end
    function Boom.prototype.drawPixel(self, x, y)
    end
    function Boom.prototype.flushBuffer(self)
    end
    function Boom.prototype.render(self)
        self:clear()
        do
            local x = 0
            while x < self.windowSize.x do
                do
                    local y = 0
                    while y < self.windowSize.y do
                        if x % 8 == 0 and y % 8 == 0 then
                            self:drawPixel(x, y)
                        end
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
        local rawData = minetest.encode_base64(minetest.encode_png(self.windowSize.x, self.windowSize.y, self.buffer, 9))
        self.renderer:setElementComponentValue("boomBuffer", "text", "[png:" .. rawData)
    end
    function Boom.prototype.load(self)
    end
    function Boom.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        self:render()
    end
    mineos.DesktopEnvironment:registerProgram(Boom)
end
