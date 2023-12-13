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
    local translationKey = {
        [0] = 0,
        [1] = 0.0594,
        [2] = 0.122,
        [3] = 0.189,
        [4] = 0.259,
        [5] = 0.334,
        [6] = 0.414,
        [7] = 0.498,
        [8] = 0.587,
        [9] = 0.681,
        [10] = 0.781,
        [11] = 0.887
    }
    local songRegistrationQueue = {}
    mineos.Song = __TS__Class()
    local Song = mineos.Song
    Song.name = "Song"
    function Song.prototype.____constructor(self, name)
        self.tempo = 20
        self.volume = 1
        self.data = {}
        self.finalizedArrayLength = -1
        self.name = name
    end
    function Song.prototype.finalize(self)
        local arraySize = -1
        for ____, ____value in ipairs(__TS__ObjectEntries(self.data)) do
            local instrument = ____value[1]
            local notes = ____value[2]
            do
                if arraySize == -1 then
                    arraySize = #notes
                    goto __continue5
                end
                if #notes ~= arraySize then
                    error(
                        __TS__New(Error, self.name .. " HAS MISMATCHED DATA!"),
                        0
                    )
                end
            end
            ::__continue5::
        end
        if arraySize == -1 then
            error(
                __TS__New(Error, self.name .. " IS AN EMPTY SONG!"),
                0
            )
        end
        self.finalizedArrayLength = arraySize
    end
    mineos.AudioController = __TS__Class()
    local AudioController = mineos.AudioController
    AudioController.name = "AudioController"
    function AudioController.prototype.____constructor(self, system)
        self.updated = true
        self.songs = {}
        self.currentSong = nil
        self.currentNote = 0
        self.accumulator = 0
        self.system = system
        while #songRegistrationQueue > 0 do
            do
                local song = table.remove(songRegistrationQueue)
                if song == nil then
                    goto __continue11
                end
                self.songs[song.name] = song
            end
            ::__continue11::
        end
    end
    function AudioController.registerSong(self, song)
        local system = mineos.getSystemOrNull()
        song:finalize()
        if system == nil then
            songRegistrationQueue[#songRegistrationQueue + 1] = song
            return
        end
        system.audioController.songs[song.name] = song
    end
    function AudioController.prototype.playSong(self, name)
        self.currentNote = 0
        self.accumulator = 0
        self.currentSong = self.songs[name]
        if self.currentSong == nil then
            error(
                __TS__New(Error, name .. " IS NOT A REGISTERED SONG!"),
                0
            )
        end
    end
    function AudioController.prototype.stopSong(self)
        self.currentSong = nil
    end
    function AudioController.prototype.update(self, delta)
        if self.updated then
            return
        end
        self.updated = true
        if self.currentSong == nil then
            return
        end
        local goalTimer = 1 / self.currentSong.tempo
        self.accumulator = self.accumulator + delta
        if self.accumulator >= goalTimer then
            self.accumulator = self.accumulator - goalTimer
            for ____, ____value in ipairs(__TS__ObjectEntries(self.currentSong.data)) do
                local instrument = ____value[1]
                local data = ____value[2]
                self:playNote(instrument, data[self.currentNote + 1], self.currentSong.volume)
            end
            self.currentNote = self.currentNote + 1
            if self.currentNote >= self.currentSong.finalizedArrayLength then
                self.currentNote = 0
            end
        end
    end
    function AudioController.prototype.playNote(self, instrument, pitch, volume)
        if volume == nil then
            volume = 1
        end
        if pitch == -1 then
            return
        end
        local fPitch = 1 + translationKey[pitch]
        minetest.sound_play({name = instrument}, {to_player = "singleplayer", gain = volume, pitch = fPitch})
    end
    function AudioController.prototype.playSound(self, name, volume, fade)
        return minetest.sound_play({name = name}, {to_player = "singleplayer", gain = volume, fade = fade})
    end
    function AudioController.prototype.playSoundDelay(self, name, volume, delay)
        minetest.after(
            delay,
            function()
                minetest.sound_play({name = name}, {to_player = "singleplayer", gain = volume})
            end
        )
    end
    function AudioController.prototype.playSoundRepeat(self, name, volume, fade)
        return minetest.sound_play({name = name}, {to_player = "singleplayer", gain = volume, fade = fade, loop = true})
    end
end
