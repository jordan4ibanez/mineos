namespace mineos {

  const create = vector.create;

  // This was a joke, but now it's a real function. Hilarious.
  const print = function(...input: any) {
    System.out.println(...input)
  }

  // If you enter into a loop, you're gonna freeze the program WOOO.
  class LuaVM extends WindowProgram {

    loaded = false
    instance = 0
    static nextInstance = 0
    myCoolProgram = ""
    version = 5.10000000000001456

    charInput(char: string): void {
      if (char.length > 1) throw new Error("How did this even happen?")
      // Don't allow the user to go past 3 lines.
      this.myCoolProgram = (this.myCoolProgram + char).trim().split("\n", 3).join()
    }

    charDelete(): void {
      let length = this.myCoolProgram.length - 1
      if (length < 0) length = 0
      let finalResult = this.myCoolProgram.slice(0, -1)
      this.myCoolProgram = finalResult
    }

    load() {

      this.renderer.addElement("lua_bg_" + this.instance, {
        name: "lua_bg_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(30,30,30) + ":255",
        scale: this.windowSize,
        alignment: create(1,1),
        offset: create(
          this.getPosX(),
          this.getPosY(),
        ),
        z_index: 1
      })

      this.charInput("1")
      print(this.myCoolProgram)
      this.charDelete()
      print(this.myCoolProgram)

      this.instance = LuaVM.nextInstance
      LuaVM.nextInstance++

      this.loaded = true
    }

    floatError(): void {
      if (math.random() > 0.5) {
        this.version += 0.00000000000001
      } else {
        this.version -= 0.00000000000001
      }
      this.setWindowTitle("LuaJIT " + tostring(this.version))
    }

    move(): void {
      this.renderer.setElementComponentValue("lua_bg_" + this.instance, "offset", this.windowPosition)
    }

    main(delta: number): void {
      if (!this.loaded) this.load()

      this.floatError()
    }

  }

  DesktopEnvironment.registerProgram(LuaVM)
}