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
    local BootProcedure = __TS__Class()
    BootProcedure.name = "BootProcedure"
    __TS__ClassExtends(BootProcedure, mineos.Program)
    function BootProcedure.prototype.____constructor(self, ...)
        BootProcedure.____super.prototype.____constructor(self, ...)
        self.timer = 0
        self.colorAmount = 0
        self.color = vector.create(0, 0, 0)
        self.impatience = 8
        self.hit = false
        self.colorFadeMultiplier = 0.75
        self.dots = 0
        self.dotsAccum = 0
    end
    function BootProcedure.prototype.main(self, delta)
        if self.timer == 0 then
        end
        self.timer = self.timer + delta
        if self.timer > self.impatience then
            self.iMem = 1
            return
        end
        if self.colorAmount < 1 then
            self.colorAmount = self.colorAmount + delta * self.colorFadeMultiplier
            if self.colorAmount >= 1 then
                self.colorAmount = 1
            end
            self.renderer:setClearColor(91.7 / 4 * self.colorAmount, 90.5 / 4 * self.colorAmount, 88 / 4 * self.colorAmount)
        else
            if not self.hit then
                self.hit = true
                mineos.System.out:println("added logo")
                local centerX = self.renderer.frameBufferScale.x / 2
                self.renderer:addElement(
                    "mineosLogo",
                    __TS__New(
                        gui.Image,
                        {
                            position = vector.create2d(centerX - 4, 0.9),
                            size = vector.create2d(8, 8),
                            texture = "minetest.png"
                        }
                    )
                )
                self.renderer:addElement(
                    "mineosLoading",
                    __TS__New(
                        gui.Label,
                        {
                            position = vector.create2d(centerX - 1.7, 10),
                            label = mineos.colorize(
                                colors.colorScalar(100),
                                "loading mineos"
                            )
                        }
                    )
                )
            else
                local loadingThing = self.renderer.getElement("mineosLoading")
                self.dotsAccum = self.dotsAccum + delta
                if self.dotsAccum >= 0.25 then
                    self.dots = self.dots + 1
                    if self.dots > 3 then
                        self.dots = 0
                    end
                    self.dotsAccum = self.dotsAccum - 0.25
                end
                local textAccum = "loading mineos"
                do
                    local i = 0
                    while i < self.dots do
                        textAccum = textAccum .. "."
                        i = i + 1
                    end
                end
                loadingThing.label = textAccum
            end
        end
    end
    mineos.System:registerProgram(BootProcedure)
end
