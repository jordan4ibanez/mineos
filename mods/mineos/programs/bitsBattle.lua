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
    local create = vector.create2d
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
        self.map = {{
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
        }}
        self.instance = BitsBattle.counter
        BitsBattle.counter = BitsBattle.counter + 1
        self.renderer:addElement(
            "chips_challenge_bg" .. tostring(self.instance),
            {
                name = "chips_challenge_bg_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(60, 60, 60)) .. ":255",
                scale = self.windowSize,
                alignment = create(1, 1),
                offset = create(
                    self:getPosX(),
                    self:getPosY()
                ),
                z_index = 1
            }
        )
        self:setWindowTitle("Bit's Battle")
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
