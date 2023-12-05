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

local function __TS__InstanceOf(obj, classTbl)
    if type(classTbl) ~= "table" then
        error("Right-hand side of 'instanceof' is not an object", 0)
    end
    if classTbl[Symbol.hasInstance] ~= nil then
        return not not classTbl[Symbol.hasInstance](classTbl, obj)
    end
    if type(obj) == "table" then
        local luaClass = obj.constructor
        while luaClass ~= nil do
            if luaClass == classTbl then
                return true
            end
            luaClass = luaClass.____super
        end
    end
    return false
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create2d
    local function sVec(input)
        return (tostring(input.x) .. ",") .. tostring(input.y)
    end
    --- Convert an array into a single string representation.
    -- 
    -- @param input Array of strings.
    -- @returns Array as single string concatenated with ","
    local function arrayToString(input)
        local temp = ""
        local index = 0
        for ____, value in ipairs(input) do
            if index ~= 0 then
                temp = temp .. ","
            end
            temp = temp .. value
            index = index + 1
        end
        return temp
    end
    mineos.FormSpec = __TS__Class()
    local FormSpec = mineos.FormSpec
    FormSpec.name = "FormSpec"
    function FormSpec.prototype.____constructor(self, definition)
        self.size = definition.size
        self.fixedSize = definition.fixedSize
        self.position = definition.position
        self.anchor = definition.anchor
        self.padding = definition.padding
        self.disablePrepend = definition.disablePrepend
        self.elements = definition.elements
    end
    function FormSpec.prototype.attachElement(self, newElement)
        local ____self_elements_0 = self.elements
        ____self_elements_0[#____self_elements_0 + 1] = newElement
        return self
    end
    mineos.Container = __TS__Class()
    local Container = mineos.Container
    Container.name = "Container"
    function Container.prototype.____constructor(self, definition)
        do
            self.position = definition.position
            self.elements = definition.elements
        end
    end
    function Container.prototype.attachElement(self, newElement)
        local ____self_elements_1 = self.elements
        ____self_elements_1[#____self_elements_1 + 1] = newElement
        return self
    end
    mineos.ScrollOrientation = ScrollOrientation or ({})
    mineos.ScrollOrientation.vertical = "vertical"
    mineos.ScrollOrientation.horizontal = "horizontal"
    mineos.ScrollContainer = __TS__Class()
    local ScrollContainer = mineos.ScrollContainer
    ScrollContainer.name = "ScrollContainer"
    __TS__ClassExtends(ScrollContainer, mineos.Container)
    function ScrollContainer.prototype.____constructor(self, definition)
        ScrollContainer.____super.prototype.____constructor(self, {position = definition.position, elements = definition.elements})
        self.size = definition.size
        self.orientation = definition.orientation
        self.factor = definition.factor or 0.1
        self.name = definition.name
    end
    mineos.List = __TS__Class()
    local List = mineos.List
    List.name = "List"
    function List.prototype.____constructor(self, definition)
        self.location = definition.location
        self.listName = definition.listName
        self.position = definition.position
        self.size = definition.size
        self.startingIndex = definition.startingIndex
    end
    mineos.ListRing = __TS__Class()
    local ListRing = mineos.ListRing
    ListRing.name = "ListRing"
    function ListRing.prototype.____constructor(self, definition)
        self.location = definition.location
        self.listName = definition.listName
    end
    mineos.ListColors = __TS__Class()
    local ListColors = mineos.ListColors
    ListColors.name = "ListColors"
    function ListColors.prototype.____constructor(self, definition)
        self.slotBGNormal = definition.slotBGNormal
        self.slotBGHover = definition.slotBGHover
        self.slotBorder = definition.slotBorder
        self.toolTipBGColor = definition.toolTipBGColor
        self.toolTipFontColor = definition.toolTipFontColor
    end
    mineos.ElementToolTip = __TS__Class()
    local ElementToolTip = mineos.ElementToolTip
    ElementToolTip.name = "ElementToolTip"
    function ElementToolTip.prototype.____constructor(self, definition)
        self.guiElementName = definition.guiElementName
        self.text = definition.text
        self.bgColor = definition.bgColor
        self.fontColor = definition.fontColor
    end
    mineos.AreaToolTip = __TS__Class()
    local AreaToolTip = mineos.AreaToolTip
    AreaToolTip.name = "AreaToolTip"
    function AreaToolTip.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.text = definition.text
        self.bgColor = definition.bgColor
        self.fontColor = definition.fontColor
    end
    mineos.Image = __TS__Class()
    local Image = mineos.Image
    Image.name = "Image"
    function Image.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.texture = definition.texture
        self.middle = definition.middle
    end
    mineos.AnimatedImage = __TS__Class()
    local AnimatedImage = mineos.AnimatedImage
    AnimatedImage.name = "AnimatedImage"
    __TS__ClassExtends(AnimatedImage, mineos.Image)
    function AnimatedImage.prototype.____constructor(self, definition)
        AnimatedImage.____super.prototype.____constructor(self, definition)
        self.name = definition.name
        self.frameCount = definition.frameCount
        self.frameDuration = definition.frameDuration
        self.frameStart = definition.frameStart
    end
    mineos.Model = __TS__Class()
    local Model = mineos.Model
    Model.name = "Model"
    function Model.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.mesh = definition.mesh
        self.textures = definition.textures
        self.rotation = definition.rotation
        self.continuous = definition.continuous
        self.mouseControl = definition.mouseControl
        self.frameLoopRange = definition.frameLoopRange
        self.animationSpeed = definition.animationSpeed
    end
    mineos.BGColor = __TS__Class()
    local BGColor = mineos.BGColor
    BGColor.name = "BGColor"
    function BGColor.prototype.____constructor(self, definition)
        self.bgColor = definition.bgColor
        self.fullScreen = definition.fullScreen
        self.fullScreenbgColor = definition.fullScreenbgColor
    end
    mineos.Background = __TS__Class()
    local Background = mineos.Background
    Background.name = "Background"
    function Background.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.texture = definition.texture
        self.autoclip = definition.autoClip
        self.middle = definition.middle
    end
    mineos.PasswordField = __TS__Class()
    local PasswordField = mineos.PasswordField
    PasswordField.name = "PasswordField"
    function PasswordField.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.label = definition.label
    end
    mineos.Field = __TS__Class()
    local Field = mineos.Field
    Field.name = "Field"
    function Field.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.label = definition.label
        self.default = definition.default
    end
    mineos.FieldEnterAfterEdit = __TS__Class()
    local FieldEnterAfterEdit = mineos.FieldEnterAfterEdit
    FieldEnterAfterEdit.name = "FieldEnterAfterEdit"
    function FieldEnterAfterEdit.prototype.____constructor(self, name)
        self.name = name
    end
    mineos.FieldCloseOnEnter = __TS__Class()
    local FieldCloseOnEnter = mineos.FieldCloseOnEnter
    FieldCloseOnEnter.name = "FieldCloseOnEnter"
    function FieldCloseOnEnter.prototype.____constructor(self, name)
        self.name = name
    end
    mineos.TextArea = __TS__Class()
    local TextArea = mineos.TextArea
    TextArea.name = "TextArea"
    function TextArea.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.label = definition.label
        self.default = definition.default
    end
    mineos.Label = __TS__Class()
    local Label = mineos.Label
    Label.name = "Label"
    function Label.prototype.____constructor(self, definition)
        self.position = definition.position
        self.label = definition.label
    end
    mineos.HyperText = __TS__Class()
    local HyperText = mineos.HyperText
    HyperText.name = "HyperText"
    function HyperText.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.text = definition.text
    end
    mineos.VertLabel = __TS__Class()
    local VertLabel = mineos.VertLabel
    VertLabel.name = "VertLabel"
    function VertLabel.prototype.____constructor(self, definition)
        self.position = definition.position
        self.label = definition.label
    end
    mineos.Button = __TS__Class()
    local Button = mineos.Button
    Button.name = "Button"
    function Button.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.label = definition.label
    end
    mineos.ImageButton = __TS__Class()
    local ImageButton = mineos.ImageButton
    ImageButton.name = "ImageButton"
    __TS__ClassExtends(ImageButton, mineos.Button)
    function ImageButton.prototype.____constructor(self, definition)
        ImageButton.____super.prototype.____constructor(self, definition)
        self.texture = definition.texture
    end
    mineos.ImageButtonAdvanced = __TS__Class()
    local ImageButtonAdvanced = mineos.ImageButtonAdvanced
    ImageButtonAdvanced.name = "ImageButtonAdvanced"
    __TS__ClassExtends(ImageButtonAdvanced, mineos.ImageButton)
    function ImageButtonAdvanced.prototype.____constructor(self, definition)
        ImageButtonAdvanced.____super.prototype.____constructor(self, definition)
        self.noClip = definition.noClip
        self.drawBorder = definition.drawBorder
        self.pressedTexture = definition.pressedTexture
    end
    mineos.ItemImageButton = __TS__Class()
    local ItemImageButton = mineos.ItemImageButton
    ItemImageButton.name = "ItemImageButton"
    function ItemImageButton.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.itemName = definition.itemName
        self.name = definition.name
        self.label = definition.label
    end
    mineos.ButtonExit = __TS__Class()
    local ButtonExit = mineos.ButtonExit
    ButtonExit.name = "ButtonExit"
    __TS__ClassExtends(ButtonExit, mineos.Button)
    function ButtonExit.prototype.____constructor(self, ...)
        ButtonExit.____super.prototype.____constructor(self, ...)
        self.buttonExit = false
    end
    mineos.ImageButtonExit = __TS__Class()
    local ImageButtonExit = mineos.ImageButtonExit
    ImageButtonExit.name = "ImageButtonExit"
    __TS__ClassExtends(ImageButtonExit, mineos.ImageButton)
    function ImageButtonExit.prototype.____constructor(self, ...)
        ImageButtonExit.____super.prototype.____constructor(self, ...)
        self.imageButtonExit = false
    end
    mineos.TextList = __TS__Class()
    local TextList = mineos.TextList
    TextList.name = "TextList"
    function TextList.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.items = definition.items
        self.selectedIndex = definition.selectedIndex
        self.transparent = definition.transparent
    end
    mineos.TabHeader = __TS__Class()
    local TabHeader = mineos.TabHeader
    TabHeader.name = "TabHeader"
    function TabHeader.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.captions = definition.captions
        self.currentTab = definition.currentTab
        self.transparent = definition.transparent
        self.drawBorder = definition.drawBorder
    end
    mineos.Box = __TS__Class()
    local Box = mineos.Box
    Box.name = "Box"
    function Box.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.color = definition.color
    end
    mineos.DropDown = __TS__Class()
    local DropDown = mineos.DropDown
    DropDown.name = "DropDown"
    function DropDown.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.items = definition.items
        self.selectedIndex = definition.selectedIndex
        self.indexEvent = definition.indexEvent
    end
    mineos.CheckBox = __TS__Class()
    local CheckBox = mineos.CheckBox
    CheckBox.name = "CheckBox"
    function CheckBox.prototype.____constructor(self, definition)
        self.position = definition.position
        self.name = definition.name
        self.label = definition.label
        self.selected = definition.selected
    end
    mineos.ScrollBar = __TS__Class()
    local ScrollBar = mineos.ScrollBar
    ScrollBar.name = "ScrollBar"
    function ScrollBar.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.orientation = definition.orientation
        self.name = definition.name
        self.value = definition.value
    end
    mineos.ScrollBarOptions = __TS__Class()
    local ScrollBarOptions = mineos.ScrollBarOptions
    ScrollBarOptions.name = "ScrollBarOptions"
    function ScrollBarOptions.prototype.____constructor(self, options)
        self.scrollBarOptions = options
    end
    mineos.Table = __TS__Class()
    local Table = mineos.Table
    Table.name = "Table"
    function Table.prototype.____constructor(self, definition)
        self.position = definition.position
        self.size = definition.size
        self.name = definition.name
        self.cells = definition.cells
        self.selectedIndex = definition.selectedIndex
    end
    mineos.TableOptions = __TS__Class()
    local TableOptions = mineos.TableOptions
    TableOptions.name = "TableOptions"
    function TableOptions.prototype.____constructor(self, options)
        self.tableOptions = options
    end
    mineos.TableColumns = __TS__Class()
    local TableColumns = mineos.TableColumns
    TableColumns.name = "TableColumns"
    function TableColumns.prototype.____constructor(self, columns)
        self.tableColumns = columns
    end
    mineos.Style = __TS__Class()
    local Style = mineos.Style
    Style.name = "Style"
    function Style.prototype.____constructor(self, styleThings)
        self.styleThings = styleThings
    end
    mineos.StyleType = __TS__Class()
    local StyleType = mineos.StyleType
    StyleType.name = "StyleType"
    function StyleType.prototype.____constructor(self, styleTypes)
        self.styleTypes = styleTypes
    end
    mineos.SetFocus = __TS__Class()
    local SetFocus = mineos.SetFocus
    SetFocus.name = "SetFocus"
    function SetFocus.prototype.____constructor(self, definition)
        self.name = definition.name
        self.force = definition.force
    end
    local function processElements(accumulator, elementArray)
        for ____, element in ipairs(elementArray) do
            if __TS__InstanceOf(element, mineos.Container) then
                local pos = element.position
                accumulator = accumulator .. ("container[" .. sVec(pos)) .. "]\n"
                accumulator = accumulator .. "container_end[]\n"
            elseif __TS__InstanceOf(element, mineos.ScrollContainer) then
                local pos = element.position
                local size = element.size
                accumulator = accumulator .. ((((((((("scroll_container[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. element.name) .. ";") .. element.orientation) .. ";") .. tostring(element.factor)) .. "]\n"
                accumulator = accumulator .. "scroll_container_end[]\n"
            elseif __TS__InstanceOf(element, mineos.List) then
                local location = element.location
                local listName = element.listName
                local pos = element.position
                local size = element.size
                local startingIndex = element.startingIndex
                accumulator = accumulator .. ((((((((("list[" .. location) .. ";") .. listName) .. ";") .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. tostring(startingIndex)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ListRing) then
                local location = element.location
                local listName = element.listName
                accumulator = accumulator .. ((("listring[" .. location) .. ";") .. listName) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ListColors) then
                local slotBGNormal = element.slotBGNormal
                local slotBGHover = element.slotBGHover
                accumulator = accumulator .. (("listcolors[" .. slotBGNormal) .. ";") .. slotBGHover
                local slotBorder = element.slotBorder
                if slotBorder then
                    accumulator = accumulator .. ";" .. slotBorder
                    local toolTipBGColor = element.toolTipBGColor
                    local toolTipFontColor = element.toolTipFontColor
                    if toolTipBGColor and toolTipFontColor then
                        accumulator = accumulator .. ((";" .. toolTipBGColor) .. ";") .. toolTipFontColor
                    end
                end
                accumulator = accumulator .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ElementToolTip) then
                local guiElementName = element.guiElementName
                local text = element.text
                local bgColor = element.bgColor
                local fontColor = element.fontColor
                accumulator = accumulator .. ((((((("tooltip[" .. guiElementName) .. ";") .. text) .. ";") .. bgColor) .. ";") .. fontColor) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.AreaToolTip) then
                local pos = element.position
                local size = element.size
                local text = element.text
                local bgcolor = element.bgColor
                local fontcolor = element.fontColor
                accumulator = accumulator .. ((((((((("tooltip[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. text) .. ";") .. bgcolor) .. ";") .. fontcolor) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Image) then
                local pos = element.position
                local size = element.size
                local texture = element.texture
                local middle = element.middle
                accumulator = accumulator .. (((("image[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. texture
                if middle then
                    accumulator = accumulator .. ";" .. middle
                end
                accumulator = accumulator .. "]\n"
            elseif __TS__InstanceOf(element, mineos.AnimatedImage) then
                local pos = element.position
                local size = element.size
                local texture = element.texture
                local name = element.name
                local frameCount = element.frameCount
                local frameDuration = element.frameDuration
                local frameStart = element.frameStart
                local middle = element.middle
                accumulator = accumulator .. (((((((((((("animated_image[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. texture) .. ";") .. tostring(frameCount)) .. ";") .. tostring(frameDuration)) .. ";") .. tostring(frameStart)
                if middle then
                    accumulator = accumulator .. ";" .. middle
                end
                accumulator = accumulator .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Model) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local mesh = element.mesh
                local textures = arrayToString(element.textures)
                local rotation = element.rotation
                local continuous = element.continuous
                local mouseControl = element.mouseControl
                local frameLoopRange = element.frameLoopRange
                local animationSpeed = element.animationSpeed
                accumulator = accumulator .. ((((((((((((((((((("model[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. mesh) .. ";") .. textures) .. ";") .. sVec(rotation)) .. ";") .. tostring(continuous)) .. ";") .. tostring(mouseControl)) .. ";") .. sVec(frameLoopRange)) .. ";") .. tostring(animationSpeed)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.BGColor) then
                local bgcolor = element.bgColor
                local fullScreen = element.fullScreen
                local fullScreenbgColor = element.fullScreenbgColor
                accumulator = accumulator .. ((((("bgcolor[" .. bgcolor) .. ";") .. tostring(fullScreen)) .. ";") .. fullScreenbgColor) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Background) then
                local pos = element.position
                local size = element.size
                local texture = element.texture
                local ____temp_2
                if element.autoclip then
                    ____temp_2 = true
                else
                    ____temp_2 = false
                end
                local autoClip = ____temp_2
                local middle = element.middle
                if middle then
                    accumulator = accumulator .. "background9["
                else
                    accumulator = accumulator .. "background["
                end
                accumulator = accumulator .. (((((sVec(pos) .. ";") .. sVec(size)) .. ";") .. texture) .. ";") .. tostring(autoClip)
                if middle then
                    accumulator = accumulator .. ";" .. middle
                end
                accumulator = accumulator .. "]\n"
            elseif __TS__InstanceOf(element, mineos.PasswordField) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local label = element.label
                accumulator = accumulator .. ((((((("pwdfield[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Field) then
                local pos = element.position
                local size = element.size
                accumulator = accumulator .. "field["
                if pos and size then
                    accumulator = accumulator .. ((sVec(pos) .. ";") .. sVec(size)) .. ";"
                end
                local name = element.name
                local label = element.label
                local def = element.default
                accumulator = accumulator .. ((((name .. ";") .. label) .. ";") .. def) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.FieldEnterAfterEdit) then
                local name = element.name
                accumulator = accumulator .. ((("field_enter_after_edit[" .. name) .. ";") .. tostring(true)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.FieldCloseOnEnter) then
                local name = element.name
                accumulator = accumulator .. ((("field_close_on_enter[" .. name) .. ";") .. tostring(true)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.TextArea) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local label = element.label
                local def = element.default
                accumulator = accumulator .. ((((((((("textarea[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. label) .. ";") .. def) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Label) then
                local pos = element.position
                local label = element.label
                accumulator = accumulator .. ((("label[" .. sVec(pos)) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.HyperText) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local text = element.text
                accumulator = accumulator .. ((((((("hypertext[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. text) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.VertLabel) then
                local pos = element.position
                local label = element.label
                accumulator = accumulator .. ((("vertlabel[" .. sVec(pos)) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Button) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local label = element.label
                accumulator = accumulator .. ((((((("button[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ImageButton) then
                local pos = element.position
                local size = element.size
                local texture = element.texture
                local name = element.name
                local label = element.label
                accumulator = accumulator .. ((((((((("button[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. texture) .. ";") .. name) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ImageButtonAdvanced) then
                local pos = element.position
                local size = element.size
                local texture = element.texture
                local name = element.name
                local label = element.label
                local noClip = element.noClip
                local drawBorder = element.drawBorder
                local pressedTexture = element.pressedTexture
                accumulator = accumulator .. ((((((((((((((("button[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. texture) .. ";") .. name) .. ";") .. label) .. ";") .. tostring(noClip)) .. ";") .. tostring(drawBorder)) .. ";") .. pressedTexture) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ItemImageButton) then
                local pos = element.position
                local size = element.size
                local itemName = element.itemName
                local name = element.name
                local label = element.label
                accumulator = accumulator .. ((((((((("item_image_button[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. itemName) .. ";") .. name) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ButtonExit) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local label = element.label
                accumulator = accumulator .. ((((((("button_exit[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. label) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.TextList) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local listOfItems = arrayToString(element.items)
                local selectedIndex = element.selectedIndex
                local transparent = element.transparent
                accumulator = accumulator .. ((((((((((("textlist[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. listOfItems) .. ";") .. tostring(selectedIndex)) .. ";") .. tostring(transparent)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.TabHeader) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local listOfCaptions = arrayToString(element.captions)
                local currentTab = element.currentTab
                local transparent = element.transparent
                local drawBorder = element.drawBorder
                accumulator = accumulator .. ((((((((((((("tabheader[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. listOfCaptions) .. ";") .. tostring(currentTab)) .. ";") .. tostring(transparent)) .. ";") .. tostring(drawBorder)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Box) then
                local pos = element.position
                local size = element.size
                local color = element.color
                accumulator = accumulator .. ((((("box[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. color) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.DropDown) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local itemList = arrayToString(element.items)
                local selectedIndex = element.selectedIndex
                local indexEvent = element.indexEvent
                accumulator = accumulator .. ((((((((((("dropdown[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. itemList) .. ";") .. tostring(selectedIndex)) .. ";") .. tostring(indexEvent)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.CheckBox) then
                local pos = element.position
                local name = element.name
                local label = element.label
                local selected = element.selected
                accumulator = accumulator .. ((((((("checkbox[" .. sVec(pos)) .. ";") .. name) .. ";") .. label) .. ";") .. tostring(selected)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ScrollBar) then
                local pos = element.position
                local size = element.size
                local orientation = element.orientation
                local name = element.name
                local value = element.value
                accumulator = accumulator .. ((((((((("scrollbar[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. orientation) .. ";") .. name) .. ";") .. value) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.ScrollBarOptions) then
                local options = arrayToString(element.scrollBarOptions)
                accumulator = accumulator .. ("scrollbaroptions[" .. options) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Table) then
                local pos = element.position
                local size = element.size
                local name = element.name
                local cellList = arrayToString(element.cells)
                local selectedIndex = element.selectedIndex
                accumulator = accumulator .. ((((((((("table[" .. sVec(pos)) .. ";") .. sVec(size)) .. ";") .. name) .. ";") .. cellList) .. ";") .. tostring(selectedIndex)) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.TableOptions) then
                local options = arrayToString(element.tableOptions)
                accumulator = accumulator .. ("tableoptions[" .. options) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.TableColumns) then
                local columns = arrayToString(element.tableColumns)
                accumulator = accumulator .. ("tablecolumns[" .. columns) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.Style) then
                local styleThings = arrayToString(element.styleThings)
                accumulator = accumulator .. ("style[" .. styleThings) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.StyleType) then
                local styleTypes = arrayToString(element.styleTypes)
                accumulator = accumulator .. ("style_type[" .. styleTypes) .. "]\n"
            elseif __TS__InstanceOf(element, mineos.SetFocus) then
                local name = element.name
                local force = element.force
                accumulator = accumulator .. ((("set_focus[" .. name) .. ";") .. tostring(force)) .. "]\n"
            end
        end
        return accumulator
    end
    function mineos.generate(d)
        local accumulator = "formspec_version[7]\n"
        if d.size then
            local ____temp_3
            if d.fixedSize then
                ____temp_3 = true
            else
                ____temp_3 = false
            end
            local fixed = ____temp_3
            local size = d.size
            accumulator = accumulator .. ((("size[" .. sVec(size)) .. ",") .. tostring(fixed)) .. "]\n"
        end
        if d.position then
            local pos = d.position
            accumulator = accumulator .. ("position[" .. sVec(pos)) .. "]\n"
        end
        if d.anchor then
            local anchor = d.anchor
            accumulator = accumulator .. ("anchor[" .. sVec(anchor)) .. "]\n"
        end
        if d.padding then
            local p = d.padding
            accumulator = accumulator .. ("padding[" .. sVec(p)) .. "]\n"
        end
        if d.disablePrepend then
            accumulator = accumulator .. "no_prepend[]\n"
        end
        accumulator = processElements(accumulator, d.elements)
        return accumulator
    end
end
