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
    mineos.ProgramBase = __TS__Class()
    local ProgramBase = mineos.ProgramBase
    ProgramBase.name = "ProgramBase"
    function ProgramBase.prototype.____constructor(self, system)
        self.system = nil
        self.system = system
    end
    local programFoundation = {}
    local function injectStates()
        return programFoundation
    end
end
