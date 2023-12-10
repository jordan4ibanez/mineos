namespace mineos {
  // const create = vector.create;
  const create = vector.create2d;
  const color = colors.color;
  const colorRGB = colors.colorRGB;
  const colorScalar = colors.colorScalar;

  class AABB {
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
        if (this.system.isMouseClicked()) {
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
  export class WindowProgram extends Program {
    desktop: DesktopEnvironment
    windowSize: Vec2
    windowPosition: Vec2 = create(100,100)
    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {
      super(system, renderer, audio)
      this.desktop = desktop
      this.windowSize = windowSize
    }
    move() {

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

      //!!!! DEBUGGING BOOM !!!!!!!
      this.launchProgram("Boom", create(500, 500))

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

      // -1 to have the inner pixel of the mouse be the pointer.
      const finalizedMousePos = create(
        this.mousePosition.x - 1,
        this.mousePosition.y - 1
      )

      // Now we can simply dump the mouse off the screen if it's "locked"
      if (this.mouseLocked) {
        this.mousePosition.x = 9000
        this.mousePosition.y = 9000
      }
  
      // Mouse always positions based on the top left.
      this.renderer.setElementComponentValue("mouse", "offset", finalizedMousePos)

      if (this.system.isMouseClicked()) {
        for (const element of this.components) {
          if (element.collisionBox.pointWithin(this.mousePosition)) {
            element.onClick(this)
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