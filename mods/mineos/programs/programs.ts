namespace mineos {

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
    // A bolt on so you can do things when it dies.
    destructor() {
      throw new Error("ERROR: destructor not implemented.")
    }
    main(delta: number): void {
      throw new Error("ERROR: main not implemented.")
    }
  }

  loadFiles([
    "programs/bios",
    "programs/os_loader",
    "programs/desktop",
    "programs/bits_battle",
    "programs/boom/boom",
    "programs/gong",
    "programs/lua"
  ])

  System.out.println("programs loaded!");
}