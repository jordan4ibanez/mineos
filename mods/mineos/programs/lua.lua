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

local function __TS__StringTrim(self)
    local result = string.gsub(self, "^[%s ﻿]*(.-)[%s ﻿]*$", "%1")
    return result
end

local __TS__StringSplit
do
    local sub = string.sub
    local find = string.find
    function __TS__StringSplit(source, separator, limit)
        if limit == nil then
            limit = 4294967295
        end
        if limit == 0 then
            return {}
        end
        local result = {}
        local resultIndex = 1
        if separator == nil or separator == "" then
            for i = 1, #source do
                result[resultIndex] = sub(source, i, i)
                resultIndex = resultIndex + 1
            end
        else
            local currentPos = 1
            while resultIndex <= limit do
                local startPos, endPos = find(source, separator, currentPos, true)
                if not startPos then
                    break
                end
                result[resultIndex] = sub(source, currentPos, startPos - 1)
                resultIndex = resultIndex + 1
                currentPos = endPos + 1
            end
            if resultIndex <= limit then
                result[resultIndex] = sub(source, currentPos)
            end
        end
        return result
    end
end

local function __TS__ArraySlice(self, first, last)
    local len = #self
    first = first or 0
    if first < 0 then
        first = len + first
        if first < 0 then
            first = 0
        end
    else
        if first > len then
            first = len
        end
    end
    last = last or len
    if last < 0 then
        last = len + last
        if last < 0 then
            last = 0
        end
    else
        if last > len then
            last = len
        end
    end
    local out = {}
    first = first + 1
    last = last + 1
    local n = 1
    while first < last do
        out[n] = self[first]
        first = first + 1
        n = n + 1
    end
    return out
end

