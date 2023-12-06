namespace mineos {
  class RunProcedure extends Program {

    loadedDesktop = false

    loadDesktop(): void {
      System.out.println("loading desktop environment")
      System.out.println("hi there", "I'm java")

      System.out.println("desktop environment loaded")
    }

    main(delta: number): void {
      if (!this.loadedDesktop) {
        this.loadDesktop()
      }

    }
  }

  System.registerProgram(RunProcedure)
}