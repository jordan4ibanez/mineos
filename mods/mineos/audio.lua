-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    mineos.AudioController = __TS__Class()
    local AudioController = mineos.AudioController
    AudioController.name = "AudioController"
    function AudioController.prototype.____constructor(self, system)
        self.system = system
    end
    function AudioController.prototype.playSound(self, name, volume, fade)
        return minetest.sound_play({name = name}, {to_player = "singleplayer", gain = volume, fade = fade})
    end
    function AudioController.prototype.playSoundRepeat(self, name, volume, fade)
        return minetest.sound_play({name = name}, {to_player = "singleplayer", gain = volume, fade = fade, loop = true})
    end
end
