namespace mineos {
  const create = vector.create;
  const create2d = vector.create2d;
  const color = colors.color;
  const colorRGB = colors.colorRGB;
  const colorScalar = colors.colorScalar;

  class RunProcedure extends Program {

    desktopLoaded = false

    loadDesktop(): void {
      System.out.println("loading desktop environment")

      this.renderer.addElement("background", new gui.Box({
        position: create2d(0,0),
        size: create2d(4000, 15.6),
        color: colorRGB(1,130,129)
      }))
      
      this.renderer.addElement("menuBar", new gui.Box({
        position: create2d(0,this.renderer.frameBufferScale.y * 15.6),
        size: create2d(4000,1),
        color: colorScalar(70)
      }))

      this.renderer.addElement("startButton", new gui.Button({
        position: create2d(0,15.6),
        size: create2d(2,0.8),
        name: "startButton",
        label: "Start"
      }))


      this.desktopLoaded = true
      System.out.println("desktop environment loaded")
    }

    main(delta: number): void {
      if (!this.desktopLoaded) this.loadDesktop()

    }
  }

  System.registerProgram(RunProcedure)
}