namespace mineos {
  const create = vector.create;
  const create2d = vector.create2d;
  const color = colors.color;
  const colorRGB = colors.colorRGB;
  const colorScalar = colors.colorScalar;

  class MenuComponent {
    buttonLabel: string
    buttonName: string
    constructor(label: string, name: string) {
      this.buttonLabel = label
      this.buttonName = name
    }
  }

  // Callback to actually start the menu.
  function sendStartMenuSignal(_: any): void {
    const system = getSystem()
    const currProg = system.currentProgram as RunProcedure
    currProg.startMenuFlag = true
  }

  class RunProcedure extends Program {

    desktopLoaded = false
    startMenuFlag = false
    startMenuOpened = false

    menuComponents: MenuComponent[] = [
      // Chip's Challenge
      new MenuComponent("bitsObjection", "Bit's Objection")
    ]

    toggleStartMenu(): void {
      if (this.startMenuOpened) {
        for (const component of this.menuComponents) {
          this.renderer.removeComponent(component.buttonLabel)
        }

        this.renderer.removeComponent("startMenuBackground")

      } else {

        this.renderer.addElement("startMenuBackground", new gui.Box({
          position: create2d(0,0),
          size: create2d(1,1),
          color: colorScalar(70)
        }))

      }

      this.startMenuOpened = !this.startMenuOpened
      this.startMenuFlag = false
      print("start clicked!")
    }

    loadDesktop(): void {
      System.out.println("loading desktop environment")

      this.system.clearCallbacks()

      this.renderer.setClearColor(0,0,0)

      this.renderer.addElement("background", new gui.Box({
        position: create2d(0,0),
        size: create2d(4000, 15.5),
        color: colorRGB(1,130,129)
      }))
      
      this.renderer.addElement("menuBar", new gui.Box({
        position: create2d(2,this.renderer.frameBufferScale.y * 15.5),
        size: create2d(4000,1),
        color: colorScalar(70)
      }))

      this.renderer.addElement("startButton", new gui.Button({
        position: create2d(0,15.5),
        size: create2d(2,1),
        name: "startButton",
        label: "Start"
      }))

      this.system.registerCallback("startButton", sendStartMenuSignal);

      this.desktopLoaded = true
      System.out.println("desktop environment loaded")
    }

    main(delta: number): void {
      
      if (!this.desktopLoaded) this.loadDesktop()
      if (this.startMenuFlag) this.toggleStartMenu()

    }
  }

  System.registerProgram(RunProcedure)
}