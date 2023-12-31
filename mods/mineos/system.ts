namespace mineos {

  export type Driver = ObjectRef;

  let currentSystem: System | null = null;
  let registrationQueue: [string, typeof Program][] = []

  export function getSystem(): System {
    if (currentSystem == null) {
      throw new Error("system is not created.")
    }
    return currentSystem
  }
  export function getSystemOrNull(): System | null {
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

    renderer: Renderer;
    audioController = new AudioController(this)
    driver: Driver | null = null

    // Literally a JVM feature LMAO
    static out = Printer

    skipToDesktopHackjob = false

    booting = true
    bootProcess = 0
    running = false
    quitReceived = false
    mouseDelta: Vec2 = vector.create2d(0,0)


    programs: {[id: string] : typeof Program} = {}

    currentProgram: Program | null = null
    currentProgramName = ""
    mousePos = vector.create2d(0,0)
    mouseWasClicked = false
    mouseClicked = false
    mouseDown = false

    constructor(driver: Driver) {
      if (currentSystem != null) {
        throw new Error("Cannot create more than one instance of mineos.");
      }
      currentSystem = this
      this.driver = driver
      this.renderer = new Renderer(this)
      this.receivePrograms()
    }

    getRenderer(): Renderer {
      return this.renderer
    }

    setDriver(driver: Driver) {
      this.driver = driver
    }

    getDriver(): Driver {
      if (this.driver == null) throw new Error("Attempted to get driver before available.")
      return this.driver
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

      if (this.skipToDesktopHackjob) {
        this.finishBoot()
        return
      }

      //! Note: this can be used to fade the hard drive sound when you shut off the computer.
      this.audioController.playSound("caseButton", 1);
      this.audioController.playSoundRepeat("hardDrive", 0.5, 0.2)
      System.out.println("power button pushed.")
      System.out.println("starting computer.")
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
      this.changeProgram("DesktopEnvironment")
    }

    changeProgram(newProgramName: string): void {
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

    updateFrameBuffer(input: LuaMultiReturn<[Vec2, number]>) {
      const size = input[0]!!
      const scale = input[1]!!
      this.renderer.frameBufferSize = vector.create2d(
        size.x / scale,
        size.y / scale
      )
      this.renderer.frameBufferScale = scale
    }

    // GLFW Mouse simulation.
    pollMouse(): void {
      if (this.driver == null) return

      // Mouse "driver"
      
      const precision = 100000

      const trimmedPi = (math.floor(math.pi * precision)) / precision
      const trimmedHorizontal = (math.floor(this.driver.get_look_horizontal() * precision)) / precision

      this.mouseDelta.x = trimmedPi - trimmedHorizontal
      this.mouseDelta.y = this.driver.get_look_vertical()

      this.driver.set_look_horizontal(math.pi)
      this.driver.set_look_vertical(0)

      // Mouse buttons

      const isClick = this.driver.get_player_control().LMB

      this.mouseDown = isClick;

      if (!this.mouseWasClicked && isClick) {
        this.mouseClicked = true
      } else {
        this.mouseClicked = false
      }

      this.mouseWasClicked = isClick
    }

    isMouseClicked() {
      return this.mouseClicked
    }

    isMouseDown() {
      return this.mouseDown
    }

    getMouseDelta(): Vec2 {
      return this.mouseDelta
    }

    requestShutdown(): void {
      minetest.request_shutdown();
    }


    main(delta: number): void {

      if (!this.running) return
      
      //todo: This will do a shutdown process eventually
      if (this.quitReceived) return

      this.audioController.updated = false

      this.updateFrameBuffer(osFrameBufferPoll())

      this.pollMouse()

      if (this.booting) {
        this.doBoot(delta);
      } else {
        this.doRun(delta);
      }
    }
  }
}