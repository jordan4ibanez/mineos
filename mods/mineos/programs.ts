namespace mineos {

  let programFoundation: {[id: string] : typeof Program} = {}

  // Oh my god it's java in minetest. What have I doneeeeeeeeeee
  // Mocha - Created by Prophet

  export interface ProgramInterface {
    main(delta: number): void;
  }

  export class Program implements ProgramInterface {
    // iMem can be used to make fancy flags.
    iMem = 0
    system: System
    renderer: Renderer
    audioController: AudioController
    constructor(system: System, renderer: Renderer, audioController: AudioController) {
      this.system = system
      this.renderer = renderer
      this.audioController = audioController
    }
    main(delta: number): void {
      
    }
  }

  programFoundation.biosProcedure = class BiosProcedure extends Program {
    timer = 0
    stateTimer = 0
    state = 0
    increments = 0.2
    memoryCounter = 0
    main(delta: number): void {
      if (this.timer == 0) {
        print("bios started")
      }
      this.timer += delta
      this.stateTimer += delta

      if (this.state == 7) {
        this.stateTimer = -1;
        let memCheck = this.renderer.getElement("memCheckProgress") as gui.Label
        print(dump(memCheck))
        this.memoryCounter += 10 + (math.floor(math.random() * 10))
        memCheck.label = tostring(this.memoryCounter) + " KB"
        if (this.memoryCounter >= 4096) {
          memCheck.label = tostring(4096) + " KB"
          this.stateTimer = 10
        }
      }

      if (this.stateTimer > this.increments) {
        switch (this.state) {
          case 5: {
            this.audioController.playSound("computerBeep", 1.0)
            this.renderer.addElement("bioLogo", new gui.Image({
              position: vector.create2d(0.5,0.9),
              size: vector.create2d(2,2),
              texture: "minetest.png"
            }))
            this.renderer.addElement("biosText", new gui.Label({
              position: vector.create2d(3,2),
              label: colorize(colors.color(100, 0, 0), "Minetest Megablocks")
            }))
            break;
          }
          case 6: {
            this.renderer.addElement("memCheck", new gui.Label({
              position: vector.create2d(0.5,5),
              label: colorize(colors.colorScalar(100), "Total Memory:")
            }))
            this.renderer.addElement("memCheckProgress", new gui.Label({
              position: vector.create2d(3.2,5),
              label: colorize(colors.colorScalar(100), "0 KB")
            }))
            break;
          }
        }
        print(this.state)
        this.state++;
        this.stateTimer -= this.increments
      }



      // print("bios is running" + this.timer)
    }
  }

  programFoundation.bootProcedure = class BootProcedure extends Program {
    timer = 0
    color = 0
    main(delta: number): void {      
      this.timer += delta
      if (this.color < 45) {
        this.color += delta
        if (this.color >= 45) {
          this.color = 45
        }
        this.renderer.setClearColor(this.color, this.color, this.color)
      }
    }
  }

  
  minetest.register_on_mods_loaded(() => {
    for (const [name, clazz] of Object.entries(programFoundation)) {
      getSystem().registerProgram(name, clazz)
    }
  })
  export function grabFoundationalPrograms(): {[id: string] : typeof Program} {
    return programFoundation    
  }
}