namespace mineos {

  class BootProcedure extends Program {
    timer = 0
    colorAmount = 0
    color = vector.create(0,0,0)
    impatience = 8  // 3 for ultra fast boot normal: 8
    hit = false
    colorFadeMultiplier = 0.75
    dots = 0
    dotsAccum = 0
    main(delta: number): void {
      if (this.timer == 0) {
      }
      this.timer += delta

      if (this.timer > this.impatience) {
        this.iMem = 1
        return
      }

      if (this.colorAmount < 1) {
        this.colorAmount += (delta * this.colorFadeMultiplier)

        if (this.colorAmount >= 1) {
          this.colorAmount = 1
        }
        this.renderer.setClearColor((91.7 / 4) * this.colorAmount, (90.5 / 4) * this.colorAmount, (88.0 / 4) * this.colorAmount)
      } else {
        if (!this.hit) {
          this.hit = true
          System.out.println("added logo")
          // const centerX = (this.renderer.frameBufferScale.x / 2)
          // this.renderer.addElement("mineosLogo", new gui.Image({
          //   position: vector.create2d(centerX - 4,0.9),
          //   size: vector.create2d(8,8),
          //   texture: "minetest.png"
          // }))
          // this.renderer.addElement("mineosLoading", new gui.Label({
          //   position: vector.create2d(centerX - 1.7,10),
          //   label: colorize(colors.colorScalar(100), "loading mineos")
          // }))
        } else {
          // let loadingThing = this.renderer.getElement("mineosLoading") as gui.Label
          // this.dotsAccum += delta
          // if (this.dotsAccum >= 0.25) {
          //   this.dots ++
          //   if (this.dots > 3) {
          //     this.dots = 0
          //   }
          //   this.dotsAccum -= 0.25
          // }
          // let textAccum = "loading mineos"
          // for (let i = 0; i < this.dots; i++) {
          //   textAccum += "."
          // }
          // loadingThing.label = textAccum
        }
      }
    }
  }

  System.registerProgram(BootProcedure)
}