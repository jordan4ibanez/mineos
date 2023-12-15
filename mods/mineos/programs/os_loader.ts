namespace mineos {

  const create = vector.create2d;

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

      this.timer += delta

      this.renderer.update()

      if (this.timer > this.impatience) {
        this.renderer.removeElement("boot_logo")
        this.renderer.removeElement("loading_mineos")
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
          this.renderer.addElement("boot_logo", {
            name: "boot_logo",
            hud_elem_type: HudElementType.image,
            position: create(0,0),
            text: "minetest.png",
            scale: create(512/1920,512/1920),
            alignment: create(1,1),
            offset: create(
              (this.renderer.frameBufferSize.x / 2) - (512/2),
              0,
            ),
            z_index: 1
          })

          this.renderer.addElement("loading_mineos", {
            name: "loading_mineos",
            hud_elem_type: HudElementType.text,
            scale: create(1,1),
            text: "Loading mineos",
            number: colors.colorHEX(100,100,100),
            position: create(0,0),
            alignment: create(1,1),
            size: create(3,3),
            offset: create(
              (this.renderer.frameBufferSize.x / 2) - 240,
              600
            ),
            style: 4,
            z_index: 1
          })
        } else {

          
          this.dotsAccum += delta
          if (this.dotsAccum >= 0.25) {
            this.dots ++
            if (this.dots > 3) {
              this.dots = 0
            }
            this.dotsAccum -= 0.25
          }
          let textAccum = "loading mineos"
          for (let i = 0; i < this.dots; i++) {
            textAccum += "."
          }

          this.renderer.setElementComponentValue("loading_mineos", "text", textAccum)
        }
      }
    }
  }

  System.registerProgram(BootProcedure)
}