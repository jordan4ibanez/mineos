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
    local BiosProcedure = __TS__Class()
    BiosProcedure.name = "BiosProcedure"
    __TS__ClassExtends(BiosProcedure, mineos.Program)
    function BiosProcedure.prototype.____constructor(self, ...)
        BiosProcedure.____super.prototype.____constructor(self, ...)
        self.timer = 0
        self.stateTimer = 0
        self.state = 0
        self.increments = 0.5
        self.memoryCounter = 0
        self.impatience = 1
    end
    function BiosProcedure.prototype.main(self, delta)
        if self.timer == 0 then
            mineos.System.out:println("bios started")
        end
        self.timer = self.timer + delta
        self.stateTimer = self.stateTimer + delta
        if self.stateTimer > self.increments then
            repeat
                local ____switch6 = self.state
                local ____cond6 = ____switch6 == 5
                if ____cond6 then
                    do
                        self.audioController:playSound("computerBeep", 1)
                        self.renderer:addElement(
                            "bioLogo",
                            __TS__New(
                                gui.Image,
                                {
                                    position = vector.create2d(0.5, 0.9),
                                    size = vector.create2d(2, 2),
                                    texture = "minetest.png"
                                }
                            )
                        )
                        self.renderer:addElement(
                            "biosText",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(3, 2),
                                    label = mineos.colorize(
                                        colors.color(100, 0, 0),
                                        "Minetest Megablocks"
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 6
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "cpuDetection",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(0.5, 5),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "Detecting cpu..."
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 8
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "cpuDetectionPass",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(3.5, 5),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "MineRyzen 1300W detected."
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 9
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "memCheck",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(0.5, 7),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "Total Memory:"
                                    )
                                }
                            )
                        )
                        self.renderer:addElement(
                            "memCheckProgress",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(3.2, 7),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "0 KB"
                                    )
                                }
                            )
                        )
                        self.stateTimer = 10
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 10
                if ____cond6 then
                    do
                        self.stateTimer = 10
                        local memCheck = self.renderer:getElement("memCheckProgress")
                        self.memoryCounter = self.memoryCounter + (10 + math.floor(math.random() * 10)) * self.impatience
                        memCheck.label = tostring(self.memoryCounter) .. " KB"
                        if self.memoryCounter >= 4096 then
                            memCheck.label = tostring(4096) .. " KB"
                            self.stateTimer = 0
                            self.state = self.state + 1
                        end
                        return
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 11
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "blockCheck",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(0.5, 9),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "Checking nodes..."
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 13
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "blockCheckPassed",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(3.9, 9),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "passed."
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 15
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "allPassed",
                            __TS__New(
                                gui.Label,
                                {
                                    position = vector.create2d(0.5, 11),
                                    label = mineos.colorize(
                                        colors.colorScalar(100),
                                        "All system checks passed."
                                    )
                                }
                            )
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 16
                if ____cond6 then
                    do
                        self.iMem = 1
                        self.renderer:clearMemory()
                    end
                    break
                end
            until true
            self.state = self.state + 1
            self.stateTimer = self.stateTimer - self.increments
        end
    end
    mineos.System:registerProgram(BiosProcedure)
end