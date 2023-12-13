-- Lua Library inline imports
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
    local function mapToTexture(tileID)
        repeat
            local ____switch4 = tileID
            local ____cond4 = ____switch4 == 0
            if ____cond4 then
                return "bg_tile.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 1
            if ____cond4 then
                return "fg_tile.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 2
            if ____cond4 then
                return "blue_lock.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 3
            if ____cond4 then
                return "red_lock.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 4
            if ____cond4 then
                return "yellow_lock.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 5
            if ____cond4 then
                return "green_lock.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 6
            if ____cond4 then
                return "blue_key.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 7
            if ____cond4 then
                return "red_key.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 8
            if ____cond4 then
                return "yellow_key.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 9
            if ____cond4 then
                return "green_key.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 10
            if ____cond4 then
                return "chip.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 11
            if ____cond4 then
                return "chip_socket.png"
            end
            ____cond4 = ____cond4 or ____switch4 == 12
            if ____cond4 then
                return "exit.png"
            end
            do
                error(
                    __TS__New(
                        Error,
                        "How did this even get a different value? " .. tostring(tileID)
                    ),
                    0
                )
            end
        until true
    end
    local _ = 0
    local w = 1
    local B = 2
    local R = 3
    local Y = 4
    local G = 5
    local b = 6
    local r = 7
    local y = 8
    local g = 9
    local C = 10
    local S = 11
    local E = 12
    local BitsBattle = __TS__Class()
    BitsBattle.name = "BitsBattle"
    __TS__ClassExtends(BitsBattle, mineos.WindowProgram)
    function BitsBattle.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
        BitsBattle.____super.prototype.____constructor(
            self,
            system,
            renderer,
            audio,
            desktop,
            windowSize
        )
        self.loaded = false
        self.instance = 0
        self.chipsRemaining = 11
        self.MAP_WIDTH = 17
        self.MAP_HEIGHT = 16
        self.map = {
            {
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                w,
                w,
                w,
                w,
                w,
                _,
                w,
                w,
                w,
                w,
                w,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                w,
                _,
                _,
                _,
                w,
                w,
                w,
                _,
                _,
                _,
                w,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                w,
                _,
                C,
                _,
                w,
                E,
                w,
                _,
                C,
                _,
                w,
                _,
                _,
                _
            },
            {
                _,
                w,
                w,
                w,
                w,
                w,
                G,
                w,
                S,
                w,
                G,
                w,
                w,
                w,
                w,
                w,
                _
            },
            {
                _,
                w,
                _,
                y,
                _,
                B,
                _,
                _,
                _,
                _,
                _,
                R,
                _,
                y,
                _,
                w,
                _
            },
            {
                _,
                w,
                _,
                C,
                _,
                w,
                b,
                _,
                _,
                _,
                r,
                w,
                _,
                C,
                _,
                w,
                _
            },
            {
                _,
                w,
                w,
                w,
                w,
                w,
                C,
                _,
                _,
                _,
                C,
                w,
                w,
                w,
                w,
                w,
                _
            },
            {
                _,
                w,
                _,
                C,
                _,
                w,
                b,
                _,
                _,
                _,
                r,
                w,
                _,
                C,
                _,
                w,
                _
            },
            {
                _,
                w,
                _,
                _,
                _,
                R,
                _,
                _,
                C,
                _,
                _,
                B,
                _,
                _,
                _,
                w,
                _
            },
            {
                _,
                w,
                w,
                w,
                w,
                w,
                w,
                Y,
                w,
                Y,
                w,
                w,
                w,
                w,
                w,
                w,
                _
            },
            {
                _,
                _,
                _,
                _,
                _,
                w,
                _,
                _,
                w,
                _,
                _,
                w,
                _,
                _,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                _,
                _,
                w,
                _,
                C,
                w,
                C,
                _,
                w,
                _,
                _,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                _,
                _,
                w,
                _,
                g,
                w,
                g,
                _,
                w,
                _,
                _,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                _,
                _,
                w,
                w,
                w,
                w,
                w,
                w,
                w,
                _,
                _,
                _,
                _,
                _
            },
            {
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _,
                _
            }
        }
        self.VISIBLE_SIZE = 9
        self.TILE_PIXEL_SIZE = 32
        self.TILE_SCALE = 1.5
        self.TILE_OFFSET = 32
        self.pos = create(8, 7)
        self.instance = BitsBattle.counter
        BitsBattle.counter = BitsBattle.counter + 1
        assert(#self.map == self.MAP_HEIGHT)
        for ____, arr in ipairs(self.map) do
            assert(#arr == self.MAP_WIDTH)
        end
        self.windowSize.x = 640
        self.windowSize.y = 480
        self:updateHandleWidth(640)
        self.renderer:addElement(
            "chips_challenge_bg" .. tostring(self.instance),
            {
                name = "chips_challenge_bg_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(70, 70, 70)) .. ":255",
                scale = self.windowSize,
                alignment = create(1, 1),
                offset = create(
                    self:getPosX(),
                    self:getPosY()
                ),
                z_index = 1
            }
        )
        local startX = self.pos.x - 4
        local startY = self.pos.y - 4
        do
            local x = 0
            while x < self.VISIBLE_SIZE do
                do
                    local y = 0
                    while y < self.VISIBLE_SIZE do
                        do
                            local layer = 0
                            while layer <= 1 do
                                local realX = x + startX
                                local realY = y + startY
                                local tex = layer == 1 and "nothing.png" or "bg_tile.png"
                                self.renderer:addElement(
                                    self:grabTileKey(x, y, layer),
                                    {
                                        name = self:grabTileKey(x, y, layer),
                                        hud_elem_type = HudElementType.image,
                                        position = create(0, 0),
                                        text = tex,
                                        scale = create(self.TILE_SCALE, self.TILE_SCALE),
                                        alignment = create(1, 1),
                                        offset = create(
                                            self:getPosX() + x * (self.TILE_PIXEL_SIZE * self.TILE_SCALE) + self.TILE_OFFSET,
                                            self:getPosY() + y * (self.TILE_PIXEL_SIZE * self.TILE_SCALE) + self.TILE_OFFSET
                                        ),
                                        z_index = 1
                                    }
                                )
                                layer = layer + 1
                            end
                        end
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
        self:update()
        self:setWindowTitle("Bit's Battle")
    end
    function BitsBattle.prototype.update(self)
        local startX = self.pos.x - 4
        local startY = self.pos.y - 4
        do
            local x = 0
            while x < self.VISIBLE_SIZE do
                do
                    local y = 0
                    while y < self.VISIBLE_SIZE do
                        local realX = x + startX
                        local realY = y + startY
                        local texture = mapToTexture(self.map[realY + 1][realX + 1])
                        if realX == self.pos.x and realY == self.pos.y then
                            texture = "bit_byte.png"
                        end
                        self.renderer:setElementComponentValue(
                            self:grabTileKey(x, y, 1),
                            "text",
                            texture
                        )
                        y = y + 1
                    end
                end
                x = x + 1
            end
        end
    end
    function BitsBattle.prototype.grabTileKey(self, x, y, layer)
        return (((((("chips_challenge_tile_" .. tostring(x)) .. "_") .. tostring(y)) .. "_") .. tostring(layer)) .. "_") .. tostring(self.instance)
    end
    function BitsBattle.prototype.move(self)
        print("moving bits battle")
        self.renderer:setElementComponentValue(
            "chips_challenge_bg" .. tostring(self.instance),
            "offset",
            self.windowPosition
        )
    end
    function BitsBattle.prototype.destructor(self)
        print("bits battle destroyed")
        self.renderer:removeElement("chips_challenge_bg" .. tostring(self.instance))
    end
    function BitsBattle.prototype.load(self)
        mineos.System.out:println("Loading Bits' Battle!")
        local bitsTheme = __TS__New(mineos.Song, "bitsTheme")
        bitsTheme.tempo = 5.5
        bitsTheme.data.bassTrumpet = {
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2
        }
        bitsTheme.data.trumpet = {
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            -1,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            0,
            7,
            0,
            2,
            4,
            0,
            7,
            2,
            0,
            5,
            4,
            0,
            7,
            2
        }
        mineos.AudioController:registerSong(bitsTheme)
        self.audioController:playSong("bitsTheme")
        self.loaded = true
        mineos.System.out:println("Bit's Battle loaded!")
    end
    function BitsBattle.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        print((("bits battle instance " .. tostring(self.instance)) .. " is running ") .. tostring(delta))
        self.audioController:update(delta)
    end
    BitsBattle.counter = 0
    mineos.DesktopEnvironment:registerProgram(BitsBattle)
end
