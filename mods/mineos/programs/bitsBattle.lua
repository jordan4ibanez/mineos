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

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local BitsBattle = __TS__Class()
    BitsBattle.name = "BitsBattle"
    __TS__ClassExtends(BitsBattle, mineos.Program)
    function BitsBattle.prototype.____constructor(self, ...)
        BitsBattle.____super.prototype.____constructor(self, ...)
        self.loaded = false
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
        self.audioController:update(delta)
    end
    mineos.System:registerProgram(BitsBattle)
end
