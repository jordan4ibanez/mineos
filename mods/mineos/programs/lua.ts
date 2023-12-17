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
    readonly programLineLimit = 10
    myCoolProgram = ""
    version = 5.1000000000000

    // This is the worst keyboard made by human beings.
    // And probably aliens.
    readonly keyboard = `
    abcdefghijklmn
    opqrstuvwxyz{}
    ="'.,()\\/-+~*!
    `.trim()

    keyboardCbox: {[id: string]: AABB} = {}

    updateIDEText(): void {
      print(this.myCoolProgram)
      this.renderer.setElementComponentValue("lua_program_text_" + this.instance, "text", this.myCoolProgram)
    }

    charInput(char: string): void {
      if (char.length > 1) throw new Error("How did this even happen?")
      // Don't allow the user to go past 3 lines.
      this.myCoolProgram = (this.myCoolProgram + char).trim().split("\n", this.programLineLimit).join()
      this.updateIDEText()
    }

    charDelete(): void {
      this.myCoolProgram = this.myCoolProgram.slice(0, -1)
      this.updateIDEText()
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

      const border = 4

      this.renderer.addElement("lua_text_area_" + this.instance, {
        name: "lua_text_area_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(60,60,60) + ":255",
        scale: create(
          this.windowSize.x - (border * 2),
          (this.windowSize.y / 2.5) - border
        ),
        alignment: create(1,1),
        offset: create(
          this.getPosX() + border,
          this.getPosY() + border,
        ),
        z_index: 2
      })

      this.renderer.addElement("lua_program_text_" + this.instance, {
        name: "lua_program_text_" + this.instance,
          hud_elem_type: HudElementType.text,
          scale: create(1,1),
          text: this.myCoolProgram,
          number: colors.colorHEX(0,0,0),
          position: create(0,0),
          alignment: create(1,1),
          offset: create(
            this.getPosX() + border,
            this.getPosY() + border,
          ),
          z_index: 3
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

      // Return bar
      {
        const char = "return"
        let x = 15
        let y = 1
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

      // Backspace bar
      {
        const char = "backspace"
        let x = 18
        let y = 0
        let spaceWidth = 5
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
      // This is very lazy
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

          this.renderer.setElementComponentValue("lua_button_bg_" + char + "_" + this.instance, "offset", rootPos)
          this.renderer.setElementComponentValue("lua_button_text_" + char + "_" + this.instance, "offset", create(
            rootPos.x + 4,
            rootPos.y
          ))

          this.keyboardCbox[char].offset = rootPos

          x++
        }
        y++
      }

      {
        const char = "space"
        let x = 15
        let y = 2
        const rootPos = create(
          this.windowPosition.x + (x * buttonSpacing),
          this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
        )

        this.renderer.setElementComponentValue("lua_button_bg_" + char + "_" + this.instance, "offset", rootPos)
        this.renderer.setElementComponentValue("lua_button_text_" + char + "_" + this.instance, "offset", create(
          rootPos.x + 4,
          rootPos.y
        ))

        this.keyboardCbox[char].offset = rootPos
      }

      {
        const char = "return"
        let x = 15
        let y = 1
        const rootPos = create(
          this.windowPosition.x + (x * buttonSpacing),
          this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
        )

        this.renderer.setElementComponentValue("lua_button_bg_" + char + "_" + this.instance, "offset", rootPos)
        this.renderer.setElementComponentValue("lua_button_text_" + char + "_" + this.instance, "offset", create(
          rootPos.x + 4,
          rootPos.y
        ))

        this.keyboardCbox[char].offset = rootPos
      }

      {
        const char = "run"
        let x = 15
        let y = 0
        const rootPos = create(
          this.windowPosition.x + (x * buttonSpacing),
          this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
        )

        this.renderer.setElementComponentValue("lua_button_bg_" + char + "_" + this.instance, "offset", rootPos)
        this.renderer.setElementComponentValue("lua_button_text_" + char + "_" + this.instance, "offset", create(
          rootPos.x + 4,
          rootPos.y
        ))

        this.keyboardCbox[char].offset = rootPos
      }

      {
        const char = "backspace"
        let x = 18
        let y = 0
        const rootPos = create(
          this.windowPosition.x + (x * buttonSpacing),
          this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + (y * buttonSpacing)
        )

        this.renderer.setElementComponentValue("lua_button_bg_" + char + "_" + this.instance, "offset", rootPos)
        this.renderer.setElementComponentValue("lua_button_text_" + char + "_" + this.instance, "offset", create(
          rootPos.x + 4,
          rootPos.y
        ))

        this.keyboardCbox[char].offset = rootPos
      }

      const border = 4

      this.renderer.setElementComponentValue("lua_text_area_" + this.instance, "offset", create(
        this.getPosX() + border,
          this.getPosY() + border,
      ))

    }

    destructor(): void {
      
    }

    mouseCollision(): void {
      if (!this.system.isMouseClicked()) return

      // This is bloated and verbose, who cares?
      const buttonSize = 20
      const buttonSpacing = 21
      const mousePos = this.desktop.getMousePos()

      let gottenChar: string | null = null
      for (const [char,aabb] of Object.entries(this.keyboardCbox)) {
        if (aabb.pointWithin(mousePos)) {
          print(char)
          gottenChar = char
          break
        }
      }

      switch (gottenChar) {
        case "return":
          this.charInput("\n")
          break
        case "space":
          this.charInput(" ")
          break
        case "backspace":
          this.charDelete()
          break
        case "run":
          print("run program")
          break
        default: {
          if (gottenChar) this.charInput(gottenChar)
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