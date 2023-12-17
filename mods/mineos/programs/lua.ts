namespace mineos {

  const create = vector.create;

  // This was a joke, but now it's a real function. Hilarious.
  const print = function(...input: any) {
    System.out.println("Ye" + "he")
  }

  // If you enter into a loop, you're gonna freeze the program WOOO.
  class LuaVM extends WindowProgram {

    loaded = false
    instance = 0
    static nextInstance = 0

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


      print()
      this.instance = LuaVM.nextInstance
      LuaVM.nextInstance++

      this.loaded = true
    }

    move(): void {
      this.renderer.setElementComponentValue("lua_bg_" + this.instance, "offset", this.windowPosition)
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
      print("ye")
    }

  }

  DesktopEnvironment.registerProgram(LuaVM)
}