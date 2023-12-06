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
    mineos.Program = __TS__Class()
    local Program = mineos.Program
    Program.name = "Program"
    function Program.prototype.____constructor(self, system, renderer, audioController)
        self.iMem = 0
        self.system = system
        self.renderer = renderer
        self.audioController = audioController
    end
    function Program.prototype.main(self, delta)
    end
    mineos.loadFiles({"programs/boot_loader", "programs/os_loader", "programs/desktop"})
    mineos.System.out:println("programs loaded!")
end
