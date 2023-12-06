namespace mineos {

  let currentSystem: System | null = null;
  let registrationQueue: [string, typeof Program][] = []

  export function getSystem(): System {
    if (currentSystem == null) {
      throw new Error("system is not created.")
    }
    return currentSystem
  }

  class Printer {
    static println(...anything: any): void {
      print(...anything)
    }
    static dump(...anything: any): void {
      print(dump(anything))
    }
  }

  export class System {

    renderer = new Renderer(this);
    audioController = new AudioController(this)
    // Literally a JVM feature LMAO
    static out = Printer

    skipToDesktopHackjob = false

    booting = true
    bootProcess = 0
    running = false
    quitReceived = false


    programs: {[id: string] : typeof Program} = {}

    callbacks: {[id: string]: (fields: any) => void} = {}

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

    registerCallback(name: string, callback: (fields: any) => void): void {
      this.callbacks[name] = callback
    }

    triggerCallbacks(fields: {[id: string] : any}): void {
      for (const [name, thing] of Object.entries(fields)) {
        const pulledCallback = this.callbacks[name]
        if (pulledCallback == null) return
        pulledCallback(thing);
      }
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
      if (this.skipToDesktopHackjob) {
        System.out.println("HACK: SKIPPED BOOT PROCEDURE!")
        this.booting = false
        this.running = true
        this.changeProgram("RunProcedure")
        return
      }
      this.booting = true
      this.running = true
      //! Note: this can be used to fade the hard drive sound when you shut off the computer.
      this.audioController.playSound("caseButton", 1);
      this.audioController.playSoundRepeat("hardDrive", 0.5, 0.2)
      System.out.println("power button pushed.")
      System.out.println("starting computer.")
    }

    clearCallbacks() {
      for (const [name,_] of Object.entries(this.callbacks)) {
        delete this.callbacks[name]
      }
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
          this.finishBoot()
        }
      }
      this.currentProgram?.main(delta)
    }

    finishBoot() {
      this.bootProcess = 2
      this.booting = false
      this.changeProgram("RunProcedure")
    }

    changeProgram(newProgramName: string): void {
      print("this is a program")
      this.currentProgramName = newProgramName
      this.currentProgram = new this.programs[newProgramName](this, this.renderer, this.audioController)
    }

    doRun(delta: number): void {
      // System.out.println("system running.")
      if (this.currentProgram == null) {
        System.out.println("ERROR: NO CURRENT PROGRAM.")
        return
      }
      this.currentProgram.main(delta)
    }

    sendQuitSignal(): void {
      System.out.println("quit signal received.")
      this.quitReceived = true
    }

    updateFrameBuffer(input: LuaMultiReturn<[Vec2, Vec2]>) {
      this.renderer.frameBufferSize = input[0]
      this.renderer.frameBufferScale = input[1]
    }

    doRender(delta: number): void {
      this.renderer.draw()
      // System.out.println("rendering")
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