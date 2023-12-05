namespace mineos {

  let programFoundation: {[id: string] : typeof Program} = {}

  // Oh my god it's java in minetest. What have I doneeeeeeeeeee
  // Mocha - Created by Prophet

  export interface ProgramInterface {
    main(delta: number): void;
  }

  export class Program implements ProgramInterface {
    system: System
    renderer: Renderer
    constructor(system: System, renderer: Renderer) {
      this.system = system
      this.renderer = renderer
    }
    main(delta: number): void {
      
    }
  }

  programFoundation.bootProcedure = class BootProcedure extends Program {
    memoryTest = 0
    main(delta: number): void {      
      this.memoryTest += delta
      print("booting! " + this.memoryTest)
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