namespace mineos {
  // const create = vector.create;
  const create = vector.create2d;
  const color = colors.color;
  const colorRGB = colors.colorRGB;
  const colorScalar = colors.colorScalar;

  export class AABB {
    offset: Vec2
    size: Vec2
    anchor: Vec2

    constructor(offset: Vec2, size: Vec2, anchor: Vec2) {
      this.offset = offset
      this.size = size
      this.anchor = anchor
    }

    pointWithin(point: Vec2) {
      const windowSize = getSystem().getRenderer().frameBufferSize
      const pos = create(
        (this.anchor.x * windowSize.x) + this.offset.x,
        (this.anchor.y * windowSize.y) + this.offset.y,
      )
      return (point.x > pos.x && point.x < pos.x + this.size.x &&
              point.y > pos.y && point.y < pos.y + this.size.y)
    }
  }

  class DesktopComponent {
    collisionBox: AABB
    onClick(desktop: DesktopEnvironment) {}
    onHold(desktop: DesktopEnvironment) {}
    constructor(cbox: AABB, onClick: (this: DesktopComponent, desktop: DesktopEnvironment) => void, onHold: (this: DesktopComponent, desktop: DesktopEnvironment) => void) {
      this.collisionBox = cbox
      this.onClick = onClick
      this.onHold = onHold
    }
  }

  class Icon {
    name: string
    collisionBox: AABB
    texture: string

    constructor(name: string, cbox: AABB, texture: string) {
      this.name = name
      this.collisionBox = cbox
      this.texture = texture
    }
  }

  // The actual desktop portion of the desktop.
  class DesktopIcons extends Program {

    desktop: DesktopEnvironment
    icons: {[id: string]: Icon} = {}
    currentIcon: Icon | null = null
    payload = false

    yOffset = 0


    constructor(system: System, renderer: Renderer, audio: AudioController, runProc: DesktopEnvironment) {
      super(system, renderer, audio)
      this.desktop = runProc
      this.addIcon("trashIcon", "trash_icon.png");
      this.addIcon("emailIcon", "email_icon.png");
      this.addIcon("internetIcon", "internet_icon.png");
    }

    addIcon(iconName: string, iconTexture: string): void {

      const icon = new Icon(iconName, new AABB(
        create(0,this.yOffset),
        create(40,40),
        create(0,0)
      ), iconTexture)

      // print("adding icon " + iconName)
      this.renderer.addElement(iconName, {
        name: iconName,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: icon.texture,
        scale: create(1,1),
        alignment: create(1,1),
        offset: icon.collisionBox.offset,
        z_index: 0
      })

      this.icons[iconName] = icon

      this.yOffset += 40

    }

    corral(): void {

      const windowSize = this.renderer.frameBufferSize
      
      // Don't even bother, this causes problems
      if (windowSize.x < 100 || windowSize.y < 100) {
        return
      }
      const limit = create(
        windowSize.x - 32,
        windowSize.y - 64
      )
      for (const [name, icon] of Object.entries(this.icons)) {
        const offset = icon.collisionBox.offset
        if (offset.x > limit.x) {
          offset.x = limit.x
        }
        if (offset.y > limit.y) {
          offset.y = limit.y
        }
        this.renderer.setElementComponentValue(name, "offset", offset)
      }

    }

    load(): void {
      print("loading desktop icons.")

      this.payload = true
      print("desktop icons loaded.")
    }

    main(delta: number): void {
      if (!this.payload) this.load()

      const mousePos = this.desktop.getMousePos()
      const windowSize = this.renderer.frameBufferSize

      if (this.currentIcon == null) {
        if (this.system.isMouseClicked() && this.desktop.grabbedProgram == null) {
          for (const [name, icon] of Object.entries(this.icons)) {
            if (icon.collisionBox.pointWithin(mousePos)) {
              //todo: Could use this portion to launch an app
              // print("clicking " + name)
              this.currentIcon = icon
              break;
            }
          }
        }
      } else {
        if (this.system.isMouseDown()) {
          this.currentIcon.collisionBox.offset.x = mousePos.x - 20
          this.currentIcon.collisionBox.offset.y = mousePos.y - 20
          if (this.currentIcon.collisionBox.offset.y > windowSize.y - 64) {
            this.currentIcon.collisionBox.offset.y = windowSize.y - 64
          }
          this.renderer.setElementComponentValue(this.currentIcon.name, "offset", this.currentIcon.collisionBox.offset)
        } else {
          this.currentIcon = null
        }
      }
    }
  }

  class StartMenuEntry {
    static yOffset = (-32 * 10) - 10
    name: string
    program: string
    text: string
    collisionBox: AABB
    icon: string

