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
    clickCallback: () => void;
    holdCallback: () => void;
    constructor(aabb: AABB, click: (this: DesktopComponent) => void, hold: (this: DesktopComponent) => void) {
      this.collisionBox = aabb;
      this.clickCallback = click;
      this.holdCallback = hold;
    }
  }

  class Icon extends DesktopComponent {}

  // The actual desktop portion of the desktop.
  class DesktopIcons extends Program {
    icons: Icon[] = []
    currentIcon: Icon | null = null

    main(delta: number): void {
      if (!this.system.isMouseDown() && !this.system.isMouseClicked()) return
    }
  }


  class RunProcedure extends Program {

    desktopLoaded = false
    startMenuFlag = false
    startMenuOpened = false
    oldFrameBufferSize = create(0,0)
    mousePosition: Vec2 = create(0,0)

    components: DesktopComponent[] = []
    focused = true

    // currentFocus: Focus;

    constructor(system: System, renderer: Renderer, audio: AudioController) {
      super(system, renderer, audio);
    }

    menuComponents: {[id: string] : string} = {
      // Chip's Challenge
      "BitsBattle": "Bit's Battle",
      // Jezzball
      // "FezSphere": "Fez Sphere",
      // Pong
      // "Gong": "Gong 96",
      // Ski Free
      // "SledQuickly": "Sled Liberty"
    }

    toggleStartMenu(): void {
      if (this.startMenuOpened) {
        for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
          this.renderer.removeComponent(name)
        }
      } else {
        let i = 0
        for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
          i++
        }
      }
      this.startMenuOpened = !this.startMenuOpened
      this.startMenuFlag = false
      print("start clicked!")
    }

    getTimeString(): string {
      // Filter off leading 0.
      const hour = tostring(tonumber(os.date("%I", os.time())))
      
      // Get rest of timestamp and combine.
      return hour + os.date(":%M %p", os.time())
    }

    loadDesktop(): void {
      System.out.println("loading desktop environment")

      this.audioController.playSound("osStartup", 0.9)

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
        z_index: -3
      })

      this.renderer.addElement("start_button", {
        name: "start_button",
        hud_elem_type: HudElementType.image,
        position: create(0,1),
        text: "start_button.png",
        scale: create(1,1),
        alignment: create(1,1),
        offset: create(2,-29),
        z_index: -2
      })

      this.renderer.addElement("time_box", {
        name: "time_box",
        hud_elem_type: HudElementType.image,
        position: create(1,1),
        text: "time_box.png",
        scale: create(1,1),
        alignment: create(-1,1),
        offset: create(-2,-29),
        z_index: -1
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
        z_index: 0
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

      const startMenuButtonAABB = new AABB(
        create(0,-32),
        create(66,32),
        create(0,1)
      )

      this.components.push(new DesktopComponent(
        startMenuButtonAABB,
        () => {
          print("start!")
        },
        () => {}
      ))

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
        print(dump(this.mousePosition))
        this.oldFrameBufferSize = screenSize;
      }

      // -1 to have the inner pixel of the mouse be the pointer.
      const finalizedMousePos = create(
        this.mousePosition.x - 1,
        this.mousePosition.y - 1
      )
  
      // Mouse always positions based on the top left.
      this.renderer.setElementComponentValue("mouse", "offset", finalizedMousePos)

      if (this.system.isMouseClicked()) {
        for (const element of this.components) {
          if (element.collisionBox.pointWithin(this.mousePosition)) {
            element.clickCallback()
          }
        }
      }

      // if (startMenuAABB.pointWithin(this.mousePosition)) {

      //   print("mouse is in " + math.random())
      // }
    }

    main(delta: number): void {
      
      if (!this.desktopLoaded) this.loadDesktop()
      if (this.startMenuFlag) this.toggleStartMenu()

      this.renderer.update()
      this.update()

      this.getTimeString()

    }
  }

  System.registerProgram(RunProcedure)
}