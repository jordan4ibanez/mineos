namespace mineos {

  const create = vector.create;
  const color = colors.color;


  let focusedInstance: LuaVM | null = null
  // This won't work with multiple instances. Oh well!
  // Hijack the print function >:D
  function print(thing: string) {
    if (focusedInstance == null) throw new Error("OOPS")
    // There's no way this can cause errors, impossible!
    try {
      focusedInstance.pushOutput("\n" + thing)
    } catch (e) {
      System.out.println("You done goofed up boi!" + e)
    }
  }

  // If you enter into a loop, you're gonna freeze the program WOOO.
  class LuaVM extends WindowProgram {

    loaded = false
    instance = 0
    static nextInstance = 0
    readonly programLineLimit = 10
    myCoolProgram = `print("Hello, world!")`
    version = 5.1000000000000

    // This is the worst keyboard made by human beings.
    // And probably aliens.
    readonly keyboard = `
    1234567890_^#$
    abcdefghijklmn
    opqrstuvwxyz{}
    ="'.,()\\/-+~*!
    `.trim()

    programOutput = ""

    keyboardCbox: {[id: string]: AABB} = {}

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {
      windowSize.x = 500
      windowSize.y = 500
      super(system, renderer, audio, desktop, windowSize)

      focusedInstance = this
    }

    updateIDEText(): void {
      this.renderer.setElementComponentValue("lua_program_text_" + this.instance, "text", this.myCoolProgram)
    }

    updateOutputText(): void {
      this.renderer.setElementComponentValue("program_output_text_" + this.instance, "text", this.programOutput)
    }

    charInput(char: string): void {
      if (char.length > 1) throw new Error("How did this even happen?")
      // Don't allow the user to go past 3 lines.
      this.myCoolProgram = (this.myCoolProgram + char).split("\n", this.programLineLimit).join("\n")
      this.updateIDEText()
    }

    charDelete(): void {
      this.myCoolProgram = this.myCoolProgram.slice(0, -1)
      this.updateIDEText()
    }

    execute(): void {
      let [_, err] = pcall(() => {

        // This isn't dangerous at all wooOOO
        const OLD_PRINT = _G.print;
        _G.print = print;

        // Let's just pretend that second return doesn't exist
        let [func, err] = loadstring(this.myCoolProgram, 'LuaVM', 't', _G)

        // Run the code or print an error.
        if (typeof(func) == "function") {
          let callable = func as (() => any)
          callable()
        } else {
          print(tostring(err))
        }

        _G.print = OLD_PRINT;
      })
      if (err) {
        this.pushOutput(err)
      }
    }

    pushOutput(input: string): void {
      // System.out.println(input)
      const array = (this.programOutput + input).split("\n")
      const overshoot = array.length - this.programLineLimit
      const startIndex = (overshoot > 0) ? overshoot : 0
      this.programOutput = array.slice(startIndex, array.length).join("\n")
      this.updateOutputText()
    }

    load(): void {

      this.instance = LuaVM.nextInstance
      LuaVM.nextInstance++

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

      this.renderer.addElement("program_output_area_" + this.instance, {
        name: "program_output_area_" + this.instance,
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
          this.getPosY() + (this.windowSize.y / 2.5) + border,
        ),
        z_index: 2
      })

      this.renderer.addElement("program_output_text_" + this.instance, {
        name: "program_output_text_" + this.instance,
          hud_elem_type: HudElementType.text,
          scale: create(1,1),
          text: this.programOutput,
          number: colors.colorHEX(0,0,0),
          position: create(0,0),
          alignment: create(1,1),
          offset: create(
            this.getPosX() + border,
            this.getPosY() + (this.windowSize.y / 2.5) + border,
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
            this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + ((y - 1) * buttonSpacing)
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
            this.windowPosition.y + this.windowSize.y - (buttonSpacing * 3) + ((y - 1) * buttonSpacing)
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

      this.renderer.setElementComponentValue("lua_program_text_" + this.instance, "offset", create(
        this.getPosX() + border,
        this.getPosY() + border,
      ))

      this.renderer.setElementComponentValue("program_output_area_" + this.instance, "offset", create(
        this.getPosX() + border,
        this.getPosY() + (this.windowSize.y / 2.5) + border,
      ))

      this.renderer.setElementComponentValue("program_output_text_" + this.instance, "offset", create(
        this.getPosX() + border,
        this.getPosY() + (this.windowSize.y / 2.5) + border,
      ))

    }

    destructor(): void {
      // const r = this.renderer.removeElement;

      this.renderer.removeElement("lua_bg_" + this.instance)
      this.renderer.removeElement("lua_text_area_" + this.instance)
      this.renderer.removeElement("lua_program_text_" + this.instance)
      this.renderer.removeElement("program_output_area_" + this.instance)
      this.renderer.removeElement("program_output_text_" + this.instance)
      
      for (const charArray of this.keyboard.split("\n")) {
        for (const char of charArray.toString().trim()) {
          this.renderer.removeElement("lua_button_bg_" + char + "_" + this.instance)
          this.renderer.removeElement("lua_button_text_" + char + "_" + this.instance)
        }
      }
      for (const char of ["return", "backspace", "run", "space"]) {
        this.renderer.removeElement("lua_button_bg_" + char + "_" + this.instance)
        this.renderer.removeElement("lua_button_text_" + char + "_" + this.instance)
      }
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
          this.execute()
          break
        default:
          if (gottenChar) this.charInput(gottenChar)
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