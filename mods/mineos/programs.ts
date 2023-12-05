namespace mineos {

  export interface Program {
    execute(): void;
  }

  export class ProgramBase {
    system: System | null = null
    constructor(system: System) {
      this.system = system
    }
  }

  let programFoundation: {[id: string] : Program} = {}

  
  function injectStates(): {[id: string] : Program} {
    return programFoundation    
  }
}