namespace mineos {
  let currentSystem: System | null = null;

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
      print("current boot: " + this.bootProcess)
    }

    doRun(delta: number): void {
      print("system running.")
    }

    doRender(delta: number): void {
      print("rendering")
    }


    main(delta: number): void {
      if (this.booting) {
        this.doBoot(delta);
      } else {
        this.doRun(delta);
      }
      this.doRender(delta);
    }
  }
}