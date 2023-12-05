namespace mineos {
  let currentSystem: System | null = null;

  export function getSystem(): System {
    if (currentSystem == null) {
      throw new Error("system is not created.")
    }
    return currentSystem
  }

  export class System {

    booting = false
    bootProcess = 0
    running = false
    quitReceived = false
    renderer = new Renderer(this);

    programs: {[id: string] : typeof Program} = {}
    currentProgram: Program | null = null
    currentProgramName = ""
    mousePos = vector.create2d(0,0)

    constructor() {
      if (currentSystem != null) {
        throw new Error("Cannot create more than one instance of mineos.");
      }
      currentSystem = this
      this.triggerBoot();
    }

    registerProgram(name: string, program: typeof Program): void {
      this.programs[name] = program            
    }

    triggerBoot(): void {
      this.booting = true
      print("loading mineos.")
    }

    doBoot(delta: number): void {
      if (this.currentProgramName != "biosProcedure") {
        this.changeProgram("biosProcedure")
      }
      this.currentProgram?.main(delta)
    }

    changeProgram(newProgramName: string): void {
      this.currentProgramName = newProgramName
      this.currentProgram = new this.programs[newProgramName](this, this.renderer)
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