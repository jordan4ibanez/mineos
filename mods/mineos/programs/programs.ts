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

    }
    main(delta: number): void {
      
    }
  }

  loadFiles([
    "programs/boot_loader",
    "programs/os_loader",
    "programs/desktop",
    "programs/bitsBattle",
    "programs/boom"
  ])

  System.out.println("programs loaded!");
}