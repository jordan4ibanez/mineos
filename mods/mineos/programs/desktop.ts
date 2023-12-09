namespace mineos {
  // const create = vector.create;
  const create = vector.create2d;
  const color = colors.color;
  const colorRGB = colors.colorRGB;
  const colorScalar = colors.colorScalar;


  // Callback to actually start the menu.
  // function sendStartMenuSignal(_: any): void {
  //   print("hi")
  //   const system = getSystem()
  //   const currProg = system.currentProgram as RunProcedure
  //   currProg.startMenuFlag = true
  //   system.audioController.playSound("mouseClick", 1)
  // }

  class RunProcedure extends Program {

    desktopLoaded = false
    startMenuFlag = false
    startMenuOpened = false

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

        this.renderer.setClearColor(0,0,0)

        // Now rip off the duct tape
        for (const [name,progNameNice] of Object.entries(this.menuComponents)) {
          this.renderer.removeComponent(name)
        }

        // We have to shift the entire wallpaper back to the left
        // const background = this.renderer.getElement("background") as gui.Box
        // background.position.x = 0
        // And remove this hack job
        // this.renderer.removeComponent("startMenuBackground")
        this.renderer.removeComponent("backgroundDuctTape")

      } else {

        this.renderer.setClearColor(48,48,48)

        // Now duct tape on the buttons that randomly won't be clickable
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


      this.desktopLoaded = true
      System.out.println("desktop environment loaded")
    }

    update() {
      this.renderer.setElementComponentValue("taskbar", "scale", create(this.renderer.frameBufferSize.x, 1))
    }

    main(delta: number): void {
      
      if (!this.desktopLoaded) this.loadDesktop()
      if (this.startMenuFlag) this.toggleStartMenu()

      this.renderer.update()
      this.update()

      this.getTimeString()

      // if (this.up) {
      //   this.colorTest += delta * this.testMultiplier
      //   if (this.colorTest >= 100) {
      //     this.colorTest = 100
      //     this.up = false
      //   }
      // } else {
      //   this.colorTest -= delta * this.testMultiplier
      //   if (this.colorTest <= 0) {
      //     this.colorTest = 0
      //     this.up = true
      //   }
      // }
      // this.renderer.setClearColor(this.colorTest, this.colorTest, this.colorTest)

    }
  }

  System.registerProgram(RunProcedure)
}