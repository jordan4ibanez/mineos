-- Lua Library inline imports
local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
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
    local round = math.round
    local yaw_to_dir = minetest.yaw_to_dir
    local CHANNELS = 4
    local vecA = vector.create(0, 0, 0)
    local vecB = vector.create(0, 0, 0)
    do
        local n = -1
        math.randomseed(os.time())
        local song = __TS__New(mineos.Song, "boom_theme")
        song.tempo = 5
        song.data.guitar = __TS__ArrayFrom(
            {length = 256},
            function(____, _, i) return math.random(-1, 11) end
        )
        song.data.trumpet = __TS__ArrayFrom(
            {length = 256},
            function(____, _, i) return math.random(-1, 11) end
        )
        song.data.bassTrumpet = __TS__ArrayFrom(
            {length = 256},
            function(____, _, i) return math.random(-1, 11) end
        )
        mineos.AudioController:registerSong(song)
    end
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
    local Sprite = __TS__Class()
    Sprite.name = "Sprite"
    function Sprite.prototype.____constructor(self, x, y, texture)
        self.x = x
        self.y = y
        self.texture = texture
    end
    local function s(x, y, texture)
        return __TS__New(Sprite, x, y, texture)
    end
    local Mob = __TS__Class()
    Mob.name = "Mob"
    function Mob.prototype.____constructor(self, x, y, sprite)
        self.alive = true
        self.yaw = random() * (math.pi * 2)
        self.x = x
        self.y = y
        self.sprite = sprite
    end
    local Bullet = __TS__Class()
    Bullet.name = "Bullet"
    function Bullet.prototype.____constructor(self, x, y, dirX, dirY)
        self.x = x
        self.y = y
        self.dirX = dirX
        self.dirY = dirY
    end
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
        self.performanceBuffer = true
        self.performanceMode = false
        self.enable4kPerformanceMode = true
        self.BUFFER_SIZE_Y = 100
        self.BUFFER_SIZE_X = self.BUFFER_SIZE_Y * CHANNELS
        self.BUFFERS_ARRAY_SIZE_X = self.performanceBuffer and 4 or 8
        self.BUFFERS_ARRAY_SIZE_Y = self.performanceBuffer and 4 or 7
        self.loaded = false
        self.currentPixelCount = 0
        self.clearColor = v3f(0, 0, 0)
        self.pixelMemory = {}
        self.zIndex = 0
        self.cache = create(0, 0)
        self.auxWasPressed = false
        self.currentBullet = nil
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
                8,
                8,
                8,
                8,
                8,
                8,
                8,
                8,
                8,
                8,
                8,
                4,
                4,
                6,
                4,
                4,
                6,
                4,
                6,
                4,
                4,
                4,
                6,
                4
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
                8,
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
                4
            },
            {
                8,
                0,
                3,
                3,
                0,
                0,
                0,
                0,
                0,
                8,
                8,
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
                6
            },
            {
                8,
                0,
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
                0,
                0,
                0,
                0,
                0,
                0,
                6
            },
            {
                8,
                0,
                3,
                3,
                0,
                0,
                0,
                0,
                0,
                8,
                8,
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
                4
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
                8,
                4,
                0,
                0,
                0,
                0,
                0,
                6,
                6,
                6,
                0,
                6,
                4,
                6
            },
            {
                8,
                8,
                8,
                8,
                0,
                8,
                8,
                8,
                8,
                8,
                8,
                4,
                4,
                4,
                4,
                4,
                4,
                6,
                0,
                0,
                0,
                0,
                0,
                6
            },
            {
                7,
                7,
                7,
                7,
                0,
                7,
                7,
                7,
                7,
                0,
                8,
                0,
                8,
                0,
                8,
                0,
                8,
                4,
                0,
                4,
                0,
                6,
                0,
                6
            },
            {
                7,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                7,
                8,
                0,
                8,
                0,
                8,
                0,
                8,
                8,
                6,
                0,
                0,
                0,
                0,
                0,
                6
            },
            {
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
                8,
                6,
                0,
                0,
                0,
                0,
                0,
                4
            },
            {
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
                8,
                6,
                0,
                6,
                0,
                6,
                0,
                6
            },
            {
                7,
                7,
                0,
                0,
                0,
                0,
                0,
                0,
                7,
                8,
                0,
                8,
                0,
                8,
                0,
                8,
                8,
                6,
                4,
                6,
                0,
                6,
                6,
                6
            },
            {
                7,
                7,
                7,
                7,
                0,
                7,
                7,
                7,
                7,
                8,
                8,
                4,
                0,
                6,
                8,
                4,
                8,
                3,
                3,
                3,
                0,
                3,
                3,
                3
            },
            {
                2,
                2,
                2,
                2,
                0,
                2,
                2,
                2,
                2,
                4,
                6,
                4,
                0,
                0,
                6,
                0,
                6,
                3,
                0,
                0,
                0,
                0,
                0,
                3
            },
            {
                2,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                2,
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                4,
                3,
                0,
                0,
                0,
                0,
                0,
                3
            },
            {
                2,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                2,
                4,
                0,
                0,
                0,
                0,
                0,
                0,
                4,
                3,
                0,
                0,
                0,
                0,
                0,
                3
            },
            {
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                1,
                4,
                4,
                4,
                4,
                4,
                6,
                0,
                6,
                3,
                3,
                0,
                0,
                0,
                3,
                3
            },
            {
                2,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                2,
                2,
                2,
                1,
                2,
                2,
                2,
                6,
                6,
                0,
                0,
                5,
                0,
                5,
                0,
                5
            },
            {
                2,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                2,
                2,
                0,
                0,
                0,
                2,
                2,
                0,
                5,
                0,
                5,
                0,
                0,
                0,
                5,
                5
            },
            {
                2,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                5,
                0,
                5,
                0,
                5,
                0,
                5,
                0,
                5
            },
            {
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
                0,
                0,
                5
            },
            {
                2,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                5,
                0,
                5,
                0,
                5,
                0,
                5,
                0,
                5
            },
            {
                2,
                2,
                0,
                0,
                0,
                0,
                0,
                2,
                2,
                2,
                0,
                0,
                0,
                2,
                2,
                0,
                5,
                0,
                5,
                0,
                0,
                0,
                5,
                5
            },
            {
                2,
                2,
                2,
                2,
                1,
                2,
                2,
                2,
                2,
                2,
                2,
                1,
                2,
                2,
                2,
                5,
                5,
                5,
                5,
                5,
                5,
                5,
                5,
                5
            }
        }
        self.mobs = {}
        self.sprite = {
            s(20.5, 11.5, 10),
            s(18.5, 4.5, 10),
            s(10, 4.5, 10),
            s(10, 12.5, 10),
            s(3.5, 6.5, 10),
            s(3.5, 20.5, 10),
            s(3.5, 14.5, 10),
            s(14.5, 20.5, 10),
            s(18.5, 10.5, 9),
            s(18.5, 11.5, 9),
            s(18.5, 12.5, 9),
            s(21.5, 1.5, 8),
            s(15.5, 1.5, 8),
            s(16, 1.8, 8),
            s(16.2, 1.2, 8),
            s(3.5, 2.5, 8),
            s(9.5, 15.5, 8),
            s(10, 15.1, 8),
            s(10.5, 15.8, 8)
        }
        do
            local i = 0
            while i < 1 do
                local ____self_sprite_0 = self.sprite
                ____self_sprite_0[#____self_sprite_0 + 1] = s(
                    20.5,
                    11.5,
                    math.random(11, 12)
                )
                local ____self_mobs_1 = self.mobs
                ____self_mobs_1[#____self_mobs_1 + 1] = __TS__New(Mob, 20.5, 12.5, #self.sprite - 1)
                i = i + 1
            end
        end
        self.windowSize = create(self.BUFFER_SIZE_Y * self.BUFFERS_ARRAY_SIZE_X, self.BUFFER_SIZE_Y * self.BUFFERS_ARRAY_SIZE_X * (4 / 5))
        for ____, arr in ipairs(self.textures) do
            assert(#arr == self.texHeight * self.texWidth * CHANNELS)
            print(self.texHeight * self.texWidth * CHANNELS)
        end
        self.ZBuffer = __TS__ArrayFrom(
            {length = self.windowSize.x},
            function(____, _, i) return 0 end
        )
        self.spriteOrder = __TS__ArrayFrom(
            {length = #self.sprite},
            function(____, _, i) return 0 end
        )
        self.spriteDistance = __TS__ArrayFrom(
            {length = #self.sprite},
            function(____, _, i) return 0 end
        )
        local size = self.BUFFER_SIZE_X * self.BUFFER_SIZE_Y
        do
            local x = 0
            while x < self.BUFFERS_ARRAY_SIZE_X do
                do
                    local y = 0
                    while y < self.BUFFERS_ARRAY_SIZE_Y do
                        local ____self_buffers_2 = self.buffers
                        ____self_buffers_2[#____self_buffers_2 + 1] = __TS__ArrayFrom(
                            {length = size},
                            function(____, _, i) return (i + 1) % 4 == 0 and char(0) or char(0) end
                        )
                        local buffer_scale = self.enable4kPerformanceMode and create(2, 2) or create(1, 1)
                        self.renderer:addElement(
                            (("boomBuffer" .. tostring(x)) .. " ") .. tostring(y),
                            {
                                name = (("boomBuffer" .. tostring(x)) .. " ") .. tostring(y),
                                hud_elem_type = HudElementType.image,
                                position = create(0, 0),
                                text = "pixel.png",
                                scale = buffer_scale,
                                alignment = create(1, 1),
                                offset = create(self.windowPosition.x + self.BUFFER_SIZE_Y * x * (self.enable4kPerformanceMode and 2 or 1), self.windowPosition.y + self.BUFFER_SIZE_Y * y * (self.enable4kPerformanceMode and 2 or 1)),
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
        return x % self.BUFFERS_ARRAY_SIZE_X + y * self.BUFFERS_ARRAY_SIZE_X
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
    function Boom.prototype.flushBuffers(self)
        self.frameAccum = self.frameAccum + 1
        if self.frameAccum > self.buffering then
            self.frameAccum = 0
        else
            return
        end
        do
            local x = 0
            while x < self.BUFFERS_ARRAY_SIZE_X do
                do
                    local y = 0
                    while y < self.BUFFERS_ARRAY_SIZE_Y do
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
        if self.system:isMouseClicked() then
            self.currentBullet = __TS__New(
                Bullet,
                self.playerPos.x,
                self.playerPos.y,
                self.playerDir.x,
                self.playerDir.y
            )
            self.audioController:playSound("gunshot", 1)
        end
        local moveSpeed = delta * 5
        if self.system:isKeyDown("up") then
            if self.worldMap[floor(self.playerPos.x + self.playerDir.x * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_3, ____x_4 = self.playerPos, "x"
                ____self_playerPos_3[____x_4] = ____self_playerPos_3[____x_4] + self.playerDir.x * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y + self.playerDir.y * moveSpeed) + 1] == 0 then
                local ____self_playerPos_5, ____y_6 = self.playerPos, "y"
                ____self_playerPos_5[____y_6] = ____self_playerPos_5[____y_6] + self.playerDir.y * moveSpeed
            end
        end
        if self.system:isKeyDown("down") then
            if self.worldMap[floor(self.playerPos.x - self.playerDir.x * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_7, ____x_8 = self.playerPos, "x"
                ____self_playerPos_7[____x_8] = ____self_playerPos_7[____x_8] - self.playerDir.x * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y - self.playerDir.y * moveSpeed) + 1] == 0 then
                local ____self_playerPos_9, ____y_10 = self.playerPos, "y"
                ____self_playerPos_9[____y_10] = ____self_playerPos_9[____y_10] - self.playerDir.y * moveSpeed
            end
        end
        if self.system:isKeyDown("right") then
            if self.worldMap[floor(self.playerPos.x + self.planeX * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_11, ____x_12 = self.playerPos, "x"
                ____self_playerPos_11[____x_12] = ____self_playerPos_11[____x_12] + self.planeX * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y + self.planeY * moveSpeed) + 1] == 0 then
                local ____self_playerPos_13, ____y_14 = self.playerPos, "y"
                ____self_playerPos_13[____y_14] = ____self_playerPos_13[____y_14] + self.planeY * moveSpeed
            end
        end
        if self.system:isKeyDown("left") then
            if self.worldMap[floor(self.playerPos.x - self.planeX * moveSpeed) + 1][floor(self.playerPos.y) + 1] == 0 then
                local ____self_playerPos_15, ____x_16 = self.playerPos, "x"
                ____self_playerPos_15[____x_16] = ____self_playerPos_15[____x_16] - self.planeX * moveSpeed
            end
            if self.worldMap[floor(self.playerPos.x) + 1][floor(self.playerPos.y - self.planeY * moveSpeed) + 1] == 0 then
                local ____self_playerPos_17, ____y_18 = self.playerPos, "y"
                ____self_playerPos_17[____y_18] = ____self_playerPos_17[____y_18] - self.planeY * moveSpeed
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
    function Boom.prototype.sortSprites(self)
        local amount = #self.sprite
        local sprites = __TS__ArrayFrom(
            {length = amount},
            function(____, _, i) return {0, 0} end
        )
        local order = self.spriteOrder
        local dist = self.spriteDistance
        do
            local i = 0
            while i < amount do
                sprites[i + 1][1] = dist[i + 1]
                sprites[i + 1][2] = order[i + 1]
                i = i + 1
            end
        end
        table.sort(
            sprites,
            function(a, b) return a[1] < b[1] end
        )
        do
            local i = 0
            while i < amount do
                dist[i + 1] = sprites[amount - i][1]
                order[i + 1] = sprites[amount - i][2]
                i = i + 1
            end
        end
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
        local screenHeight = h
        local screenWidth = w
        do
            local y = 0
            while y < h do
                local rayDirX0 = dirX - planeX
                local rayDirY0 = dirY - planeY
                local rayDirX1 = dirX + planeX
                local rayDirY1 = dirY + planeY
                local p = y - screenHeight / 2
                local posZ = 0.5 * screenHeight
                local rowDistance = posZ / p
                local floorStepX = rowDistance * (rayDirX1 - rayDirX0) / screenWidth
                local floorStepY = rowDistance * (rayDirY1 - rayDirY0) / screenWidth
                local floorX = posX + rowDistance * rayDirX0
                local floorY = posY + rowDistance * rayDirY0
                do
                    local x = 0
                    while x < screenWidth do
                        local cellX = floor(floorX)
                        local cellY = floor(floorY)
                        local tx = floor(bit.band(self.texWidth * (floorX - cellX), self.texWidth - 1))
                        local ty = floor(bit.band(self.texHeight * (floorY - cellY), self.texHeight - 1))
                        if self.performanceMode then
                            tx = floor(tx / 4) * 4
                            ty = floor(ty / 4) * 4
                        end
                        floorX = floorX + floorStepX
                        floorY = floorY + floorStepY
                        local floorTexture = 3
                        local ceilingTexture = 6
                        do
                            local container = self.textures[floorTexture + 1]
                            local index = (self.texWidth * ty + tx) * CHANNELS
                            local r = container[index + 1]
                            local g = container[index + 1 + 1]
                            local b = container[index + 2 + 1]
                            self:drawPixel(
                                x,
                                y,
                                r,
                                g,
                                b
                            )
                        end
                        do
                            local container = self.textures[ceilingTexture + 1]
                            local index = (self.texWidth * ty + tx) * CHANNELS
                            local r = container[index + 1]
                            local g = container[index + 1 + 1]
                            local b = container[index + 2 + 1]
                            r = bit.band(
                                bit.rshift(r, 1),
                                8355711
                            )
                            g = bit.band(
                                bit.rshift(g, 1),
                                8355711
                            )
                            b = bit.band(
                                bit.rshift(b, 1),
                                8355711
                            )
                            self:drawPixel(
                                x,
                                screenHeight - y - 1,
                                r,
                                g,
                                b
                            )
                        end
                        x = x + 1
                    end
                end
                y = y + 1
            end
        end
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
                local texX = 0
                if self.performanceMode then
                    local precision = 64
                    local divisor = 4
                    texX = floor(floor(wallX * precision / divisor) * divisor / precision * self.texWidth)
                else
                    texX = floor(wallX * self.texWidth)
                end
                if side == 0 and rayDirX > 0 then
                    texX = self.texWidth - texX - 1
                end
                if side == 1 and rayDirY < 0 then
                    texX = self.texWidth - texX - 1
                end
                local texNum = self.worldMap[mapX + 1][mapY + 1] - 1
                local step = 1 * self.texHeight / lineHeight
                local texPos = (drawStart - h / 2 + lineHeight / 2) * step
                do
                    local y = drawStart
                    while y < drawEnd do
                        local texY = 0
                        if self.performanceMode then
                            texY = bit.band(
                                floor(texPos / 4) * 4,
                                self.texHeight - 1
                            )
                        else
                            texY = bit.band(
                                floor(texPos),
                                self.texHeight - 1
                            )
                        end
                        texPos = texPos + step
                        local container = self.textures[texNum + 1]
                        local index = (self.texHeight * texY + texX) * CHANNELS
                        local r = container[index + 1]
                        local g = container[index + 1 + 1]
                        local b = container[index + 2 + 1]
                        if side == 1 then
                            r = bit.band(
                                bit.rshift(r, 1),
                                8355711
                            )
                            g = bit.band(
                                bit.rshift(g, 1),
                                8355711
                            )
                            b = bit.band(
                                bit.rshift(b, 1),
                                8355711
                            )
                        end
                        self:drawPixel(
                            x,
                            y,
                            r,
                            g,
                            b
                        )
                        y = y + 1
                    end
                end
                self.ZBuffer[x + 1] = perpWallDist
                x = x + 1
            end
        end
        do
            local i = 0
            while i < #self.sprite do
                self.spriteOrder[i + 1] = i
                self.spriteDistance[i + 1] = (posX - self.sprite[i + 1].x) * (posX - self.sprite[i + 1].x) + (posY - self.sprite[i + 1].y) * (posY - self.sprite[i + 1].y)
                i = i + 1
            end
        end
        self:sortSprites()
        local numSprites = #self.sprite
        do
            local i = 0
            while i < numSprites do
                local spriteX = self.sprite[self.spriteOrder[i + 1] + 1].x - posX
                local spriteY = self.sprite[self.spriteOrder[i + 1] + 1].y - posY
                local invDet = 1 / (planeX * dirY - dirX * planeY)
                local transformX = invDet * (dirY * spriteX - dirX * spriteY)
                local transformY = invDet * (-planeY * spriteX + planeX * spriteY)
                local spriteScreenX = floor(w / 2 * (1 + transformX / transformY))
                local spriteHeight = abs(floor(h / transformY))
                local drawStartY = floor(-spriteHeight / 2 + h / 2)
                if drawStartY < 0 then
                    drawStartY = 0
                end
                local drawEndY = floor(spriteHeight / 2 + h / 2)
                if drawEndY >= h then
                    drawEndY = h - 1
                end
                local spriteWidth = abs(floor(h / transformY))
                local drawStartX = floor(-spriteWidth / 2 + spriteScreenX)
                if drawStartX < 0 then
                    drawStartX = 0
                end
                local drawEndX = spriteWidth / 2 + spriteScreenX
                if drawEndX >= w then
                    drawEndX = w - 1
                end
                do
                    local stripe = drawStartX
                    while stripe < drawEndX do
                        local texX = floor(256 * (stripe - (-spriteWidth / 2 + spriteScreenX)) * self.texWidth / spriteWidth / 256)
                        if transformY > 0 and stripe > 0 and stripe < w and transformY < self.ZBuffer[stripe + 1] then
                            do
                                local y = drawStartY
                                while y < drawEndY do
                                    local d = floor(y * 256 - h * 128 + spriteHeight * 128)
                                    local texY = floor(d * self.texHeight / spriteHeight / 256)
                                    local selectedTexture = self.sprite[self.spriteOrder[i + 1] + 1].texture
                                    local container = self.textures[selectedTexture + 1]
                                    local index = (self.texWidth * math.clamp(0, 16379, texY) + math.clamp(0, 16379, texX)) * CHANNELS
                                    local r = container[index + 1]
                                    local g = container[index + 1 + 1]
                                    local b = container[index + 2 + 1]
                                    local a = container[index + 3 + 1]
                                    if a > 0 then
                                        self:drawPixel(
                                            stripe,
                                            y,
                                            r,
                                            g,
                                            b
                                        )
                                    end
                                    y = y + 1
                                end
                            end
                        end
                        stripe = stripe + 1
                    end
                end
                i = i + 1
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
    function Boom.prototype.mobsThink(self, delta)
        local moveSpeed = delta * 5
        for ____, mob in ipairs(self.mobs) do
        end
    end
    function Boom.prototype.addBulletHole(self, x, z)
        local ____self_spriteOrder_19 = self.spriteOrder
        ____self_spriteOrder_19[#____self_spriteOrder_19 + 1] = 0
        local ____self_spriteDistance_20 = self.spriteDistance
        ____self_spriteDistance_20[#____self_spriteDistance_20 + 1] = 0
        local ____self_sprite_21 = self.sprite
        ____self_sprite_21[#____self_sprite_21 + 1] = s(x, z, 15)
    end
    function Boom.prototype.processBullet(self)
        if not self.currentBullet then
            return
        end
        local bullet = self.currentBullet
        local hitWall = false
        local hitMob = false
        local moveSpeed = 0.1
        while not hitWall and not hitMob do
            if self.worldMap[floor(bullet.x + bullet.dirX * moveSpeed) + 1][floor(bullet.y) + 1] == 0 then
                bullet.x = bullet.x + bullet.dirX * moveSpeed
            else
                hitWall = true
                break
            end
            if self.worldMap[floor(bullet.x) + 1][floor(bullet.y + bullet.dirY * moveSpeed) + 1] == 0 then
                bullet.y = bullet.y + bullet.dirY * moveSpeed
            else
                hitWall = true
                break
            end
            vecA.x = bullet.x
            vecA.y = bullet.y
            for ____, mob in ipairs(self.mobs) do
                vecB.x = mob.x
                vecB.y = mob.y
                local dist = vector.distance(vecA, vecB)
                if dist < 1 and mob.alive then
                    mob.alive = false
                    local ____self_sprite_index_22, ____texture_23 = self.sprite[mob.sprite + 1], "texture"
                    ____self_sprite_index_22[____texture_23] = ____self_sprite_index_22[____texture_23] + 2
                    hitMob = true
                    break
                end
            end
            if hitMob then
                break
            end
        end
        if hitMob then
            self.audioController:playSoundDelay("mobExplode", 1, 0.15)
            self.currentBullet = nil
        end
        if hitWall then
            if self.currentBullet ~= nil then
                self:addBulletHole(self.currentBullet.x, self.currentBullet.y)
            end
            self.audioController:playSoundDelay("bulletRicochet", 1, 0.15)
            self.currentBullet = nil
        end
    end
    function Boom.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        self:mobsThink(delta)
        self:playerControls(delta)
        self:processBullet()
        self:render(delta)
    end
    mineos.DesktopEnvironment:registerProgram(Boom)
end
