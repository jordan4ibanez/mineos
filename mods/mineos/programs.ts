namespace mineos {

  // Oh my god it's java in minetest. What have I doneeeeeeeeeee
  // Mocha - Created by Prophet

  export interface ProgramInterface {
    main(delta: number): void;
  }

  export class Program implements ProgramInterface {
    // iMem can be used to make fancy flags.
    iMem = 0
    system: System
    renderer: Renderer
    audioController: AudioController
    constructor(system: System, renderer: Renderer, audioController: AudioController) {
      this.system = system
      this.renderer = renderer
      this.audioController = audioController
    }
    main(delta: number): void {
      
    }
  }


  class BiosProcedure extends Program {
    timer = 0
    stateTimer = 0
    state = 0
    increments = 0.5 // 0.1 for ultra fast boot normal: 0.5
    memoryCounter = 0
    impatience = 1 // 10+ to do ultra fast memcheck normal 1: 
    main(delta: number): void {
      if (this.timer == 0) {
        print("bios started")
      }
      this.timer += delta
      this.stateTimer += delta
      


      if (this.stateTimer > this.increments) {
        switch (this.state) {
          case 5: {
            this.audioController.playSound("computerBeep", 1.0)
            this.renderer.addElement("bioLogo", new gui.Image({
              position: vector.create2d(0.5,0.9),
              size: vector.create2d(2,2),
              texture: "minetest.png"
            }))
            this.renderer.addElement("biosText", new gui.Label({
              position: vector.create2d(3,2),
              label: colorize(colors.color(100, 0, 0), "Minetest Megablocks")
            }))
            break;
          }

          case 6: {
            this.renderer.addElement("cpuDetection", new gui.Label({
              position: vector.create2d(0.5,5),
              label: colorize(colors.colorScalar(100), "Detecting cpu...")
            }))
            break;
          }
          case 8: {
            this.renderer.addElement("cpuDetectionPass", new gui.Label({
              position: vector.create2d(3.5,5),
              label: colorize(colors.colorScalar(100), "MineRyzen 1300W detected.")
            }))
            break;
          }

          case 9: {
            this.renderer.addElement("memCheck", new gui.Label({
              position: vector.create2d(0.5,7),
              label: colorize(colors.colorScalar(100), "Total Memory:")
            }))
            this.renderer.addElement("memCheckProgress", new gui.Label({
              position: vector.create2d(3.2,7),
              label: colorize(colors.colorScalar(100), "0 KB")
            }))
            this.stateTimer = 10;
            break;
          }
          case 10: {
            this.stateTimer = 10;
            let memCheck = this.renderer.getElement("memCheckProgress") as gui.Label
            this.memoryCounter += (10 + (math.floor(math.random() * 10))) * this.impatience
            memCheck.label = tostring(this.memoryCounter) + " KB"

            if (this.memoryCounter >= 4096) {
              memCheck.label = tostring(4096) + " KB"
              this.stateTimer = 0
              this.state++;
            }
            return
          }
          case 11: {
            this.renderer.addElement("blockCheck", new gui.Label({
              position: vector.create2d(0.5,9),
              label: colorize(colors.colorScalar(100), "Checking nodes...")
            }))
            break;
          }
          case 13: {
            this.renderer.addElement("blockCheckPassed", new gui.Label({
              position: vector.create2d(3.9,9),
              label: colorize(colors.colorScalar(100), "passed.")
            }))
            break;
          }
          case 15: {
            this.renderer.addElement("allPassed", new gui.Label({
              position: vector.create2d(0.5,11),
              label: colorize(colors.colorScalar(100), "All system checks passed.")
            }))
            break;
          }
          case 16: {
            this.iMem = 1
            this.renderer.clearMemory()
          }
        }
        this.state++;
        this.stateTimer -= this.increments
      }
    }
  }

  System.registerProgram(BiosProcedure)

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
        this.renderer.clearMemory()
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
          print("added logo")
          const centerX = (this.renderer.frameBufferScale.x / 2)
          this.renderer.addElement("mineosLogo", new gui.Image({
            position: vector.create2d(centerX - 4,0.9),
            size: vector.create2d(8,8),
            texture: "minetest.png"
          }))
          this.renderer.addElement("mineosLoading", new gui.Label({
            position: vector.create2d(centerX - 1.7,10),
            label: colorize(colors.colorScalar(100), "loading mineos")
          }))
        } else {
          let loadingThing = this.renderer.getElement("mineosLoading") as gui.Label
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
          loadingThing.label = textAccum
        }
      }
    }
  }

  System.registerProgram(BootProcedure)

  class RunProcedure extends Program {
    loadedDesktop = false

    loadDesktop(): void {

    }

    main(delta: number): void {
      if (!this.loadedDesktop) {
        this.loadDesktop()
      }

      print("main loop blah blah blah")
    }
  }

  System.registerProgram(RunProcedure)

  print("programs loaded!");
}