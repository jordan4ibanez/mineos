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
    local currentSystem = nil
    local registrationQueue = {}
    function mineos.getSystem()
        if currentSystem == nil then
            error(
                __TS__New(Error, "system is not created."),
                0
            )
        end
        return currentSystem
    end
    function mineos.getSystemOrNull()
        return currentSystem
    end
    local Printer = __TS__Class()
    Printer.name = "Printer"
    function Printer.prototype.____constructor(self)
    end
    function Printer.println(self, ...)
        print(...)
    end
    function Printer.dump(self, ...)
        local anything = {...}
        print(dump(anything))
    end
    mineos.System = __TS__Class()
    local System = mineos.System
    System.name = "System"
    function System.prototype.____constructor(self, driver)
        self.audioController = __TS__New(mineos.AudioController, self)
        self.driver = nil
        self.skipToDesktopHackjob = false
        self.booting = true
        self.bootProcess = 0
        self.running = false
        self.quitReceived = false
        self.mouseDelta = vector.create2d(0, 0)
        self.programs = {}
        self.currentProgram = nil
        self.currentProgramName = ""
        self.mousePos = vector.create2d(0, 0)
        self.mouseWasClicked = false
        self.mouseClicked = false
        self.mouseDown = false
        if currentSystem ~= nil then
            error(
                __TS__New(Error, "Cannot create more than one instance of mineos."),
                0
            )
        end
        currentSystem = self
        self.driver = driver
        self.renderer = __TS__New(mineos.Renderer, self)
        self:receivePrograms()
    end
    function System.prototype.getRenderer(self)
        return self.renderer
    end
    function System.prototype.setDriver(self, driver)
        self.driver = driver
    end
    function System.prototype.getDriver(self)
        if self.driver == nil then
            error(
                __TS__New(Error, "Attempted to get driver before available."),
                0
            )
        end
        return self.driver
    end
    function System.prototype.getAudioController(self)
        return self.audioController
    end
    function System.prototype.isKeyDown(self, keyName)
        return mineos.osKeyboardPoll(keyName)
    end
    function System.prototype.receivePrograms(self)
        while #registrationQueue > 0 do
            local name, prog = unpack(table.remove(registrationQueue))
            self.programs[name] = prog
        end
    end
    function System.registerProgram(self, program)
        local progName = program.prototype.constructor.name
        if currentSystem == nil then
            registrationQueue[#registrationQueue + 1] = {progName, program}
        else
            currentSystem.programs[progName] = program
        end
    end
    function System.prototype.triggerBoot(self)
        self.booting = true
        self.running = true
        if self.skipToDesktopHackjob then
            self:finishBoot()
            return
        end
        self.audioController:playSound("caseButton", 1)
        self.audioController:playSoundRepeat("hardDrive", 0.5, 0.2)
        mineos.System.out:println("power button pushed.")
        mineos.System.out:println("starting computer.")
    end
    function System.prototype.doBoot(self, delta)
        if self.bootProcess == 0 then
            if self.currentProgramName ~= "BiosProcedure" then
                self:changeProgram("BiosProcedure")
            end
            local ____opt_0 = self.currentProgram
            if (____opt_0 and ____opt_0.iMem) == 1 then
                self:changeProgram("BootProcedure")
                self.bootProcess = self.bootProcess + 1
            end
        elseif self.bootProcess == 1 then
            if self.currentProgramName ~= "BootProcedure" then
                self:changeProgram("BootProcedure")
            end
            local ____opt_2 = self.currentProgram
            if (____opt_2 and ____opt_2.iMem) == 1 then
                self:finishBoot()
            end
        end
        local ____opt_4 = self.currentProgram
        if ____opt_4 ~= nil then
            ____opt_4:main(delta)
        end
    end
    function System.prototype.finishBoot(self)
        self.bootProcess = 2
        self.booting = false
        self:changeProgram("DesktopEnvironment")
    end
    function System.prototype.changeProgram(self, newProgramName)
        self.currentProgramName = newProgramName
        self.currentProgram = __TS__New(self.programs[newProgramName], self, self.renderer, self.audioController)
    end
    function System.prototype.doRun(self, delta)
        if self.currentProgram == nil then
            mineos.System.out:println("ERROR: NO CURRENT PROGRAM.")
            return
        end
        self.currentProgram:main(delta)
    end
    function System.prototype.sendQuitSignal(self)
        mineos.System.out:println("quit signal received.")
        self.quitReceived = true
    end
    function System.prototype.updateFrameBuffer(self, input)
        local size = input[1]
        local scale = input[2]
        self.renderer.frameBufferSize = vector.create2d(size.x / scale, size.y / scale)
        self.renderer.frameBufferScale = scale
    end
    function System.prototype.pollMouse(self)
        if self.driver == nil then
            return
        end
        local precision = 100000
        local trimmedPi = math.floor(math.pi * precision) / precision
        local trimmedHorizontal = math.floor(self.driver:get_look_horizontal() * precision) / precision
        self.mouseDelta.x = trimmedPi - trimmedHorizontal
        self.mouseDelta.y = self.driver:get_look_vertical()
        self.driver:set_look_horizontal(math.pi)
        self.driver:set_look_vertical(0)
        local isClick = self.driver:get_player_control().LMB
        self.mouseDown = isClick
        if not self.mouseWasClicked and isClick then
            self.mouseClicked = true
        else
            self.mouseClicked = false
        end
        self.mouseWasClicked = isClick
    end
    function System.prototype.isMouseClicked(self)
        return self.mouseClicked
    end
    function System.prototype.isMouseDown(self)
        return self.mouseDown
    end
    function System.prototype.getMouseDelta(self)
        return self.mouseDelta
    end
    function System.prototype.requestShutdown(self)
        minetest.request_shutdown()
    end
    function System.prototype.main(self, delta)
        if not self.running then
            return
        end
        if self.quitReceived then
            return
        end
        self.audioController.updated = false
        self:updateFrameBuffer({mineos.osFrameBufferPoll()})
        self:pollMouse()
        if self.booting then
            self:doBoot(delta)
        else
            self:doRun(delta)
        end
    end
    System.out = Printer
end