    constructor(name: string, program: string, text: string, icon: string, yOffset?: number) {
      this.name = name
      this.program = program
      this.text = text
      this.collisionBox = new AABB(
        create(1, yOffset || StartMenuEntry.yOffset), //offset
        create(198,32),
        create(0,1) // anchor
      )
      this.icon = icon
      StartMenuEntry.yOffset += 33
    }
  }

  class StartMenu extends Program {

    desktop: DesktopEnvironment
    shown = false
    menuEntries: StartMenuEntry[] = []

    load(): void {
      this.renderer.addElement("startMenu", {
        name: "startMenu",
        hud_elem_type: HudElementType.image,
        position: create(0,1),
        text: "start_menu.png",
        scale: create(1,1),
        alignment: create(1,1),
        offset: create(-210,-332),
        z_index: -3
      })

      // This stays in order in the start menu
      this.menuEntries.push(new StartMenuEntry("boom", "Boom", "Boom", "minetest.png"))
      this.menuEntries.push(new StartMenuEntry("bitsBattle", "BitsBattle", "Bit's Battle", "minetest.png"))
      this.menuEntries.push(new StartMenuEntry("fezSphere", "FezSphere", "Fez Sphere", "minetest.png"))
      this.menuEntries.push(new StartMenuEntry("gong", "Gong", "Gong", "minetest.png"))
      this.menuEntries.push(new StartMenuEntry("sledLiberty", "SledLiberty", "Sled Liberty", "minetest.png"))
      this.menuEntries.push(new StartMenuEntry("shutDown", "", "Shut Down...", "minetest.png", -65))

      for (const entry of this.menuEntries) {
        const offset = entry.collisionBox.offset
        // print(dump(entry))
        this.renderer.addElement(entry.name, {
          name: entry.name,
          hud_elem_type: HudElementType.image,
          position: entry.collisionBox.anchor,
          text: "start_menu_element.png",
          scale: create(1,1),
          alignment: create(1,1),
          offset: create(
            -200,
            offset.y
          ),
          z_index: -2
        })

        this.renderer.addElement(entry.name + "text", {
          name: "time",
          hud_elem_type: HudElementType.text,
          scale: create(1,1),
          text: entry.text,
          number: colors.colorHEX(0,0,0),
          position: entry.collisionBox.anchor,
          alignment: create(1,0),
          offset: create(
            -240,
            offset.y + 16
          ),
          // style: 4,
          z_index: -1
        })
      }
    }

    trigger(): void {
      this.shown = !this.shown
      if (this.shown) {
        this.renderer.setElementComponentValue("startMenu", "offset", create(0,-332))
        for (const entry of this.menuEntries) {
          const offset = entry.collisionBox.offset
          this.renderer.setElementComponentValue(entry.name, "offset", create(1, offset.y))
          this.renderer.setElementComponentValue(entry.name + "text", "offset", create(40, offset.y + 16))
        }
        
      } else {
        this.renderer.setElementComponentValue("startMenu", "offset", create(-210,-332))
        for (const entry of this.menuEntries) {
          const offset = entry.collisionBox.offset
          this.renderer.setElementComponentValue(entry.name, "offset", create(-200, offset.y))
          this.renderer.setElementComponentValue(entry.name + "text", "offset", create(-241, offset.y))
        }
      }
    }

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment) {
      super(system, renderer, audio)
      this.desktop = desktop            
      this.load()
    }

