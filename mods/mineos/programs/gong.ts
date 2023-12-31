namespace mineos {
  // It's not Pong it's Gong!
  // Probably the simplest game
  const create = vector.create2d;
  const create3d = vector.create;
  const yaw_to_dir = minetest.yaw_to_dir;

  const PIXEL_SIZE = 16
  function getPixel(dimension: number): number {
    return dimension * PIXEL_SIZE
  }

  function randomDir(): Vec2 {
    const dir3d = yaw_to_dir(math.random() * (math.pi * 2))
    return create(
      dir3d.x,
      dir3d.z
    )    
  }

  const MOVEMENT_MULTIPLIER = 500

  class Gong extends WindowProgram {

    loaded = false

    instance: number

    static currentInstance = 0

    scorePlayer = 0
    scoreEnemy = 0

    ball = new AABB(
      create(0,0),
      create(getPixel(1),getPixel(1)),
      create(0,0)
    )

    ballVelocity = randomDir()

    playerPaddle = new AABB(
      create(0,0),
      create(getPixel(1),getPixel(4)),
      create(0,0)
    )

    // This var name is quite ominous
    enemyPaddle = new AABB(
      create(0,0),
      create(getPixel(1),getPixel(4)),
      create(0,0)
    )

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, size: Vec2) {
      super(system, renderer, audio, desktop, size);
      this.instance = Gong.currentInstance
      Gong.currentInstance++
    }

    getPlayerPaddlePos(): Vec2 {
      return create(
        this.playerPaddle.offset.x + this.windowPosition.x,
        this.playerPaddle.offset.y + this.windowPosition.y
      )
    }

    getEnemyPaddlePos(): Vec2 {
      return create(
        this.enemyPaddle.offset.x + this.windowPosition.x,
        this.enemyPaddle.offset.y + this.windowPosition.y
      )
    }

    getBallPos(): Vec2 {
      return create(
        this.ball.offset.x + this.windowPosition.x,
        this.ball.offset.y + this.windowPosition.y
      )
    }

    load(): void {

      // Center the elements
      this.ball.offset.x = (this.windowSize.x / 2) - (this.ball.size.x / 2)
      this.ball.offset.y = (this.windowSize.y / 2) - (this.ball.size.y / 2)

      this.playerPaddle.offset.y = (this.windowSize.y / 2) - (this.playerPaddle.size.y / 2)

      this.enemyPaddle.offset.x = this.windowSize.x - this.enemyPaddle.size.x
      this.enemyPaddle.offset.y = (this.windowSize.y / 2) - (this.enemyPaddle.size.y / 2)




      this.renderer.addElement("gong_bg_" + this.instance, {
        name: "gong_bg_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(0,0,0) + ":255",
        scale: this.windowSize,
        alignment: create(1,1),
        offset: create(
          this.getPosX(),
          this.getPosY(),
        ),
        z_index: 1
      })

      this.renderer.addElement("gong_player_paddle_" + this.instance, {
        name: "gong_player_paddle_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(100,100,100) + ":255",
        scale: this.playerPaddle.size,
        alignment: create(1,1),
        offset: this.getPlayerPaddlePos(),
        z_index: 2
      })

      this.renderer.addElement("gong_enemy_paddle_" + this.instance, {
        name: "gong_enemy_paddle_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(100,100,100) + ":255",
        scale: this.playerPaddle.size,
        alignment: create(1,1),
        offset: this.getEnemyPaddlePos(),
        z_index: 2
      })

      this.renderer.addElement("gong_ball_" + this.instance, {
        name: "gong_ball_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(100,100,100) + ":255",
        scale: this.ball.size,
        alignment: create(1,1),
        offset: this.getPlayerPaddlePos(),
        z_index: 2
      })


      this.renderer.addElement("gong_separator_" + this.instance, {
        name: "gong_separator_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(100,100,100) + ":255",
        scale: create(
          PIXEL_SIZE / 2,
          this.windowSize.y
        ),
        alignment: create(1,1),
        offset: create(
          this.windowPosition.x + (this.windowSize.x / 2) - (PIXEL_SIZE / 4),
          this.windowPosition.y
        ),
        z_index: 2
      })

      this.renderer.addElement("gong_player_score_" + this.instance, {
        name: "gong_player_score_" + this.instance,
        hud_elem_type: HudElementType.text,
        scale: create(1,1),
        text: this.scorePlayer.toString(),
        number: colors.colorHEX(100,100,100),
        position: create(0,0),
        alignment: create(0,1),
        offset: create(
          this.windowPosition.x + (this.windowSize.x / 2) - getPixel(2),
          this.windowPosition.y + getPixel(1)
        ),
        // style: 4,
        z_index: 3
      })

      this.renderer.addElement("gong_enemy_score_" + this.instance, {
        name: "gong_enemy_score_" + this.instance,
        hud_elem_type: HudElementType.text,
        scale: create(1,1),
        text: tostring(this.scoreEnemy),
        number: colors.colorHEX(100,100,100),
        position: create(0,0),
        alignment: create(0,1),
        offset: create(
          this.windowPosition.x + (this.windowSize.x / 2) + getPixel(2),
          this.windowPosition.y + getPixel(1)
        ),
        // style: 4,
        z_index: 3
      })


      this.setWindowTitle("Gong")

      print("Gong loaded!")
      this.loaded = true
    }

    move(): void {
      this.renderer.setElementComponentValue("gong_bg_" + this.instance, "offset", this.windowPosition)
      this.renderer.setElementComponentValue("gong_player_paddle_" + this.instance, "offset", this.getPlayerPaddlePos())
      this.renderer.setElementComponentValue("gong_enemy_paddle_" + this.instance, "offset", this.getEnemyPaddlePos())
      this.renderer.setElementComponentValue("gong_ball_" + this.instance, "offset", this.getBallPos())
      this.renderer.setElementComponentValue("gong_player_score_" + this.instance, "offset", create(
        this.windowPosition.x + (this.windowSize.x / 2) - getPixel(2),
        this.windowPosition.y + getPixel(1)
      ))

      this.renderer.setElementComponentValue("gong_enemy_score_" + this.instance, "offset", create(
        this.windowPosition.x + (this.windowSize.x / 2) + getPixel(2),
          this.windowPosition.y + getPixel(1)
      ))

      this.renderer.setElementComponentValue("gong_separator_" + this.instance, "offset", create(
        this.windowPosition.x + (this.windowSize.x / 2) - (PIXEL_SIZE / 4),
        this.windowPosition.y
      ))
    }

    destructor(): void {
      this.renderer.removeElement("gong_player_paddle_" + this.instance)
      this.renderer.removeElement("gong_enemy_paddle_" + this.instance)
      this.renderer.removeElement("gong_ball_" + this.instance)
      this.renderer.removeElement("gong_player_score_" + this.instance)
      this.renderer.removeElement("gong_enemy_score_" + this.instance)
      this.renderer.removeElement("gong_separator_" + this.instance)
      this.renderer.removeElement("gong_bg_" + this.instance)
    }

    updateScene(): void {
      this.renderer.setElementComponentValue("gong_player_paddle_" + this.instance, "offset", this.getPlayerPaddlePos())
      this.renderer.setElementComponentValue("gong_enemy_paddle_" + this.instance, "offset", this.getEnemyPaddlePos())
      this.renderer.setElementComponentValue("gong_ball_" + this.instance, "offset", this.getBallPos())
      this.renderer.setElementComponentValue("gong_player_score_" + this.instance, "text", tostring(this.scorePlayer))
      this.renderer.setElementComponentValue("gong_enemy_score_" + this.instance, "text", tostring(this.scoreEnemy))
    }

    playerControls(delta: number): void {
      const up = this.system.isKeyDown("up")
      const down = this.system.isKeyDown("down")
      if (up) {
        this.playerPaddle.offset.y -= delta * MOVEMENT_MULTIPLIER
        if (this.playerPaddle.offset.y <= 0) {
          this.playerPaddle.offset.y = 0
        }
      } else if (down) {
        this.playerPaddle.offset.y += delta * MOVEMENT_MULTIPLIER
        if (this.playerPaddle.offset.y >= this.windowSize.y - this.playerPaddle.size.y) {
          this.playerPaddle.offset.y = this.windowSize.y - this.playerPaddle.size.y
        }
      }
    }

    enemyLogic(delta: number): void {
      const ballCenterY = this.ball.offset.y + (this.ball.size.y / 2)
      const paddleCenterY = this.enemyPaddle.offset.y + (this.enemyPaddle.size.y / 2) 
      const compare = ballCenterY - paddleCenterY

      // Anything less than this and the game becomes impossible
      const easiness = 1.5

      const diffGoal = PIXEL_SIZE

      if (math.abs(compare) < diffGoal) return

      if (compare < diffGoal) {
        this.enemyPaddle.offset.y -= delta * (MOVEMENT_MULTIPLIER / easiness)
        if (this.enemyPaddle.offset.y <= 0) {
          this.enemyPaddle.offset.y = 0
        }
      } else if (compare > diffGoal) {
        this.enemyPaddle.offset.y += delta * (MOVEMENT_MULTIPLIER / easiness)
        if (this.enemyPaddle.offset.y >= this.windowSize.y - this.enemyPaddle.size.y) {
          this.enemyPaddle.offset.y = this.windowSize.y - this.enemyPaddle.size.y
        }
      }
    }

    playWall(): void {
      this.audioController.playSound("gong_wall", 1)
    }
    playScore(): void {
      this.audioController.playSound("gong_score", 1)
    }

    ballLogic(delta: number): void {
      const ballNewPos = create(
        this.ball.offset.x += this.ballVelocity.x * delta * MOVEMENT_MULTIPLIER,
        this.ball.offset.y += this.ballVelocity.y * delta * MOVEMENT_MULTIPLIER
      )

      // Very cheap collision detection
      { // ? player
        const ballCenterY = this.ball.offset.y + (this.ball.size.y / 2)

        const paddleCenterY = this.playerPaddle.offset.y + (this.playerPaddle.size.y / 2)
        
        const upperLeftPoint = create(
          this.ball.offset.x,
          this.ball.offset.y
        )

        const lowerLeftPoint = create(
          this.ball.offset.x,
          this.ball.offset.y + this.ball.size.y
        )

        if (this.playerPaddle.pointWithin(upperLeftPoint) || this.playerPaddle.pointWithin(lowerLeftPoint)) {
          ballNewPos.x = this.playerPaddle.offset.x + this.playerPaddle.size.x

          // This is surprisingly accurate.
          const newDir3d = create3d(
            ballNewPos.x - this.playerPaddle.offset.x,
            0,
            (ballCenterY - paddleCenterY) / 2
          )
          const normalizedDir3d = vector.normalize(newDir3d)

          this.ballVelocity.x = normalizedDir3d.x
          this.ballVelocity.y = normalizedDir3d.z

          this.playWall()
        }
      }

      { // ? enemy
        const ballCenterY = this.ball.offset.y + (this.ball.size.y / 2)

        const paddleCenterY = this.enemyPaddle.offset.y + (this.enemyPaddle.size.y / 2)
        
        const upperRightPoint = create(
          this.ball.offset.x + this.enemyPaddle.size.x,
          this.ball.offset.y
        )

        const lowerRightPoint = create(
          this.ball.offset.x + this.enemyPaddle.size.x,
          this.ball.offset.y + this.ball.size.y
        )

        if (this.enemyPaddle.pointWithin(upperRightPoint) || this.enemyPaddle.pointWithin(lowerRightPoint)) {

          ballNewPos.x = this.enemyPaddle.offset.x - this.enemyPaddle.size.x

          // This is surprisingly accurate.
          const newDir3d = create3d(
            ballNewPos.x - this.enemyPaddle.offset.x,
            0,
            (ballCenterY - paddleCenterY) / 2
          )

          const normalizedDir3d = vector.normalize(newDir3d)

          this.ballVelocity.x = normalizedDir3d.x
          this.ballVelocity.y = normalizedDir3d.z

          this.playWall()
        }
      }

      //todo: This is also the points system
      if (ballNewPos.x >= this.windowSize.x - this.ball.size.x) {
        ballNewPos.x = this.windowSize.x - this.ball.size.x
        this.ballVelocity.x *= -1
        this.scorePlayer++
        this.playScore()
      } else if (ballNewPos.x <= 0) {
        ballNewPos.x = 0
        this.ballVelocity.x *= -1
        this.scoreEnemy++
        this.playScore()
      }

      if (ballNewPos.y >= this.windowSize.y - this.ball.size.y) {
        ballNewPos.y = this.windowSize.y - this.ball.size.y
        this.ballVelocity.y *= -1
        this.playWall()
      } else if (ballNewPos.y <= 0) {
        ballNewPos.y = 0
        this.ballVelocity.y *= -1
        this.playWall()
      }

      this.ball.offset = ballNewPos
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
      this.playerControls(delta)
      this.enemyLogic(delta)
      this.ballLogic(delta)
      this.updateScene()
    }
  }
  DesktopEnvironment.registerProgram(Gong)
}