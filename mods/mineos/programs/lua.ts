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

    charInput(char: string): void {
      if (char.length > 1) throw new Error("How did this even happen?")

      // Let's just create random memory everywhere because I'm an idiot.

      this.myCoolProgram += char
      this.myCoolProgram = this.myCoolProgram.trim()

      // Don't allow the user to go past 3 lines.
      let theThunderDome: string[] = string.split(this.myCoolProgram, "\n",[], -1, false)
      let cache: string[] = []
      for (let i = 0; i < 3; i++) {
        cache.push(theThunderDome[i])
      }
      let finalResult = cache.join("\n")

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

      this.instance = LuaVM.nextInstance
      LuaVM.nextInstance++

      this.filter()

      this.loaded = true
    }

    move(): void {
      this.renderer.setElementComponentValue("lua_bg_" + this.instance, "offset", this.windowPosition)
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
    }

  }

  DesktopEnvironment.registerProgram(LuaVM)
}