namespace mineos {

  const create = vector.create;
  const color = colors.color;

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
    version = 5.1000000000000

    // This is the worst keyboard made by human beings.
    // And probably aliens.
    readonly keyboard = `
    abcdefghijklmn
    opqrstuvwxyz{}
    ="'.,()\\/-+=*!
    `.trim()

    keyboardCbox: {[id: string]: AABB} = {}

    charInput(char: string): void {
      if (char.length > 1) throw new Error("How did this even happen?")
      // Don't allow the user to go past 3 lines.
      this.myCoolProgram = (this.myCoolProgram + char).trim().split("\n", 3).join()
    }

    charDelete(): void {
      this.myCoolProgram = this.myCoolProgram.slice(0, -1)
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

      // Make some terrible buttons.
      const buttonSize = 20
      const buttonSpacing = 21
      let y = 0
      for (const charArray of this.keyboard.split("\n")) {
        let x = 0
        for (const char of charArray.toString().trim()) {

          const rootPos = create(
            this.windowPosition.x + (x * buttonSpacing),
            this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
          )
          
          this.keyboardCbox[char] = new AABB(
            rootPos,
            create(buttonSize, buttonSize),
            create(0,0)
          )

          this.renderer.addElement("lua_button_bg_" + char + "_" + this.instance, {
            name: "lua_button_bg_" + char + "_" + this.instance,
            hud_elem_type: HudElementType.image,
            position: create(0,0),
            text: "pixel.png^[colorize:" + color(50,50,50) + ":255",
            scale: create(
              buttonSize,
              buttonSize
            ),
            alignment: create(1,1),
            offset: rootPos,
            z_index: 2
          })
    
          this.renderer.addElement("lua_button_text_" + char + "_" + this.instance, {
            name: "lua_button_text_" + char + "_" + this.instance,
            hud_elem_type: HudElementType.text,
            scale: create(1,1),
            text: char,
            number: colors.colorHEX(0,0,0),
            position: create(0,0),
            alignment: create(1,1),
            offset: create(
              rootPos.x + 4,
              rootPos.y
            ),
            z_index: 3
          })

          x++
        }
        y++
      }

      // Duplicate raw scopes, why isn't this a function ahhHHHH

      // space bar
      {
        const char = "space"
        let x = 15
        let y = 2
        let spaceWidth = 3
        const rootPos = create(
          this.windowPosition.x + (x * buttonSpacing),
          this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
        )
        
        this.keyboardCbox[char] = new AABB(
          rootPos,
          create(buttonSize * spaceWidth, buttonSize),
          create(0,0)
        )

        this.renderer.addElement("lua_button_bg_" + char + "_" + this.instance, {
          name: "lua_button_bg_" + char + "_" + this.instance,
          hud_elem_type: HudElementType.image,
          position: create(0,0),
          text: "pixel.png^[colorize:" + color(50,50,50) + ":255",
          scale: create(
            buttonSize * spaceWidth,
            buttonSize
          ),
          alignment: create(1,1),
          offset: rootPos,
          z_index: 2
        })

        this.renderer.addElement("lua_button_text_" + char + "_" + this.instance, {
          name: "lua_button_text_" + char + "_" + this.instance,
          hud_elem_type: HudElementType.text,
          scale: create(1,1),
          text: char,
          number: colors.colorHEX(0,0,0),
          position: create(0,0),
          alignment: create(1,1),
          offset: create(
            rootPos.x + 4,
            rootPos.y
          ),
          z_index: 3
        })
      }
      
      // Run bar
      {
        const char = "run"
        let x = 15
        let y = 0
        let spaceWidth = 3
        const rootPos = create(
          this.windowPosition.x + (x * buttonSpacing),
          this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
        )
        
        this.keyboardCbox[char] = new AABB(
          rootPos,
          create(buttonSize * spaceWidth, buttonSize),
          create(0,0)
        )

        this.renderer.addElement("lua_button_bg_" + char + "_" + this.instance, {
          name: "lua_button_bg_" + char + "_" + this.instance,
          hud_elem_type: HudElementType.image,
          position: create(0,0),
          text: "pixel.png^[colorize:" + color(50,50,50) + ":255",
          scale: create(
            buttonSize * spaceWidth,
            buttonSize
          ),
          alignment: create(1,1),
          offset: rootPos,
          z_index: 2
        })

        this.renderer.addElement("lua_button_text_" + char + "_" + this.instance, {
          name: "lua_button_text_" + char + "_" + this.instance,
          hud_elem_type: HudElementType.text,
          scale: create(1,1),
          text: char,
          number: colors.colorHEX(0,0,0),
          position: create(0,0),
          alignment: create(1,1),
          offset: create(
            rootPos.x + 4,
            rootPos.y
          ),
          z_index: 3
        })
      }


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

    destructor(): void {
      
    }

    mouseCollision(): void {
      if (!this.system.isMouseClicked()) return

      // This is bloated and verbose, who cares?
      const buttonSize = 20
      const buttonSpacing = 21
      const mousePos = this.desktop.getMousePos()

      for (const [char,aabb] of Object.entries(this.keyboardCbox)) {
        if (aabb.pointWithin(mousePos)) {
          print(char)
        }
      }
    } 

    main(delta: number): void {
      if (!this.loaded) this.load()

      this.floatError()
      this.mouseCollision()
    }

  }

  DesktopEnvironment.registerProgram(LuaVM)
}