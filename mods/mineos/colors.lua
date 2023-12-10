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
colors = colors or ({})
do
    local hexValues = {
        [100] = "FF",
        [99] = "FC",
        [98] = "FA",
        [97] = "F7",
        [96] = "F5",
        [95] = "F2",
        [94] = "F0",
        [93] = "ED",
        [92] = "EB",
        [91] = "E8",
        [90] = "E6",
        [89] = "E3",
        [88] = "E0",
        [87] = "DE",
        [86] = "DB",
        [85] = "D9",
        [84] = "D6",
        [83] = "D4",
        [82] = "D1",
        [81] = "CF",
        [80] = "CC",
        [79] = "C9",
        [78] = "C7",
        [77] = "C4",
        [76] = "C2",
        [75] = "BF",
        [74] = "BD",
        [73] = "BA",
        [72] = "B8",
        [71] = "B5",
        [70] = "B3",
        [69] = "B0",
        [68] = "AD",
        [67] = "AB",
        [66] = "A8",
        [65] = "A6",
        [64] = "A3",
        [63] = "A1",
        [62] = "9E",
        [61] = "9C",
        [60] = "99",
        [59] = "96",
        [58] = "94",
        [57] = "91",
        [56] = "8F",
        [55] = "8C",
        [54] = "8A",
        [53] = "87",
        [52] = "85",
        [51] = "82",
        [50] = "80",
        [49] = "7D",
        [48] = "7A",
        [47] = "78",
        [46] = "75",
        [45] = "73",
        [44] = "70",
        [43] = "6E",
        [42] = "6B",
        [41] = "69",
        [40] = "66",
        [39] = "63",
        [38] = "61",
        [37] = "5E",
        [36] = "5C",
        [35] = "59",
        [34] = "57",
        [33] = "54",
        [32] = "52",
        [31] = "4F",
        [30] = "4D",
        [29] = "4A",
        [28] = "47",
        [27] = "45",
        [26] = "42",
        [25] = "40",
        [24] = "3D",
        [23] = "3B",
        [22] = "38",
        [21] = "36",
        [20] = "33",
        [19] = "30",
        [18] = "2E",
        [17] = "2B",
        [16] = "29",
        [15] = "26",
        [14] = "24",
        [13] = "21",
        [12] = "1F",
        [11] = "1C",
        [10] = "1A",
        [9] = "17",
        [8] = "14",
        [7] = "12",
        [6] = "0F",
        [5] = "0D",
        [4] = "0A",
        [3] = "08",
        [2] = "05",
        [1] = "03",
        [0] = "00"
    }
    local function lockChannel(input)
        return math.floor(math.clamp(0, 100, input))
    end
    --- Get the alpha level of a number. (Integers only)
    -- 
    -- @param input Integral percent. (0-100)
    -- @returns Alpha AA string to bolt onto a color hex.
    function colors.percentToAlphaHex(input)
        local clamped = lockChannel(input)
        return hexValues[clamped]
    end
    local newColor = ""
    function colors.color(r, g, b, a)
        newColor = "#"
        newColor = newColor .. hexValues[lockChannel(r)]
        newColor = newColor .. hexValues[lockChannel(g)]
        newColor = newColor .. hexValues[lockChannel(b)]
        if a then
            newColor = newColor .. hexValues[lockChannel(a)]
        end
        return newColor
    end
    function colors.colorHEX(r, g, b, a)
        local newColor = "0x"
        for ____, channel in ipairs({r, g, b, a}) do
            if channel then
                newColor = newColor .. hexValues[lockChannel(channel)]
            end
        end
        local colorNumber = tonumber(newColor)
        if colorNumber == nil then
            error(
                __TS__New(Error, "NULL COLOR!"),
                0
            )
        end
        return colorNumber
    end
    --- Like the color() function, but can take in raw (0-255) rgba elements.
    -- 
    -- @param r Red channel. (0-255)
    -- @param g Green channel. (0-255)
    -- @param b Blue channel. (0-255)
    -- @param a Alpha channel. (0-255)
    -- @returns Color string in hex.
    function colors.colorRGB(r, g, b, a)
        a = a and a / 2.55 or a
        return colors.color(r / 2.55, g / 2.55, b / 2.55, a)
    end
    function colors.colorScalar(s, a)
        local newColor = "#"
        local hex = hexValues[lockChannel(s)]
        do
            local i = 0
            while i < 3 do
                newColor = newColor .. hex
                i = i + 1
            end
        end
        if a then
            newColor = newColor .. hexValues[lockChannel(a)]
        end
        return newColor
    end
end
