namespace mineos {
  const create = vector.create;
  const create2d = vector.create2d;
  const color = colors.color;
  const colorRGB = colors.colorRGB;
  const colorScalar = colors.colorScalar;


  // Callback to actually start the menu.
  function sendStartMenuSignal(_: any): void {
    print("hi")
    const system = getSystem()
    const currProg = system.currentProgram as RunProcedure
    currProg.startMenuFlag = true
  }

  class RunProcedure extends Program {

    desktopLoaded = false
    startMenuFlag = false
    startMenuOpened = false

    menuComponents: {[id: string] : string} = {
      // Chip's Challenge
      "bitsBattle": "Bit's Battle",
      // Jezzball
      "fezSphere": "Fez Sphere",
      // Pong
      "gong": "Gong 96",
      // Ski Free
      "sledQuickly": "Sled Liberty"
    }

    toggleStartMenu(): void {
      if (this.startMenuOpened) {

        // Now rip off the duct tape
        for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
          this.renderer.removeComponent(name)
        }

        // We have to shift the entire wallpaper back to the left
        const background = this.renderer.getElement("background") as gui.Box
        background.position.x = 0
        // And remove this hack job
        // this.renderer.removeComponent("startMenuBackground")
        this.renderer.removeComponent("backgroundDuctTape")

      } else {

        // Causes things to randomly overlap
        // this.renderer.addElement("startMenuBackground", new gui.Box({
        //   position: create2d(0.25,5.5),
        //   size: create2d(6,10),
        //   color: colorScalar(65)
        // }))

        // We have to shift the entire wallpaper to the right so it doesn't blend 
        const background = this.renderer.getElement("background") as gui.Box
        background.position.x = 6.25
        // Then we gotta patch the space
        this.renderer.addElement("backgroundDuctTape", new gui.Box({
          position: create2d(0,0),
          size: create2d(6.25,5.5),
          color: colorRGB(1,130,129)
        }))

        // Now duct tape on the buttons that randomly won't be clickable
        let i = 0
        for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
          this.renderer.addElement(name, new gui.Button({
            position: create2d(0,6 + (i * 2.5)),
            size: create2d(6.25,1),
            name: name,
            label: progNameNice
          }))
          this.system.registerCallback(name, () => {
            const system = getSystem()
            system.clearCallbacks()
            system.renderer.clearMemory()
            system.changeProgram(name)
          });

          i++
        }


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