local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        asyncDispose = __TS__Symbol("Symbol.asyncDispose"),
        dispose = __TS__Symbol("Symbol.dispose"),
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local __TS__Iterator
do
    local function iteratorGeneratorStep(self)
        local co = self.____coroutine
        local status, value = coroutine.resume(co)
        if not status then
            error(value, 0)
        end
        if coroutine.status(co) == "dead" then
            return
        end
        return true, value
    end
    local function iteratorIteratorStep(self)
        local result = self:next()
        if result.done then
            return
        end
        return true, result.value
    end
    local function iteratorStringStep(self, index)
        index = index + 1
        if index > #self then
            return
        end
        return index, string.sub(self, index, index)
    end
    function __TS__Iterator(iterable)
        if type(iterable) == "string" then
            return iteratorStringStep, iterable, 0
        elseif iterable.____coroutine ~= nil then
            return iteratorGeneratorStep, iterable
        elseif iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            return iteratorIteratorStep, iterator
        else
            return ipairs(iterable)
        end
    end
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
    local create = vector.create
    local color = colors.color
    local focusedInstance = nil
    local function ____print(thing)
        if focusedInstance == nil then
            error(
                __TS__New(Error, "OOPS"),
                0
            )
        end
        do
            local function ____catch(e)
                mineos.System.out:println("You done goofed up boi!" .. tostring(e))
            end
            local ____try, ____hasReturned = pcall(function()
                focusedInstance:pushOutput("\n" .. thing)
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
        end
    end
    local LuaVM = __TS__Class()
    LuaVM.name = "LuaVM"
    __TS__ClassExtends(LuaVM, mineos.WindowProgram)
    function LuaVM.prototype.____constructor(self, system, renderer, audio, desktop, windowSize)
        self.loaded = false
        self.instance = 0
        self.programLineLimit = 10
        self.myCoolProgram = "print(\"Hello, world!\")"
        self.version = 5.1
        self.keyboard = __TS__StringTrim("\n    1234567890_^#$\n    abcdefghijklmn\n    opqrstuvwxyz{}\n    =\"'.,()\\/-+~*!\n    ")
        self.programOutput = ""
        self.keyboardCbox = {}
        windowSize.x = 500
        windowSize.y = 500
        LuaVM.____super.prototype.____constructor(
            self,
            system,
            renderer,
            audio,
            desktop,
            windowSize
        )
        focusedInstance = self
    end
    function LuaVM.prototype.updateIDEText(self)
        self.renderer:setElementComponentValue(
            "lua_program_text_" .. tostring(self.instance),
            "text",
            self.myCoolProgram
        )
    end
    function LuaVM.prototype.updateOutputText(self)
        self.renderer:setElementComponentValue(
            "program_output_text_" .. tostring(self.instance),
            "text",
            self.programOutput
        )
    end
    function LuaVM.prototype.charInput(self, char)
        if #char > 1 then
            error(
                __TS__New(Error, "How did this even happen?"),
                0
            )
        end
        self.myCoolProgram = table.concat(
            __TS__StringSplit(self.myCoolProgram .. char, "\n", self.programLineLimit),
            "\n"
        )
        self:updateIDEText()
    end
    function LuaVM.prototype.charDelete(self)
        self.myCoolProgram = string.sub(self.myCoolProgram, 1, -2)
        self:updateIDEText()
    end
    function LuaVM.prototype.execute(self)
        local _, err = pcall(function()
            local OLD_PRINT = _G.print
            _G.print = ____print
            local func, err = loadstring(self.myCoolProgram, "LuaVM", "t", _G)
            if type(func) == "function" then
                local callable = func
                callable()
            else
                ____print(tostring(err))
            end
            _G.print = OLD_PRINT
        end)
        if err then
            self:pushOutput(err)
        end
    end
    function LuaVM.prototype.pushOutput(self, input)
        local array = __TS__StringSplit(self.programOutput .. input, "\n")
        local overshoot = #array - self.programLineLimit
        local startIndex = overshoot > 0 and overshoot or 0
        self.programOutput = table.concat(
            __TS__ArraySlice(array, startIndex, #array),
            "\n"
        )
        self:updateOutputText()
    end
    function LuaVM.prototype.load(self)
        self.instance = LuaVM.nextInstance
        LuaVM.nextInstance = LuaVM.nextInstance + 1
        self.renderer:addElement(
            "lua_bg_" .. tostring(self.instance),
            {
                name = "lua_bg_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(30, 30, 30)) .. ":255",
                scale = self.windowSize,
                alignment = create(1, 1),
                offset = create(
                    self:getPosX(),
                    self:getPosY()
                ),
                z_index = 1
            }
        )
        local border = 4
        self.renderer:addElement(
            "lua_text_area_" .. tostring(self.instance),
            {
                name = "lua_text_area_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(60, 60, 60)) .. ":255",
                scale = create(self.windowSize.x - border * 2, self.windowSize.y / 2.5 - border),
                alignment = create(1, 1),
                offset = create(
                    self:getPosX() + border,
                    self:getPosY() + border
                ),
                z_index = 2
            }
        )
        self.renderer:addElement(
            "lua_program_text_" .. tostring(self.instance),
            {
                name = "lua_program_text_" .. tostring(self.instance),
                hud_elem_type = HudElementType.text,
                scale = create(1, 1),
                text = self.myCoolProgram,
                number = colors.colorHEX(0, 0, 0),
                position = create(0, 0),
                alignment = create(1, 1),
                offset = create(
                    self:getPosX() + border,
                    self:getPosY() + border
                ),
                z_index = 3
            }
        )
        self.renderer:addElement(
            "program_output_area_" .. tostring(self.instance),
            {
                name = "program_output_area_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(60, 60, 60)) .. ":255",
                scale = create(self.windowSize.x - border * 2, self.windowSize.y / 2.5 - border),
                alignment = create(1, 1),
                offset = create(
                    self:getPosX() + border,
                    self:getPosY() + self.windowSize.y / 2.5 + border
                ),
                z_index = 2
            }
        )
        self.renderer:addElement(
            "program_output_text_" .. tostring(self.instance),
            {
                name = "program_output_text_" .. tostring(self.instance),
                hud_elem_type = HudElementType.text,
                scale = create(1, 1),
                text = self.programOutput,
                number = colors.colorHEX(0, 0, 0),
                position = create(0, 0),
                alignment = create(1, 1),
                offset = create(
                    self:getPosX() + border,
                    self:getPosY() + self.windowSize.y / 2.5 + border
                ),
                z_index = 3
            }
        )
        local buttonSize = 20
        local buttonSpacing = 21
        local y = 0
        for ____, charArray in ipairs(__TS__StringSplit(self.keyboard, "\n")) do
            local x = 0
            for ____, char in __TS__Iterator(__TS__StringTrim(tostring(charArray))) do
                local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + (y - 1) * buttonSpacing)
                self.keyboardCbox[char] = __TS__New(
                    mineos.AABB,
                    rootPos,
                    create(buttonSize, buttonSize),
                    create(0, 0)
                )
                self.renderer:addElement(
                    (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                    {
                        name = (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                        hud_elem_type = HudElementType.image,
                        position = create(0, 0),
                        text = ("pixel.png^[colorize:" .. color(50, 50, 50)) .. ":255",
                        scale = create(buttonSize, buttonSize),
                        alignment = create(1, 1),
                        offset = rootPos,
                        z_index = 2
                    }
                )
                self.renderer:addElement(
                    (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                    {
                        name = (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                        hud_elem_type = HudElementType.text,
                        scale = create(1, 1),
                        text = char,
                        number = colors.colorHEX(0, 0, 0),
                        position = create(0, 0),
                        alignment = create(1, 1),
                        offset = create(rootPos.x + 4, rootPos.y),
                        z_index = 3
                    }
                )
                x = x + 1
            end
            y = y + 1
        end
        do
            local char = "space"
            local x = 15
            local y = 2
            local spaceWidth = 3
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.keyboardCbox[char] = __TS__New(
                mineos.AABB,
                rootPos,
                create(buttonSize * spaceWidth, buttonSize),
                create(0, 0)
            )
            self.renderer:addElement(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.image,
                    position = create(0, 0),
                    text = ("pixel.png^[colorize:" .. color(50, 50, 50)) .. ":255",
                    scale = create(buttonSize * spaceWidth, buttonSize),
                    alignment = create(1, 1),
                    offset = rootPos,
                    z_index = 2
                }
            )
            self.renderer:addElement(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.text,
                    scale = create(1, 1),
                    text = char,
                    number = colors.colorHEX(0, 0, 0),
                    position = create(0, 0),
                    alignment = create(1, 1),
                    offset = create(rootPos.x + 4, rootPos.y),
                    z_index = 3
                }
            )
        end
        do
            local char = "return"
            local x = 15
            local y = 1
            local spaceWidth = 3
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.keyboardCbox[char] = __TS__New(
                mineos.AABB,
                rootPos,
                create(buttonSize * spaceWidth, buttonSize),
                create(0, 0)
            )
            self.renderer:addElement(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.image,
                    position = create(0, 0),
                    text = ("pixel.png^[colorize:" .. color(50, 50, 50)) .. ":255",
                    scale = create(buttonSize * spaceWidth, buttonSize),
                    alignment = create(1, 1),
                    offset = rootPos,
                    z_index = 2
                }
            )
            self.renderer:addElement(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.text,
                    scale = create(1, 1),
                    text = char,
                    number = colors.colorHEX(0, 0, 0),
                    position = create(0, 0),
                    alignment = create(1, 1),
                    offset = create(rootPos.x + 4, rootPos.y),
                    z_index = 3
                }
            )
        end
        do
            local char = "run"
            local x = 15
            local y = 0
            local spaceWidth = 3
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.keyboardCbox[char] = __TS__New(
                mineos.AABB,
                rootPos,
                create(buttonSize * spaceWidth, buttonSize),
                create(0, 0)
            )
            self.renderer:addElement(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.image,
                    position = create(0, 0),
                    text = ("pixel.png^[colorize:" .. color(50, 50, 50)) .. ":255",
                    scale = create(buttonSize * spaceWidth, buttonSize),
                    alignment = create(1, 1),
                    offset = rootPos,
                    z_index = 2
                }
            )
            self.renderer:addElement(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.text,
                    scale = create(1, 1),
                    text = char,
                    number = colors.colorHEX(0, 0, 0),
                    position = create(0, 0),
                    alignment = create(1, 1),
                    offset = create(rootPos.x + 4, rootPos.y),
                    z_index = 3
                }
            )
        end
        do
            local char = "backspace"
            local x = 18
            local y = 0
            local spaceWidth = 5
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.keyboardCbox[char] = __TS__New(
                mineos.AABB,
                rootPos,
                create(buttonSize * spaceWidth, buttonSize),
                create(0, 0)
            )
            self.renderer:addElement(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.image,
                    position = create(0, 0),
                    text = ("pixel.png^[colorize:" .. color(50, 50, 50)) .. ":255",
                    scale = create(buttonSize * spaceWidth, buttonSize),
                    alignment = create(1, 1),
                    offset = rootPos,
                    z_index = 2
                }
            )
            self.renderer:addElement(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                {
                    name = (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                    hud_elem_type = HudElementType.text,
                    scale = create(1, 1),
                    text = char,
                    number = colors.colorHEX(0, 0, 0),
                    position = create(0, 0),
                    alignment = create(1, 1),
                    offset = create(rootPos.x + 4, rootPos.y),
                    z_index = 3
                }
            )
        end
        self.loaded = true
    end
    function LuaVM.prototype.floatError(self)
        if math.random() > 0.5 then
            self.version = self.version + 1e-14
        else
            self.version = self.version - 1e-14
        end
        self:setWindowTitle("LuaJIT " .. tostring(self.version))
    end
    function LuaVM.prototype.playKeyboardNoise(self)
        self.audioController:playSound("keyboard_lua", 1)
    end
    function LuaVM.prototype.move(self)
        self.renderer:setElementComponentValue(
            "lua_bg_" .. tostring(self.instance),
            "offset",
            self.windowPosition
        )
        local buttonSize = 20
        local buttonSpacing = 21
        local y = 0
        for ____, charArray in ipairs(__TS__StringSplit(self.keyboard, "\n")) do
            local x = 0
            for ____, char in __TS__Iterator(__TS__StringTrim(tostring(charArray))) do
                local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + (y - 1) * buttonSpacing)
                self.renderer:setElementComponentValue(
                    (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                    "offset",
                    rootPos
                )
                self.renderer:setElementComponentValue(
                    (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                    "offset",
                    create(rootPos.x + 4, rootPos.y)
                )
                self.keyboardCbox[char].offset = rootPos
                x = x + 1
            end
            y = y + 1
        end
        do
            local char = "space"
            local x = 15
            local y = 2
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.renderer:setElementComponentValue(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                rootPos
            )
            self.renderer:setElementComponentValue(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                create(rootPos.x + 4, rootPos.y)
            )
            self.keyboardCbox[char].offset = rootPos
        end
        do
            local char = "return"
            local x = 15
            local y = 1
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.renderer:setElementComponentValue(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                rootPos
            )
            self.renderer:setElementComponentValue(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                create(rootPos.x + 4, rootPos.y)
            )
            self.keyboardCbox[char].offset = rootPos
        end
        do
            local char = "run"
            local x = 15
            local y = 0
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.renderer:setElementComponentValue(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                rootPos
            )
            self.renderer:setElementComponentValue(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                create(rootPos.x + 4, rootPos.y)
            )
            self.keyboardCbox[char].offset = rootPos
        end
        do
            local char = "backspace"
            local x = 18
            local y = 0
            local rootPos = create(self.windowPosition.x + x * buttonSpacing, self.windowPosition.y + self.windowSize.y - buttonSpacing * 3 + y * buttonSpacing)
            self.renderer:setElementComponentValue(
                (("lua_button_bg_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                rootPos
            )
            self.renderer:setElementComponentValue(
                (("lua_button_text_" .. char) .. "_") .. tostring(self.instance),
                "offset",
                create(rootPos.x + 4, rootPos.y)
            )
            self.keyboardCbox[char].offset = rootPos
        end
        local border = 4
        self.renderer:setElementComponentValue(
            "lua_text_area_" .. tostring(self.instance),
            "offset",
            create(
                self:getPosX() + border,
                self:getPosY() + border
            )
        )
        self.renderer:setElementComponentValue(
            "lua_program_text_" .. tostring(self.instance),
            "offset",
            create(
                self:getPosX() + border,
                self:getPosY() + border
            )
        )
        self.renderer:setElementComponentValue(
            "program_output_area_" .. tostring(self.instance),
            "offset",
            create(
                self:getPosX() + border,
                self:getPosY() + self.windowSize.y / 2.5 + border
            )
        )
        self.renderer:setElementComponentValue(
            "program_output_text_" .. tostring(self.instance),
            "offset",
            create(
                self:getPosX() + border,
                self:getPosY() + self.windowSize.y / 2.5 + border
            )
        )
    end
    function LuaVM.prototype.destructor(self)
        self.renderer:removeElement("lua_bg_" .. tostring(self.instance))
        self.renderer:removeElement("lua_text_area_" .. tostring(self.instance))
        self.renderer:removeElement("lua_program_text_" .. tostring(self.instance))
        self.renderer:removeElement("program_output_area_" .. tostring(self.instance))
        self.renderer:removeElement("program_output_text_" .. tostring(self.instance))
        for ____, charArray in ipairs(__TS__StringSplit(self.keyboard, "\n")) do
            for ____, char in __TS__Iterator(__TS__StringTrim(tostring(charArray))) do
                self.renderer:removeElement((("lua_button_bg_" .. char) .. "_") .. tostring(self.instance))
                self.renderer:removeElement((("lua_button_text_" .. char) .. "_") .. tostring(self.instance))
            end
        end
        for ____, char in ipairs({"return", "backspace", "run", "space"}) do
            self.renderer:removeElement((("lua_button_bg_" .. char) .. "_") .. tostring(self.instance))
            self.renderer:removeElement((("lua_button_text_" .. char) .. "_") .. tostring(self.instance))
        end
    end
    function LuaVM.prototype.mouseCollision(self)
        if not self.system:isMouseClicked() then
            return
        end
        local buttonSize = 20
        local buttonSpacing = 21
        local mousePos = self.desktop:getMousePos()
        local gottenChar = nil
        for ____, ____value in ipairs(__TS__ObjectEntries(self.keyboardCbox)) do
            local char = ____value[1]
            local aabb = ____value[2]
            if aabb:pointWithin(mousePos) then
                gottenChar = char
                break
            end
        end
        repeat
            local ____switch53 = gottenChar
            local ____cond53 = ____switch53 == "return"
            if ____cond53 then
                self:playKeyboardNoise()
                self:charInput("\n")
                break
            end
            ____cond53 = ____cond53 or ____switch53 == "space"
            if ____cond53 then
                self:playKeyboardNoise()
                self:charInput(" ")
                break
            end
            ____cond53 = ____cond53 or ____switch53 == "backspace"
            if ____cond53 then
                self:playKeyboardNoise()
                self:charDelete()
                break
            end
            ____cond53 = ____cond53 or ____switch53 == "run"
            if ____cond53 then
                self:playKeyboardNoise()
                self:execute()
                break
            end
            do
                if gottenChar then
                    self:playKeyboardNoise()
                    self:charInput(gottenChar)
                end
            end
        until true
    end
    function LuaVM.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        self:floatError()
        self:mouseCollision()
    end
    LuaVM.nextInstance = 0
    mineos.DesktopEnvironment:registerProgram(LuaVM)
end