    main(delta: number): void {
      if (!this.shown) return
      if (!this.system.isMouseClicked()) return

      const mousePos = this.desktop.getMousePos()

      for (const element of this.menuEntries) {
        if (!element.collisionBox.pointWithin(mousePos)) continue
        // print("I clicked: " + element.name)
        if (element.name == "shutDown") {
          print("System shutting down...")
          this.system.requestShutdown();
        } else {
          print("Launching program " + element.program)
          this.desktop.launchProgram(element.program, create(540, 480))
        }
        this.trigger()
        break;
      }
    }
  }


  let programQueue: {[id: string] : typeof WindowProgram} = {}

  /**
   * Base layer for the decoration is 0 to 1, don't draw into this.
   */
  const handleHeight = 24
  const buttonSize = handleHeight - 1

  export class WindowProgram extends Program {
    desktop: DesktopEnvironment
    windowSize: Vec2
    windowPosition: Vec2 = create(100,100)
    handle: AABB
    offset: Vec2 = create(0,0)
    readonly uuid: string
    windowTitle: string

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {
      super(system, renderer, audio)
      this.desktop = desktop
      this.windowSize = windowSize
      this.uuid = uuid()
      this.handle = new AABB(
        create(
          this.windowPosition.x,
          this.windowPosition.y - handleHeight + 1
        ),
        create(
          this.windowSize.x,
          handleHeight
        ),
        create(
          0,0
        )
      )
      const stringID = this.uuid + "window_handle"
      this.renderer.addElement(stringID, {
        name: stringID,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + color(50,50,50) + ":255",
        scale: this.handle.size,
        alignment: create(1,1),
        offset: this.handle.offset,
        z_index: 0
      })

      this.windowTitle = "a test title"
      const stringIDTitle = this.uuid + "window_name"
      this.renderer.addElement(stringIDTitle, {
        name: stringIDTitle,
        hud_elem_type: HudElementType.text,
        scale: create(1,1),
        text: this.windowTitle,
        number: colors.colorHEX(0,0,0),
        position: create(0,0),
        alignment: create(1,1),
        offset: create(
          this.handle.offset.x + 2,
          this.handle.offset.y + 3,
        ),
        // style: 4,
        z_index: 1
      })

      const stringIDButton = this.uuid + "window_button"
      this.renderer.addElement(stringIDButton, {
        name: stringIDButton,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + color(60,60,60) + ":255",
        scale: create(buttonSize,buttonSize),
        alignment: create(1,1),
        offset: create(
          this.handle.offset.x + this.handle.size.x - buttonSize,
          this.handle.offset.y
        ),
        z_index: 1
      })
      
      const stringIDButtonX = this.uuid + "window_button_x"
      this.renderer.addElement(stringIDButtonX, {
        name: stringIDButtonX,
        hud_elem_type: HudElementType.text,
        scale: create(1,1),
        text: "X",
        number: colors.colorHEX(0,0,0),
        position: create(0,0),
        alignment: create(1,1),
        offset: create(
          this.handle.offset.x + this.handle.size.x - buttonSize + 6,
          this.handle.offset.y + 3
        ),
        // style: 4,
        z_index: 2
      })
    }

    // Names like this so you know never to call it.
    __INTERNALDELETION(): void {
      this.renderer.removeElement(this.uuid + "window_handle")
      this.renderer.removeElement(this.uuid + "window_name")
      this.renderer.removeElement(this.uuid + "window_button")
      this.renderer.removeElement(this.uuid + "window_button_x")
    }

    setWindowPos(x: number, y: number): void {
      this.windowPosition.x = x
      this.windowPosition.y = y

      this.handle.offset.x = this.windowPosition.x,
      this.handle.offset.y = this.windowPosition.y - handleHeight + 1

      const stringID = this.uuid + "window_handle"
      this.renderer.setElementComponentValue(stringID, "offset", this.handle.offset)

      const stringIDTitle = this.uuid + "window_name"

      this.renderer.setElementComponentValue(stringIDTitle, "offset", create(
        this.handle.offset.x + 2,
        this.handle.offset.y + 3,
      ))

      const stringIDButton = this.uuid + "window_button"
      this.renderer.setElementComponentValue(stringIDButton, "offset", create(
        this.handle.offset.x + this.handle.size.x - buttonSize,
        this.handle.offset.y
      ))

      const stringIDButtonX = this.uuid + "window_button_x"
      this.renderer.setElementComponentValue(stringIDButtonX, "offset", create(
        this.handle.offset.x + this.handle.size.x - buttonSize + 6,
        this.handle.offset.y + 3
      ))

      this.move()

    }

    // We want to know where the actual window starts, not the handle
    getPosX(): number {
      return this.windowPosition.x
    }
    getPosY(): number {
      return this.windowPosition.y
    }
    getWindowPosition(): Vec2 {
      // Creating a new object every time, who cares
      return create(
        this.windowPosition.x,
        this.windowPosition.y
      )
    }

    setWindowSize(x: number, y: number): void {
      this.windowSize.x = x
      this.windowSize.y = y
    }
    setWindowTitle(newTitle: string): void {
      this.windowTitle = newTitle
      const stringIDTitle = this.uuid + "window_name"
      this.renderer.setElementComponentValue(stringIDTitle, "text", newTitle)
    }

    updateHandleWidth(width: number): void {
      const strindID = this.uuid + "window_handle"
      this.handle.size.x = width
      this.renderer.setElementComponentValue(strindID, "scale", this.handle.size)

      const stringIDButton = this.uuid + "window_button"
      this.renderer.setElementComponentValue(stringIDButton, "offset", create(
        this.handle.offset.x + this.handle.size.x - buttonSize,
        this.handle.offset.y
      ))

      const stringIDButtonX = this.uuid + "window_button_x"
      this.renderer.setElementComponentValue(stringIDButtonX, "offset", create(
        this.handle.offset.x + this.handle.size.x - buttonSize + 6,
        this.handle.offset.y + 3
      ))
    }

    move(): void {
      throw new Error("Move not implemented for " + this.windowTitle)
    }
  }


  export class DesktopEnvironment extends Program {

    // So this is a bunch of programs inside of one program that work together. Like a normal DE.

    desktopLoaded = false
    startMenuFlag = false
    startMenuOpened = false
    oldFrameBufferSize = create(0,0)
    mousePosition: Vec2 = create(0,0)

    components: DesktopComponent[] = []
    focused = true
    icons: DesktopIcons
    startMenu: StartMenu
    programBlueprints: {[id: string] : typeof WindowProgram} = {}
    runningPrograms: WindowProgram[] = []
    grabbedProgram: WindowProgram | null = null
    mouseLocked = false


    constructor(system: System, renderer: Renderer, audio: AudioController) {
      super(system, renderer, audio);
      this.icons = new DesktopIcons(system, renderer, audio, this)
      this.startMenu = new StartMenu(system, renderer, audio, this)

      for (const [name, progBlueprint] of Object.entries(programQueue)) {
        // print("added program " + name + " to desktop!")
        this.programBlueprints[name] = progBlueprint
      }
    }

    lockMouse(): void {
      this.mouseLocked = true
    }
    unlockMouse(): void {
      this.mouseLocked = false
      const screenSize = this.renderer.frameBufferSize
      this.mousePosition = create(
        screenSize.x / 2,
        screenSize.y / 2,
      )
    }
    isMouseLocked(): boolean {
      return this.mouseLocked
    }

    static registerProgram(progBlueprint: typeof WindowProgram): void {
      programQueue[progBlueprint.name] = progBlueprint
    }

    launchProgram(progName: string, windowSize: Vec2): void {
      this.runningPrograms.push(new this.programBlueprints[progName](this.system, this.renderer, this.audioController, this, windowSize))
    }

    getMousePos(): Vec2 {
      return this.mousePosition
    }

    // toggleStartMenu(): void {
    //   if (this.startMenuOpened) {
    //     for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
    //       this.renderer.removeComponent(name)
    //     }
    //   } else {
    //     let i = 0
    //     for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
    //       i++
    //     }
    //   }
    //   this.startMenuOpened = !this.startMenuOpened
    //   this.startMenuFlag = false
    //   print("start clicked!")
    // }

    getTimeString(): string {
      // Filter off leading 0.
      const hour = tostring(tonumber(os.date("%I", os.time())))
      
      // Get rest of timestamp and combine.
      return hour + os.date(":%M %p", os.time())
    }

    updateTime(): void {
      this.renderer.setElementComponentValue("time", "text", this.getTimeString())
    }

    loadDesktop(): void {
      System.out.println("loading desktop environment")

      // this.audioController.playSound("osStartup", 0.9)

      // this.system.clearCallbacks()
      this.renderer.clearMemory()

      this.renderer.setClearColor(0,0,0)

      this.renderer.setClearColor(0.39215686274, 50.9803921569, 50.5882352941)

      this.renderer.addElement("taskbar", {
        name: "taskbar",
        hud_elem_type: HudElementType.image,
        position: create(0,1),
        text: "task_bar.png",
        scale: create(1,1),
        alignment: create(1,-1),
        offset: create(0,0),
        z_index: -4
      })

      this.renderer.addElement("start_button", {
        name: "start_button",
        hud_elem_type: HudElementType.image,
        position: create(0,1),
        text: "start_button.png",
        scale: create(1,1),
        alignment: create(1,1),
        offset: create(2,-29),
        z_index: -3
      })

      this.renderer.addElement("time_box", {
        name: "time_box",
        hud_elem_type: HudElementType.image,
        position: create(1,1),
        text: "time_box.png",
        scale: create(1,1),
        alignment: create(-1,1),
        offset: create(-2,-29),
        z_index: -3
      })

      this.renderer.addElement("time", {
        name: "time",
        hud_elem_type: HudElementType.text,
        scale: create(1,1),
        text: this.getTimeString(),
        number: colors.colorHEX(0,0,0),
        position: create(1,1),
        alignment: create(0,-1),
        offset: create(-42,-5),
        // style: 4,
        z_index: -2
      })

      this.renderer.addElement("mouse", {
        name: "mouse",
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "mouse.png",
        scale: create(1,1),
        alignment: create(1,1),
        offset: create(0,0),
        z_index: 10000
      })

      // ? Start menu button.
      this.components.push(new DesktopComponent(
        new AABB(
          create(0,-32),
          create(66,32),
          create(0,1)
        ),
        () => {
          this.startMenu.trigger()
        },
        () => {}
      ))

      // //!!!! DEBUGGING Bit's Battle !!!!!!!
      this.launchProgram("BitsBattle", create(500, 500))

      this.desktopLoaded = true
      System.out.println("desktop environment loaded")
    }

    acceleration = 250

    update() {
      this.renderer.setElementComponentValue("taskbar", "scale", create(this.renderer.frameBufferSize.x, 1))

      const screenSize = this.renderer.frameBufferSize

      const mouseDelta = this.system.getMouseDelta()

      this.mousePosition.x += mouseDelta.x * this.acceleration
      this.mousePosition.y += mouseDelta.y * this.acceleration

      if (this.mousePosition.x >= screenSize.x) {
        this.mousePosition.x = screenSize.x
      } else if (this.mousePosition.x < 0) {
        this.mousePosition.x = 0
      }
      if (this.mousePosition.y >= screenSize.y) {
        this.mousePosition.y = screenSize.y
      } else if (this.mousePosition.y < 0) {
        this.mousePosition.y = 0
      }

      //todo: Make this a function
      if (this.oldFrameBufferSize.x != screenSize.x || this.oldFrameBufferSize.y != screenSize.y) {
        print ("updating fbuffer for desktop")
        this.mousePosition = create(
          screenSize.x / 2,
          screenSize.y / 2,
        )
        // print(dump(this.mousePosition))
        this.oldFrameBufferSize = screenSize;
        this.icons.corral()
      }

      // Now we can simply dump the mouse off the screen if it's "locked"
      if (this.mouseLocked) {
        this.mousePosition.x = 9000
        this.mousePosition.y = 9000
      }

      // -1 to have the inner pixel of the mouse be the pointer.
      const finalizedMousePos = create(
        this.mousePosition.x - 1,
        this.mousePosition.y - 1
      )
  
      // Mouse always positions based on the top left.
      this.renderer.setElementComponentValue("mouse", "offset", finalizedMousePos)

      if (this.grabbedProgram != null) {
        if (this.system.isMouseDown()) {
          this.grabbedProgram.setWindowPos(
            this.mousePosition.x - this.grabbedProgram.offset.x,
            this.mousePosition.y - this.grabbedProgram.offset.y
          )
        } else {
          this.grabbedProgram = null
        }
      }

      // Clicking desktop components
      if (this.system.isMouseClicked()) {

        let deleting = ""
        // window handles before any desktop components
        // let index = 0
        for (const winProgram of this.runningPrograms) {
          if (winProgram.handle.pointWithin(this.mousePosition)) {

            const XAABB = new AABB(create(
                winProgram.handle.offset.x + winProgram.handle.size.x - buttonSize + 6,
                winProgram.handle.offset.y + 3
              ),
              create(buttonSize, buttonSize),
              create(0,0))
            if (XAABB.pointWithin(this.mousePosition)) {
              deleting = winProgram.uuid

            } else {
              this.grabbedProgram = winProgram
              this.grabbedProgram.offset.x = this.mousePosition.x - winProgram.getPosX()
              this.grabbedProgram.offset.y = this.mousePosition.y - winProgram.getPosY()
            }
            break;
          }
          // index++
        }

        if (deleting != "") {

          let i = 0
          for (const winProgram of this.runningPrograms) {
            if (winProgram.uuid == deleting) {
              this.runningPrograms[i].__INTERNALDELETION()
              this.runningPrograms[i].destructor()
              this.runningPrograms.splice(i, 1)
              break;
            }
            i++
          }
        }

        // Now click a component if we're not dragging a window around
        if (this.grabbedProgram == null) {
          for (const element of this.components) {
            if (element.collisionBox.pointWithin(this.mousePosition)) {
              element.onClick(this)
              // Only click one element
              break;
            }
          }
        }
      }
    }

    runPrograms(delta: number): void {
      for (const prog of this.runningPrograms) {
        prog.main(delta)
      }
    }

    main(delta: number): void {
      
      if (!this.desktopLoaded) this.loadDesktop()
      // if (this.startMenuFlag) this.toggleStartMenu()

      this.renderer.update()
      this.update()
      this.icons.main(delta)
      this.startMenu.main(delta)
      this.runPrograms(delta)
      this.updateTime()

    }
  }

  System.registerProgram(DesktopEnvironment)
}