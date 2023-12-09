namespace mineos {
  class Boom extends WindowProgram {

    currentPixelCount = 0

    clear(): void {
      for (let i = 0; i < this.currentPixelCount; i++) {
        this.renderer.removeElement("boompixel" + i)
      }
    }

    render(): void {
      this.clear()

    }

    main(delta: number): void {
      print("BOOM BABY")
    }

  }
  DesktopEnvironment.registerProgram(Boom)
}