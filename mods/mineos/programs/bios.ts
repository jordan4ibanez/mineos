namespace mineos {

  const create = vector.create2d;

  class BiosProcedure extends Program {
    timer = 0
    stateTimer = 0
    state = 0
    increments = 0.01 // 0.1 for ultra fast boot normal: 0.5
    memoryCounter = 0
    impatience = 10 // 10+ to do ultra fast memcheck normal 1: 

    main(delta: number): void {
      if (this.timer == 0) {
        System.out.println("bios started")
      }
      this.timer += delta
      this.stateTimer += delta

      if (this.stateTimer > this.increments) {
        switch (this.state) {
          case 5: {
            this.audioController.playSound("computerBeep", 1.0)
            this.renderer.addElement("bios_logo", {
              name: "bios_logo",
              hud_elem_type: HudElementType.image,
              position: create(0,0),
              text: "minetest.png",
              scale: create(1/16,1/16),
              alignment: create(1,1),
              offset: create(
                0,
                0,
              ),
              z_index: 1
            })

            this.renderer.addElement("bios_name", {
              name: "bios_name",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: " Minetest\nMegablocks",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(3,3),
              offset: create(
                150,
                20
              ),
              style: 4,
              z_index: 1
            })
            break;
          }

          case 6: {
            this.renderer.addElement("cpu_detection", {
              name: "cpu_detection",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "Detecting CPU...",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                20,
                200
              ),
              style: 4,
              z_index: 1
            })
            break;
          }
          case 8: {
            this.renderer.addElement("cpu_detection_passed", {
              name: "cpu_detection_passed",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "MineRyzen 1300W detected.",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                200,
                200
              ),
              style: 4,
              z_index: 1
            })
            break;
          }

          case 9: {

            this.renderer.addElement("mem_check", {
              name: "mem_check",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "Total Memory:",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                20,
                300
              ),
              style: 4,
              z_index: 1
            })

            this.renderer.addElement("mem_check_progress", {
              name: "mem_check_progress",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "0 KB",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                200,
                300
              ),
              style: 4,
              z_index: 1
            })
            this.stateTimer = 10;
            break;
          }
          case 10: {
            this.stateTimer = 10;
            this.memoryCounter += (10 + (math.floor(math.random() * 10))) * this.impatience

            let mem = tostring(this.memoryCounter) + " KB"

            if (this.memoryCounter >= 4096) {
              mem = tostring(4096) + " KB"
              this.stateTimer = 0
              this.state++;
            }

            this.renderer.setElementComponentValue("mem_check_progress", "text", mem)

            return
          }
          case 11: {
            this.renderer.addElement("block_check", {
              name: "block_check",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "Checking nodes...",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                20,
                400
              ),
              style: 4,
              z_index: 1
            })
            break;
          }
          case 13: {
            this.renderer.addElement("block_check_passed", {
              name: "block_check_passed",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "passed",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                200,
                400
              ),
              style: 4,
              z_index: 1
            })
            break;
          }
          case 15: {
            this.renderer.addElement("all_passed", {
              name: "all_passed",
              hud_elem_type: HudElementType.text,
              scale: create(1,1),
              text: "All system checks passed.",
              number: colors.colorHEX(100,100,100),
              position: create(0,0),
              alignment: create(1,1),
              size: create(1,1),
              offset: create(
                20,
                500
              ),
              style: 4,
              z_index: 1
            })
            break;
          }
          case 16: {
            this.iMem = 1
            this.renderer.removeElement("bios_logo")
            this.renderer.removeElement("bios_name")
            this.renderer.removeElement("cpu_detection")
            this.renderer.removeElement("cpu_detection_passed")
            this.renderer.removeElement("mem_check")
            this.renderer.removeElement("mem_check_progress")
            this.renderer.removeElement("block_check")
            this.renderer.removeElement("block_check_passed")
            this.renderer.removeElement("all_passed")
            this.renderer.clearMemory()
          }
        }
        this.state++;
        this.stateTimer -= this.increments
      }
    }
  }

  System.registerProgram(BiosProcedure)
}