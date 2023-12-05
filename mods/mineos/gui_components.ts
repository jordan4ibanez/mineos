namespace mineos {
  // Extremely experimental formspec composable generation.
  //
  // Does a few things:
  //
  // 1.) Organizes better.
  // 2.) Reads better.
  // 3.) Enforces version 7.
  //
  // It is written as so (minorly verbose) to allow:
  // 1.) Elemental compilation (constructor pattern)
  // 2.) Literal compilation. An assignment via nested elements.
  //
  // * The constructor pattern needs a bit of work at the moment.
  // todo: Needs multiple enum implementations for ease of use.
  // todo: All of these are encapsulated within fixme comments.

  const create = vector.create2d;

  function sVec(input: Vec2): string {
    return input.x + "," + input.y
  }

  /**
   * Convert an array into a single string representation.
   * @param input Array of strings.
   * @returns Array as single string concatenated with ","
   */
  function arrayToString(input: string[]): string {
    let temp = ""
    let index = 0
    for (const value of input) {
      if (index != 0) {
        temp += ","
      }
      temp += value
      index++
    }
    return temp
  }


  //? Definition root.

  export interface FormsSpecDefinition {
    size?: Vec2
    fixedSize?: boolean
    position?: Vec2
    anchor?: Vec2
    padding?: Vec2
    disablePrepend?: boolean
    elements: Element[]
  }

  export class FormSpec {
    size?: Vec2
    fixedSize?: boolean
    position?: Vec2
    anchor?: Vec2
    padding?: Vec2
    disablePrepend?: boolean
    elements: Element[]

    constructor(definition: FormsSpecDefinition) {
      this.size = definition.size
      this.fixedSize = definition.fixedSize
      this.position = definition.position
      this.anchor = definition.anchor
      this.padding = definition.padding
      this.disablePrepend = definition.disablePrepend
      this.elements = definition.elements
    }

    attachElement(newElement: Element): FormSpec {
      this.elements.push(newElement)
      return this
    }
  }

  //? Element prototype.

  interface Element {

  }

  //? Container

  export interface ContainerDefinition {
    position: Vec2
    elements: Element[]
  }

  export class Container implements Element {
    position: Vec2
    elements: Element[]
    constructor(definition: ContainerDefinition) {
      this.position = definition.position,
      this.elements = definition.elements
    }
    attachElement(newElement: Element): Container {
      this.elements.push(newElement)
      return this
    }
  }

  //? Scroll container

  export enum ScrollOrientation {
    vertical = "vertical",
    horizontal = "horizontal"
  }

  export interface ScrollContainerDefinition extends ContainerDefinition {
    size: Vec2
    orientation: ScrollOrientation
    factor?: number
    name: string
  }

  export class ScrollContainer extends Container {
    size: Vec2
    orientation: ScrollOrientation
    factor: number
    name: string
    constructor(definition: ScrollContainerDefinition) {
      super({
        position: definition.position,
        elements: definition.elements
      })
      this.size = definition.size
      this.orientation = definition.orientation
      this.factor = definition.factor || 0.1
      this.name = definition.name
    }
  }

  //? List

  export interface ListDefinition {
    location: string,
    listName: string,
    position: Vec2
    size: Vec2,
    startingIndex: number
  }

  export class List implements Element {
    location: string
    listName: string
    position: Vec2
    size: Vec2
    startingIndex: number
    constructor(definition: ListDefinition) {
      this.location = definition.location
      this.listName = definition.listName
      this.position = definition.position
      this.size = definition.size
      this.startingIndex = definition.startingIndex
    }
  }

  //? ListRing

  export interface ListRingDefinition {
    location: string
    listName: string
  }

  export class ListRing implements Element {
    location: string
    listName: string
    constructor(definition: ListRingDefinition) {
      this.location = definition.location
      this.listName = definition.listName
    }
  }

  //? ListColors

  export interface ListColorsDefinition {
    slotBGNormal: string
    slotBGHover: string
    slotBorder?: string
    toolTipBGColor?: string
    toolTipFontColor?: string
  }

  export class ListColors implements Element {
    slotBGNormal: string
    slotBGHover: string
    slotBorder?: string
    toolTipBGColor?: string
    toolTipFontColor?: string
    constructor(definition: ListColorsDefinition) {
      this.slotBGNormal = definition.slotBGNormal
      this.slotBGHover = definition.slotBGHover
      this.slotBorder = definition.slotBorder
      this.toolTipBGColor = definition.toolTipBGColor
      this.toolTipFontColor = definition.toolTipFontColor
    }
  }

  //? ElementToolTip

  export interface ElementToolTipDefinition {
    guiElementName: string
    text: string
    //! Note: This is optional in spec but I don't feel like it at the moment.
    bgColor: string
    fontColor: string
  }

  export class ElementToolTip implements Element {
    guiElementName: string
    text: string
    //! Note: This is optional in spec but I don't feel like it at the moment.
    bgColor: string
    fontColor: string
    constructor(definition: ElementToolTipDefinition) {
      this.guiElementName = definition.guiElementName
      this.text = definition.text
      this.bgColor = definition.bgColor
      this.fontColor = definition.fontColor
    }
  }

  //? AreaToolTip

  export interface AreaToolTipDefinition {
    position: Vec2
    size: Vec2
    text: string
    bgColor: string
    fontColor: string
  }

  export class AreaToolTip implements Element {
    position: Vec2
    size: Vec2
    text: string
    bgColor: string
    fontColor: string
    constructor(definition: AreaToolTipDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.text = definition.text
      this.bgColor = definition.bgColor
      this.fontColor = definition.fontColor
    }
  }

  //? Image

  export interface ImageDefinition {
    position: Vec2
    size: Vec2
    texture: string
    middle?: string
  }

  export class Image implements Element {
    position: Vec2
    size: Vec2
    texture: string
    middle?: string
    constructor(definition: ImageDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.texture = definition.texture
      this.middle = definition.middle
    }
  }

  //? AnimatedImage

  export interface AnimatedImageDefinition extends ImageDefinition {
    name: string
    frameCount: number
    frameDuration: number
    frameStart: number
  }

  export class AnimatedImage extends Image {
    name: string
    frameCount: number
    frameDuration: number
    frameStart: number
    constructor(definition: AnimatedImageDefinition) {
      super(definition)
      this.name = definition.name
      this.frameCount = definition.frameCount
      this.frameDuration = definition.frameDuration
      this.frameStart = definition.frameStart
    }
  }
  
  //? Model

  export interface ModelDefinition {
    position: Vec2
    size: Vec2
    name: string
    mesh: string
    textures: string[]
    rotation: Vec2
    continuous: boolean
    mouseControl: boolean
    frameLoopRange: Vec2
    animationSpeed: number
  }

  export class Model implements Element {
    position: Vec2
    size: Vec2
    name: string
    mesh: string
    textures: string[]
    rotation: Vec2
    continuous: boolean
    mouseControl: boolean
    frameLoopRange: Vec2
    animationSpeed: number
    constructor(definition: ModelDefinition) {
      this.position = definition.position
      this.size = definition. size
      this.name = definition.name
      this.mesh = definition.mesh
      this.textures = definition.textures
      this.rotation = definition.rotation
      this.continuous = definition.continuous
      this.mouseControl = definition.mouseControl
      this.frameLoopRange = definition.frameLoopRange
      this.animationSpeed = definition.animationSpeed
    }
  }

  //? BGColor

  export interface BGColorDefinition {
    //! This one is quite confusing in docs
    bgColor: string
    fullScreen: boolean | string
    fullScreenbgColor: string
  }

  export class BGColor implements Element{
    //! This one is quite confusing in docs
    bgColor: string
    fullScreen: boolean | string
    fullScreenbgColor: string
    constructor(definition: BGColorDefinition) {
      this.bgColor = definition.bgColor
      this.fullScreen = definition.fullScreen
      this.fullScreenbgColor = definition.fullScreenbgColor
    }
  }

  //? Background

  export interface BackgroundDefinition {
    position: Vec2
    size: Vec2
    texture: string
    autoClip?: boolean
    middle?: string
  }

  export class Background  implements Element {
    position: Vec2
    size: Vec2
    texture: string
    autoclip?: boolean
    middle?: string
    constructor(definition: BackgroundDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.texture = definition.texture
      this.autoclip = definition.autoClip
      this.middle = definition.middle
    }
  }

  //? PasswordField

  export interface PasswordFieldDefinition {
    position: Vec2
    size: Vec2
    name: string
    label: string
  }

  export class PasswordField implements Element {
    position: Vec2
    size: Vec2 
    name: string
    label: string
    constructor(definition: PasswordFieldDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.label = definition.label
    }
  }

  //? Field

  export interface FieldDefinition {
    position?: Vec2
    size?: Vec2
    name: string
    label: string
    default: string
  }

  export class Field implements Element{
    position?: Vec2
    size?: Vec2
    name: string
    label: string
    default: string
    constructor(definition: FieldDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.label = definition.label
      this.default = definition.default
    }
  }

  //? FieldEnterAfterEdit

  export class FieldEnterAfterEdit implements Element {
    name: string
    constructor(name: string) {
      this.name = name
    }
  }

  //? FieldCloseOnEnter

  export class FieldCloseOnEnter implements Element {
    name: string
    constructor(name: string) {
      this.name = name
    }
  }

  //? TextArea

  export interface TextAreaDefinition {
    position: Vec2
    size: Vec2
    name: string
    label: string
    default: string
  }

  export class TextArea implements Element {
    position: Vec2
    size: Vec2
    name: string
    label: string
    default: string
    constructor(definition: TextAreaDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.label = definition.label
      this.default = definition.default
    }
  }

  //? Label

  export interface LabelDefinition {
    position: Vec2
    label: string
  }

  export class Label implements Element {
    position: Vec2
    label: string
    constructor(definition: LabelDefinition) {
      this.position = definition.position
      this.label = definition.label
    }
  }

  //? HyperText

  export interface HyperTextDefinition {
    position: Vec2
    size: Vec2
    name: string
    text: string
  }

  export class HyperText implements Element {
    position: Vec2
    size: Vec2
    name: string
    text: string
    constructor(definition: HyperTextDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.text = definition.text
    }
  }

  //? VertLabel

  export interface VertLabelDefinition {
    position: Vec2
    label: string
  }

  export class VertLabel implements Element {
    position: Vec2
    label: string
    constructor(definition: VertLabelDefinition) {
      this.position = definition.position
      this.label = definition.label
    }
  }

  //? Button

  export interface ButtonDefinition {
    position: Vec2
    size: Vec2
    name: string
    label: string
  }

  export class Button implements Element {
    position: Vec2
    size: Vec2
    name: string
    label: string
    constructor(definition: ButtonDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.label = definition.label
    }
  }

  //? ImageButton

  export interface ImageButtonDefinition extends ButtonDefinition{
    texture: string
  }

  export class ImageButton extends Button {
    texture: string
    constructor(definition: ImageButtonDefinition) {
      super(definition)
      this.texture = definition.texture
    }
  }

  //? ImageButtonAdvanced

  export interface ImageButtonAdvancedDefinition extends ImageButtonDefinition {
    noClip: boolean
    drawBorder: boolean
    pressedTexture: string
  }

  export class ImageButtonAdvanced extends ImageButton {
    noClip: boolean
    drawBorder: boolean
    pressedTexture: string
    constructor(definition: ImageButtonAdvancedDefinition) {
      super(definition)
      this.noClip = definition.noClip
      this.drawBorder = definition.drawBorder
      this.pressedTexture = definition.pressedTexture
    }
  }

  //? ItemImageButton

  export interface ItemImageButtonDefinition {
    position: Vec2
    size: Vec2
    itemName: string
    name: string
    label: string
  }

  export class ItemImageButton implements Element {
    position: Vec2
    size: Vec2
    itemName: string
    name: string
    label: string
    constructor(definition: ItemImageButtonDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.itemName = definition.itemName
      this.name = definition.name
      this.label = definition.label
    }
  }

  //? ButtonExit

  export class ButtonExit extends Button {
    //* Placeholder because I'm not sure minetest JIT impl will work with pure extension.
    buttonExit: boolean = false
  }

  //? ImageButtonExit

  export class ImageButtonExit extends ImageButton {
    //* Placeholder because I'm not sure minetest JIT impl will work with pure extension.
    imageButtonExit: boolean = false
  }

  //? TextList

  export interface TextListDefinition {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    items: string[]
    selectedIndex: number
    transparent: boolean
  }

  export class TextList implements Element {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    items: string[]
    selectedIndex: number
    transparent: boolean
    constructor(definition: TextListDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.items = definition.items
      this.selectedIndex = definition.selectedIndex
      this.transparent = definition.transparent
    }
  }

  //? TabHeader

  export interface TabHeaderDefinition {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    captions: string[]
    currentTab: number
    transparent: boolean
    drawBorder: boolean
  }

  export class TabHeader implements Element {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    captions: string[]
    currentTab: number
    transparent: boolean
    drawBorder: boolean
    constructor(definition: TabHeaderDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.captions = definition.captions
      this.currentTab = definition.currentTab
      this.transparent = definition.transparent
      this.drawBorder = definition.drawBorder
    }
  }

  //? Box

  export interface BoxDefinition {
    position: Vec2
    size: Vec2
    color: string
  }

  export class Box implements Element {
    position: Vec2
    size: Vec2
    color: string
    constructor(definition: BoxDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.color = definition.color
    }
  }

  //? DropDown

  export interface DropDownDefinition {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    items: string[]
    selectedIndex: number
    indexEvent: boolean
  }

  export class DropDown implements Element {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    items: string[]
    selectedIndex: number
    indexEvent: boolean
    constructor(definition: DropDownDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.items = definition.items
      this.selectedIndex = definition.selectedIndex
      this.indexEvent = definition.indexEvent
    }
  }

  //? CheckBox

  export interface CheckBoxDefinition {
    position: Vec2
    name: string
    label: string
    selected: boolean
  }

  export class CheckBox implements Element {
    position: Vec2
    name: string
    label: string
    selected: boolean
    constructor(definition: CheckBoxDefinition) {
      this.position = definition.position
      this.name = definition.name
      this.label = definition.label
      this.selected = definition.selected
    }
  }

  //? ScrollBar

  export interface ScrollBarDefinition {
    position: Vec2
    size: Vec2
    orientation: string
    name: string
    value: string
  }

  export class ScrollBar implements Element {
    position: Vec2
    size: Vec2
    //! Fixme: This should be an enum!
    orientation: string
    name: string
    value: string
    constructor(definition: ScrollBarDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.orientation = definition.orientation
      this.name = definition.name
      this.value = definition.value
    }
  }

  //? ScrollBarOptions

  export class ScrollBarOptions implements Element {
    //! Fixme: This might be an enum!
    scrollBarOptions: string[]
    constructor(options: string[]) {
      this.scrollBarOptions = options
    }
  }

  //? Table

  export interface TableDefinition {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    cells: string[]
    selectedIndex: number
  }

  export class Table implements Element {
    position: Vec2
    size: Vec2
    name: string
    //! Fixme: This might be an enum!
    cells: string[]
    selectedIndex: number
    constructor(definition: TableDefinition) {
      this.position = definition.position
      this.size = definition.size
      this.name = definition.name
      this.cells = definition.cells
      this.selectedIndex = definition.selectedIndex
    }
  }

  //? TableOptions

  export class TableOptions implements Element {
    //! Fixme: This might be an enum!
    tableOptions: string[]
    constructor(options: string[]) {
      this.tableOptions = options
    }
  }

  //? TableColumns

  export class TableColumns implements Element {
    //! Fixme: This might be an enum!
    tableColumns: string[]
    constructor(columns: string[]) {
      this.tableColumns = columns
    }
  }

  //? Style

  export class Style implements Element {
    //! Fixme: This might be an enum!
    styleThings: string[]
    constructor(styleThings: string[]) {
      this.styleThings = styleThings
    }
  }

  //? StyleType

  export class StyleType implements Element {
    //! Fixme: This might be an enum!
    styleTypes: string[]
    constructor(styleTypes: string[]) {
      this.styleTypes = styleTypes
    }
  }

  //? SetFocus

  export interface SetFocusDefinition {
    name: string
    force: boolean
  }

  export class SetFocus implements Element {
    name: string
    force: boolean
    constructor(definition: SetFocusDefinition) {
      this.name = definition.name
      this.force = definition.force
    }
  }


  // ? Functional implementation

  //* This function will recurse.
  function processElements(accumulator: string, elementArray: Element[]): string {
    // print(dump(elementArray))
    for (const element of elementArray) {

      if (element instanceof Container) {

        const pos = element.position
        accumulator += "container[" +  sVec(pos) + "]\n"
        
        //* todo: recurse here.
        // accumulator = processElements(accumulator, element.elements)

        accumulator += "container_end[]\n"

      } else if (element instanceof ScrollContainer) {

        const pos = element.position
        const size = element.size
        accumulator += "scroll_container[" + sVec(pos) + ";" + sVec(size) + ";" +
        element.name + ";" + element.orientation + ";" + element.factor + "]\n"

        //* todo: recurse here
        // accumulator = processElements(accumulator, element.elements)

        accumulator += "scroll_container_end[]\n"

      } else if (element instanceof List) {

        const location = element.location
        const listName = element.listName
        const pos = element.position
        const size = element.size
        const startingIndex = element.startingIndex

        accumulator += "list[" + location + ";" + listName + ";" + sVec(pos) + ";" + sVec(size) + ";" + startingIndex + "]\n"

      } else if (element instanceof ListRing) {

        // listring[<inventory location>;<list name>]
        const location = element.location
        const listName = element.listName

        accumulator += "listring[" + location + ";" + listName + "]\n"

      } else if (element instanceof ListColors) {

        //* This is 3 different API implementations in one, so it's using an assembly pattern.
        const slotBGNormal = element.slotBGNormal
        const slotBGHover = element.slotBGHover
        accumulator += "listcolors[" + slotBGNormal + ";" + slotBGHover
        
        // Next definition
        const slotBorder = element.slotBorder
        if (slotBorder) {
          accumulator += ";" + slotBorder

          // Next definition
          const toolTipBGColor = element.toolTipBGColor
          const toolTipFontColor = element.toolTipFontColor

          if (toolTipBGColor && toolTipFontColor) {
            accumulator += ";" + toolTipBGColor + ";" + toolTipFontColor
          }
        }

        // Now finish the sandwich.
        accumulator += "]\n"

      } else if (element instanceof ElementToolTip) {

        const guiElementName = element.guiElementName
        const text = element.text
        const bgColor = element.bgColor
        const fontColor = element.fontColor

        accumulator += "tooltip[" + guiElementName + ";" + text + ";" + bgColor + ";" + fontColor + "]\n"

      } else if (element instanceof AreaToolTip) {
        
        const pos = element.position
        const size = element.size
        const text = element.text
        const bgcolor = element.bgColor
        const fontcolor = element.fontColor

        accumulator += "tooltip[" + sVec(pos) + ";" + sVec(size) + ";" + text + ";" + bgcolor + ";" + fontcolor + "]\n"

      } else if (element instanceof Image) {

        const pos = element.position
        const size = element.size
        const texture = element.texture
        const middle = element.middle

        accumulator += "image[" + sVec(pos) + ";" + sVec(size) + ";" + texture

        if (middle) {
          accumulator += ";" + middle
        }

        accumulator += "]\n"

      } else if (element instanceof AnimatedImage) {

        const pos = element.position
        const size = element.size
        const texture = element.texture
        const name = element.name
        const frameCount = element.frameCount
        const frameDuration = element.frameDuration
        const frameStart = element.frameStart
        const middle = element.middle

        accumulator += "animated_image[" + sVec(pos) + ";" + sVec(size) + ";" + 
        name + ";" + texture + ";" + frameCount + ";" + frameDuration + ";" + frameStart

        if (middle) {
          accumulator += ";" + middle
        }

        accumulator += "]\n"

      } else if (element instanceof Model) {

        const pos = element.position
        const size = element.size
        const name = element.name
        const mesh = element.mesh

        const textures = arrayToString(element.textures)

        const rotation = element.rotation
        const continuous = element.continuous
        const mouseControl = element.mouseControl
        const frameLoopRange = element.frameLoopRange
        const animationSpeed = element.animationSpeed
        
        accumulator += "model[" + sVec(pos) + ";" + sVec(size) + ";" +
        name + ";" + mesh + ";" + textures + ";" + sVec(rotation) + ";" +
        continuous + ";" + mouseControl + ";" + sVec(frameLoopRange) + ";" +
        animationSpeed + "]\n"

      } else if (element instanceof BGColor) {

        const bgcolor = element.bgColor
        const fullScreen = element.fullScreen
        const fullScreenbgColor = element.fullScreenbgColor

        accumulator += "bgcolor[" + bgcolor + ";" + fullScreen + ";" + fullScreenbgColor + "]\n"

      } else if (element instanceof Background) {

        const pos = element.position
        const size = element.size
        const texture = element.texture
        const autoClip = (element.autoclip) ? true : false
        const middle = element.middle

        if (middle) {
          accumulator += "background9["
        } else {
          accumulator += "background["
        }

        accumulator += sVec(pos) + ";" + sVec(size) + ";" + texture + ";" + autoClip

        if (middle) {
          accumulator += ";" + middle
        }

        accumulator += "]\n"

      } else if (element instanceof PasswordField) {

        const pos = element.position
        const size = element.size
        const name = element.name
        const label = element.label

        accumulator += "pwdfield[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + label + "]\n"

      } else if (element instanceof Field) {

        const pos = element.position
        const size = element.size

        accumulator += "field["

        if (pos && size) {
          accumulator += sVec(pos) + ";" + sVec(size) + ";"
        }

        const name = element.name
        const label = element.label
        const def = element.default

        accumulator += name + ";" + label + ";" + def + "]\n"
        
      } else if (element instanceof FieldEnterAfterEdit) {

        const name = element.name
        accumulator += "field_enter_after_edit[" + name + ";" + true + "]\n"

      } else if (element instanceof FieldCloseOnEnter) {

        const name = element.name
        accumulator += "field_close_on_enter[" + name + ";" + true + "]\n"

      } else if (element instanceof TextArea) {

        const pos = element.position
        const size = element.size
        const name = element.name
        const label = element.label
        const def = element.default

        accumulator += "textarea[" + sVec(pos) + ";" + sVec(size) + ";" +
        name + ";" + label + ";" + def + "]\n"

      } else if (element instanceof Label) {

        const pos = element.position
        const label = element.label

        accumulator += "label[" + sVec(pos) + ";" + label + "]\n"

      } else if (element instanceof HyperText) {

        const pos = element.position
        const size = element.size
        const name = element.name
        const text = element.text

        accumulator += "hypertext[" + sVec(pos) + ";" + sVec(size) + ";" +
        name + ";" + text + "]\n"

      } else if (element instanceof VertLabel) {

        const pos = element.position
        const label = element.label

        accumulator += "vertlabel[" + sVec(pos) + ";" + label + "]\n"

      } else if (element instanceof Button) {

        const pos = element.position
        const size = element.size
        const name = element.name
        const label = element.label

        accumulator += "button[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + label + "]\n"

      } else if (element instanceof ImageButton) {

        const pos = element.position
        const size = element.size
        const texture = element.texture
        const name = element.name
        const label = element.label

        accumulator += "button[" + sVec(pos) + ";" + sVec(size) + ";" + texture + ";" + name + ";" + label + "]\n"

      } else if (element instanceof ImageButtonAdvanced) {

        const pos = element.position
        const size = element.size
        const texture = element.texture
        const name = element.name
        const label = element.label
        const noClip = element.noClip
        const drawBorder = element.drawBorder
        const pressedTexture = element.pressedTexture

        accumulator += "button[" + sVec(pos) + ";" + sVec(size) + ";" + texture + ";" + name + ";" + label + ";" + 
        noClip + ";" + drawBorder + ";" + pressedTexture + "]\n"

      } else if (element instanceof ItemImageButton) {

        const pos = element.position
        const size = element.size
        const itemName = element.itemName
        const name = element.name
        const label = element.label

        accumulator += "item_image_button[" + sVec(pos) + ";" + sVec(size) + ";" + itemName + ";" +
        name + ";" + label + "]\n"

      } else if (element instanceof ButtonExit) {

        const pos = element.position
        const size = element.size
        const name = element.name
        const label = element.label

        accumulator += "button_exit[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + label + "]\n"

      } else if (element instanceof TextList) {

        const pos = element.position
        const size = element.size
        const name = element.name

        const listOfItems = arrayToString(element.items)

        const selectedIndex = element.selectedIndex
        const transparent = element.transparent

        accumulator += "textlist[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + listOfItems + ";" +
        selectedIndex + ";" + transparent + "]\n"

      } else if (element instanceof TabHeader) {

        const pos = element.position
        const size = element.size
        const name = element.name

        const listOfCaptions = arrayToString(element.captions)

        const currentTab = element.currentTab
        const transparent = element.transparent
        const drawBorder = element.drawBorder

        accumulator += "tabheader[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + listOfCaptions + ";" +
        currentTab + ";" + transparent + ";" + drawBorder + "]\n"

      } else if (element instanceof Box) {

        const pos = element.position
        const size = element.size
        const color = element.color

        accumulator += "box[" + sVec(pos) + ";" + sVec(size) + ";" + color + "]\n"
        
      } else if (element instanceof DropDown) {

        const pos = element.position
        const size = element.size
        const name = element.name

        const itemList = arrayToString(element.items)

        const selectedIndex = element.selectedIndex
        const indexEvent = element.indexEvent

        accumulator += "dropdown[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + itemList + ";" +
        selectedIndex + ";" + indexEvent + "]\n"


      } else if (element instanceof CheckBox) {

        const pos = element.position
        const name = element.name
        const label = element.label
        const selected = element.selected

        accumulator += "checkbox[" + sVec(pos) + ";" + name + ";" + label + ";" + selected + "]\n"

      } else if (element instanceof ScrollBar) {

        const pos = element.position
        const size = element.size
        const orientation = element.orientation
        const name = element.name
        const value = element.value
      
        accumulator += "scrollbar[" + sVec(pos) + ";" + sVec(size) + ";" + orientation + ";" +
        name + ";" + value + "]\n"

      } else if (element instanceof ScrollBarOptions) {

        const options = arrayToString(element.scrollBarOptions)

        accumulator += "scrollbaroptions[" + options + "]\n"

      } else if (element instanceof Table) {

        // table[<X>,<Y>;<W>,<H>;<name>;<cell 1>,<cell 2>,...,<cell n>;<selected idx>]

        const pos = element.position
        const size = element.size
        const name = element.name

        const cellList = arrayToString(element.cells)

        const selectedIndex = element.selectedIndex

        accumulator += "table[" + sVec(pos) + ";" + sVec(size) + ";" + name + ";" + cellList + ";" + selectedIndex + "]\n"

      } else if (element instanceof TableOptions) {

        const options = arrayToString(element.tableOptions)
        
        accumulator += "tableoptions[" + options + "]\n"

      } else if (element instanceof TableColumns) {

        const columns = arrayToString(element.tableColumns)

        accumulator += "tablecolumns[" + columns + "]\n"

      } else if (element instanceof Style) {

        const styleThings = arrayToString(element.styleThings)

        accumulator += "style[" + styleThings + "]\n"

      } else if (element instanceof StyleType) {

        const styleTypes = arrayToString(element.styleTypes)

        accumulator += "style_type[" + styleTypes + "]\n"

      } else if (element instanceof SetFocus) {

        const name = element.name
        const force = element.force

        accumulator += "set_focus[" + name + ";" + force + "]\n"

      }


      




    }

    
    return accumulator
  }

  export function generate(d: FormSpec): string {
    //? figure out if newlines are necessary.
    //* note: components of formspecs are context sensitive.
    //* so this turns into a bunch of if-then checks in order.
    
    let accumulator = "formspec_version[7]\n"
    if (d.size) {
      const fixed = (d.fixedSize) ? true : false
      const size = d.size
      accumulator += "size[" + sVec(size) + "," + fixed + "]\n"
    }
    if (d.position) {
      const pos = d.position
      accumulator += "position[" + sVec(pos) + "]\n"
    }
    if (d.anchor) {
      const anchor = d.anchor
      accumulator += "anchor[" + sVec(anchor) + "]\n"
    }
    if (d.padding) {
      const p = d.padding
      accumulator += "padding[" + sVec(p) + "]\n"
    }
    if (d.disablePrepend) {
      accumulator += "no_prepend[]\n"
    }
    // Now recurse all elements in the array.
    accumulator = processElements(accumulator, d.elements)
    
    return accumulator
  }
  
}