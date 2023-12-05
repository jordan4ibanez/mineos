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
    renderer = new Renderer();

    constructor() {
      if (currentSystem != null) {
        throw new Error("Cannot create more than one instance of mineos.");
      }
      currentSystem = this
    }

    triggerBoot(): void {
      this.booting = true
      print("loading mineos.")
    }

    doBoot(delta: number): void {
      this.bootProcess += delta
      // print("current boot: " + this.bootProcess)
    }

    doRun(delta: number): void {
      print("system running.")
    }

    sendQuitSignal(): void {
      print("quit signal received.")
      this.quitReceived = true
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

      if (this.booting) {
        this.doBoot(delta);
      } else {
        this.doRun(delta);
      }
      this.doRender(delta);
    }
  }
}