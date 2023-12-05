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
    constructor(system: System, renderer: Renderer) {
      this.system = system
      this.renderer = renderer
    }
    main(delta: number): void {
      
    }
  }

  programFoundation.biosProcedure = class BiosProcedure extends Program {
    timer = 0
    main(delta: number): void {
      if (this.timer == 0) {
        print("bios started")
      }
      this.timer += delta

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