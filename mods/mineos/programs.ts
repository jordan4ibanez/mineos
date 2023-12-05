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
    main(delta: number): void {
      if (this.timer == 0) {
        print("bios started")
      }
      this.timer += delta
      this.stateTimer += delta

      print("started");

      if (this.stateTimer > 2) {
        if (this.state == 1) {
          this.audioController.playSound("computerBeep", 1.0)
        }

        this.state++;
        this.stateTimer -= 2
      }



      print("bios is running" + this.timer)
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