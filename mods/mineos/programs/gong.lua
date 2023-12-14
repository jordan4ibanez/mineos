-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create2d
    local create3d = vector.create
    local dir_to_yaw = minetest.dir_to_yaw
    local yaw_to_dir = minetest.yaw_to_dir
    local PIXEL_SIZE = 16
    local function getPixel(dimension)
        return dimension * PIXEL_SIZE
    end
    local function randomDir()
        local dir3d = yaw_to_dir(math.random() * (math.pi * 2))
        return create(dir3d.x, dir3d.z)
    end
    local MOVEMENT_MULTIPLIER = 500
    local Gong = __TS__Class()
    Gong.name = "Gong"
    __TS__ClassExtends(Gong, mineos.WindowProgram)
    function Gong.prototype.____constructor(self, system, renderer, audio, desktop, size)
        Gong.____super.prototype.____constructor(
            self,
            system,
            renderer,
            audio,
            desktop,
            size
        )
        self.loaded = false
        self.ball = __TS__New(
            mineos.AABB,
            create(0, 0),
            create(
                getPixel(1),
                getPixel(1)
            ),
            create(0, 0)
        )
        self.ballVelocity = create(1, 0)
        self.playerPaddle = __TS__New(
            mineos.AABB,
            create(0, 0),
            create(
                getPixel(1),
                getPixel(4)
            ),
            create(0, 0)
        )
        self.instance = Gong.currentInstance
        Gong.currentInstance = Gong.currentInstance + 1
    end
    function Gong.prototype.move(self)
        self.renderer:setElementComponentValue(
            "gong_bg_" .. tostring(self.instance),
            "offset",
            self.windowPosition
        )
    end
    function Gong.prototype.getPlayerPaddlePos(self)
        return create(self.playerPaddle.offset.x + self.windowPosition.x, self.playerPaddle.offset.y + self.windowPosition.y)
    end
    function Gong.prototype.getBallPos(self)
        return create(self.ball.offset.x + self.windowPosition.x, self.ball.offset.y + self.windowPosition.y)
    end
    function Gong.prototype.load(self)
        self.ball.offset.x = self.windowSize.x / 2 - self.ball.size.x / 2
        self.ball.offset.y = self.windowSize.y / 2 - self.ball.size.y / 2
        self.playerPaddle.offset.y = self.windowSize.y / 2 - self.playerPaddle.size.y / 2
        self.renderer:addElement(
            "gong_bg_" .. tostring(self.instance),
            {
                name = "gong_bg_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(0, 0, 0)) .. ":255",
                scale = self.windowSize,
                alignment = create(1, 1),
                offset = create(
                    self:getPosX(),
                    self:getPosY()
                ),
                z_index = 1
            }
        )
        self.renderer:addElement(
            "gong_player_paddle_" .. tostring(self.instance),
            {
                name = "gong_player_paddle_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(100, 100, 100)) .. ":255",
                scale = self.playerPaddle.size,
                alignment = create(1, 1),
                offset = self:getPlayerPaddlePos(),
                z_index = 2
            }
        )
        self.renderer:addElement(
            "gong_ball_" .. tostring(self.instance),
            {
                name = "gong_ball_" .. tostring(self.instance),
                hud_elem_type = HudElementType.image,
                position = create(0, 0),
                text = ("pixel.png^[colorize:" .. colors.color(100, 100, 100)) .. ":255",
                scale = self.ball.size,
                alignment = create(1, 1),
                offset = self:getPlayerPaddlePos(),
                z_index = 2
            }
        )
        self:setWindowTitle("Gong")
        print("Gong loaded!")
        self.loaded = true
    end
    function Gong.prototype.updateScene(self)
        self.renderer:setElementComponentValue(
            "gong_player_paddle_" .. tostring(self.instance),
            "offset",
            self:getPlayerPaddlePos()
        )
        self.renderer:setElementComponentValue(
            "gong_ball_" .. tostring(self.instance),
            "offset",
            self:getBallPos()
        )
    end
    function Gong.prototype.playerControls(self, delta)
        local up = self.system:isKeyDown("up")
        local down = self.system:isKeyDown("down")
        if up then
            local ____self_playerPaddle_offset_0, ____y_1 = self.playerPaddle.offset, "y"
            ____self_playerPaddle_offset_0[____y_1] = ____self_playerPaddle_offset_0[____y_1] - delta * MOVEMENT_MULTIPLIER
            if self.playerPaddle.offset.y <= 0 then
                self.playerPaddle.offset.y = 0
            end
        elseif down then
            local ____self_playerPaddle_offset_2, ____y_3 = self.playerPaddle.offset, "y"
            ____self_playerPaddle_offset_2[____y_3] = ____self_playerPaddle_offset_2[____y_3] + delta * MOVEMENT_MULTIPLIER
            if self.playerPaddle.offset.y >= self.windowSize.y - self.playerPaddle.size.y then
                self.playerPaddle.offset.y = self.windowSize.y - self.playerPaddle.size.y
            end
        end
    end
    function Gong.prototype.ballLogic(self, delta)
        local ____self_ball_offset_4, ____x_5 = self.ball.offset, "x"
        local ____self_ball_offset_x_6 = ____self_ball_offset_4[____x_5] + self.ballVelocity.x * delta * MOVEMENT_MULTIPLIER
        ____self_ball_offset_4[____x_5] = ____self_ball_offset_x_6
        local ____self_ball_offset_7, ____y_8 = self.ball.offset, "y"
        local ____self_ball_offset_y_9 = ____self_ball_offset_7[____y_8] + self.ballVelocity.y * delta * MOVEMENT_MULTIPLIER
        ____self_ball_offset_7[____y_8] = ____self_ball_offset_y_9
        local ballNewPos = create(____self_ball_offset_x_6, ____self_ball_offset_y_9)
        do
            local ballCenterY = self.ball.offset.y + self.ball.size.y / 2
            local paddleCenterY = self.playerPaddle.offset.y + self.playerPaddle.size.y / 2
            local upperLeftPoint = create(self.ball.offset.x, self.ball.offset.y)
            local lowerLeftPoint = create(self.ball.offset.x, self.ball.offset.y + self.ball.size.y)
            if self.playerPaddle:pointWithin(upperLeftPoint) or self.playerPaddle:pointWithin(lowerLeftPoint) then
                ballNewPos.x = self.playerPaddle.offset.x + self.playerPaddle.size.x
                local newDir3d = create3d(ballNewPos.x - self.playerPaddle.offset.x, 0, (ballCenterY - paddleCenterY) / 2)
                local normalizedDir3d = vector.normalize(newDir3d)
                self.ballVelocity.x = normalizedDir3d.x
                self.ballVelocity.y = normalizedDir3d.z
            end
        end
        if ballNewPos.x >= self.windowSize.x - self.ball.size.x then
            ballNewPos.x = self.windowSize.x - self.ball.size.x
            local ____self_ballVelocity_10, ____x_11 = self.ballVelocity, "x"
            ____self_ballVelocity_10[____x_11] = ____self_ballVelocity_10[____x_11] * -1
        elseif ballNewPos.x <= 0 then
            ballNewPos.x = 0
            local ____self_ballVelocity_12, ____x_13 = self.ballVelocity, "x"
            ____self_ballVelocity_12[____x_13] = ____self_ballVelocity_12[____x_13] * -1
        end
        if ballNewPos.y >= self.windowSize.y - self.ball.size.y then
            ballNewPos.y = self.windowSize.y - self.ball.size.y
            local ____self_ballVelocity_14, ____y_15 = self.ballVelocity, "y"
            ____self_ballVelocity_14[____y_15] = ____self_ballVelocity_14[____y_15] * -1
        elseif ballNewPos.y <= 0 then
            ballNewPos.y = 0
            local ____self_ballVelocity_16, ____y_17 = self.ballVelocity, "y"
            ____self_ballVelocity_16[____y_17] = ____self_ballVelocity_16[____y_17] * -1
        end
        self.ball.offset = ballNewPos
    end
    function Gong.prototype.main(self, delta)
        if not self.loaded then
            self:load()
        end
        self:playerControls(delta)
        self:ballLogic(delta)
        self:updateScene()
    end
    Gong.currentInstance = 0
    mineos.DesktopEnvironment:registerProgram(Gong)
end
