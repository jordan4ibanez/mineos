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

local function __TS__ObjectEntries(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = {key, obj[key]}
    end
    return result
end

local function __TS__ObjectGetOwnPropertyDescriptors(object)
    local metatable = getmetatable(object)
    if not metatable then
        return {}
    end
    return rawget(metatable, "_descriptors") or ({})
end

local function __TS__Delete(target, key)
    local descriptors = __TS__ObjectGetOwnPropertyDescriptors(target)
    local descriptor = descriptors[key]
    if descriptor then
        if not descriptor.configurable then
            error(
                __TS__New(
                    TypeError,
                    ((("Cannot delete property " .. tostring(key)) .. " of ") .. tostring(target)) .. "."
                ),
                0
            )
        end
        descriptors[key] = nil
        return true
    end
    target[key] = nil
    return true
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
    function System.prototype.____constructor(self)
        self.renderer = __TS__New(mineos.Renderer, self)
        self.audioController = __TS__New(mineos.AudioController, self)
        self.skipToDesktopHackjob = true
        self.booting = true
        self.bootProcess = 0
        self.running = false
        self.quitReceived = false
        self.programs = {}
        self.callbacks = {}
        self.currentProgram = nil
        self.currentProgramName = ""
        self.mousePos = vector.create2d(0, 0)
        if currentSystem ~= nil then
            error(
                __TS__New(Error, "Cannot create more than one instance of mineos."),
                0
            )
        end
        currentSystem = self
        self:receivePrograms()
    end
    function System.prototype.getRenderer(self)
        return self.renderer
    end
    function System.prototype.getAudioController(self)
        return self.audioController
    end
    function System.prototype.isKeyDown(self, keyName)
        return mineos.osKeyboardPoll(keyName)
    end
    function System.prototype.registerCallback(self, name, callback)
        self.callbacks[name] = callback
    end
    function System.prototype.triggerCallbacks(self, fields)
        for ____, ____value in ipairs(__TS__ObjectEntries(fields)) do
            local name = ____value[1]
            local thing = ____value[2]
            local pulledCallback = self.callbacks[name]
            if pulledCallback == nil then
                return
            end
            pulledCallback(thing)
        end
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
        if self.skipToDesktopHackjob then
            mineos.System.out:println("HACK: SKIPPED BOOT PROCEDURE!")
            self.booting = false
            self.running = true
            self:changeProgram("BitsBattle")
            return
        end
        self.booting = true
        self.running = true
        self.audioController:playSound("caseButton", 1)
        self.audioController:playSoundRepeat("hardDrive", 0.5, 0.2)
        mineos.System.out:println("power button pushed.")
        mineos.System.out:println("starting computer.")
    end
    function System.prototype.clearCallbacks(self)
        for ____, ____value in ipairs(__TS__ObjectEntries(self.callbacks)) do
            local name = ____value[1]
            local _ = ____value[2]
            __TS__Delete(self.callbacks, name)
        end
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
        self:changeProgram("RunProcedure")
    end
    function System.prototype.changeProgram(self, newProgramName)
        print("this is a program")
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
        self.renderer.frameBufferSize = input[1]
        self.renderer.frameBufferScale = input[2]
    end
    function System.prototype.doRender(self, delta)
    end
    function System.prototype.getFrameBuffer(self)
        return self.renderer.buffer
    end
    function System.prototype.main(self, delta)
        if not self.running then
            return
        end
        if self.quitReceived then
            return
        end
        self:updateFrameBuffer({mineos.osFrameBufferPoll()})
        if self.booting then
            self:doBoot(delta)
        else
            self:doRun(delta)
        end
        self:doRender(delta)
    end
    System.out = Printer
end
