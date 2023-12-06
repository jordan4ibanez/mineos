namespace mineos {

  let currentSystem: System | null = null;
  let registrationQueue: [string, typeof Program][] = []

  export function getSystem(): System {
    if (currentSystem == null) {
      throw new Error("system is not created.")
    }
    return currentSystem
  }

  export class System {

    renderer = new Renderer(this);
    audioController = new AudioController(this)

    skipToDesktopHackjob = false

    booting = !this.skipToDesktopHackjob
    bootProcess = 0
    running = false
    quitReceived = false


    programs: {[id: string] : typeof Program} = {}
    currentProgram: Program | null = null
    currentProgramName = ""
    mousePos = vector.create2d(0,0)

    constructor() {
      if (currentSystem != null) {
        throw new Error("Cannot create more than one instance of mineos.");
      }
      currentSystem = this
      this.receivePrograms()
    }

    getRenderer(): Renderer {
      return this.renderer
    }

    getAudioController(): AudioController {
      return this.audioController
    }

    isKeyDown(keyName: string) {
      return osKeyboardPoll(keyName)
    }

    receivePrograms() {
      while (registrationQueue.length > 0) {
        const [name, prog] = registrationQueue.pop()!!
        this.programs[name] = prog
      }
    }

    static registerProgram(program: typeof Program): void {
      const progName = program.prototype.constructor.name;
      if (currentSystem == null) {
        registrationQueue.push([progName, program])
      } else {
        currentSystem.programs[progName] = program
      }
    }

    triggerBoot(): void {
      this.booting = true
      this.running = true
      //! Note: this can be used to fade the hard drive sound when you shut off the computer.
      this.audioController.playSound("caseButton", 1);
      this.audioController.playSound("hardDrive", 0.5, 0.2)
      print("power button pushed.")
      print("starting computer.")

    }

    doBoot(delta: number): void {
      if (this.bootProcess == 0) {
        if (this.currentProgramName != "BiosProcedure") {
          this.changeProgram("BiosProcedure")
        }
        if (this.currentProgram?.iMem == 1) {
          this.changeProgram("BootProcedure")
          this.bootProcess++
        }
      } else if (this.bootProcess == 1){
        if (this.currentProgramName != "BootProcedure") {
          this.changeProgram("BootProcedure")
        }
        if (this.currentProgram?.iMem == 1) {
          this.changeProgram("RunProcedure")
        }
      }
      this.currentProgram?.main(delta)
    }

    changeProgram(newProgramName: string): void {
      this.currentProgramName = newProgramName
      this.currentProgram = new this.programs[newProgramName](this, this.renderer, this.audioController)
    }

    doRun(delta: number): void {
      print("system running.")
    }

    sendQuitSignal(): void {
      print("quit signal received.")
      this.quitReceived = true
    }

    updateFrameBuffer(input: LuaMultiReturn<[Vec2, Vec2]>) {
      this.renderer.frameBufferSize = input[0]
      this.renderer.frameBufferScale = input[1]
    }

    doRender(delta: number): void {
      this.renderer.draw()
      // print("rendering")
    }

    getFrameBuffer(): string {
      return this.renderer.buffer
    }


    main(delta: number): void {

      if (!this.running) return
      
      //todo: This will do a shutdown process eventually
      if (this.quitReceived) return

      this.updateFrameBuffer(osFrameBufferPoll())
      if (this.booting) {
        this.doBoot(delta);
      } else {
        this.doRun(delta);
      }
      this.doRender(delta);
    }
  }
}