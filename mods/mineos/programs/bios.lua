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
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    local create = vector.create2d
    local BiosProcedure = __TS__Class()
    BiosProcedure.name = "BiosProcedure"
    __TS__ClassExtends(BiosProcedure, mineos.Program)
    function BiosProcedure.prototype.____constructor(self, ...)
        BiosProcedure.____super.prototype.____constructor(self, ...)
        self.timer = 0
        self.stateTimer = 0
        self.state = 0
        self.increments = 0.5
        self.memoryCounter = 0
        self.impatience = 1
    end
    function BiosProcedure.prototype.main(self, delta)
        if self.timer == 0 then
            mineos.System.out:println("bios started")
        end
        self.timer = self.timer + delta
        self.stateTimer = self.stateTimer + delta
        self.renderer:update()
        if self.stateTimer > self.increments then
            repeat
                local ____switch6 = self.state
                local ____cond6 = ____switch6 == 5
                if ____cond6 then
                    do
                        self.audioController:playSound("computerBeep", 1)
                        self.renderer:addElement(
                            "bios_logo",
                            {
                                name = "bios_logo",
                                hud_elem_type = HudElementType.image,
                                position = create(0, 0),
                                text = "minetest.png",
                                scale = create(1 / 16, 1 / 16),
                                alignment = create(1, 1),
                                offset = create(0, 0),
                                z_index = 1
                            }
                        )
                        self.renderer:addElement(
                            "bios_name",
                            {
                                name = "bios_name",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = " Minetest\nMegablocks",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(3, 3),
                                offset = create(150, 20),
                                style = 4,
                                z_index = 1
                            }
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 6
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "cpu_detection",
                            {
                                name = "cpu_detection",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "Detecting CPU...",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(20, 200),
                                style = 4,
                                z_index = 1
                            }
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 8
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "cpu_detection_passed",
                            {
                                name = "cpu_detection_passed",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "MineRyzen 1300W detected.",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(200, 200),
                                style = 4,
                                z_index = 1
                            }
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 9
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "mem_check",
                            {
                                name = "mem_check",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "Total Memory:",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(20, 300),
                                style = 4,
                                z_index = 1
                            }
                        )
                        self.renderer:addElement(
                            "mem_check_progress",
                            {
                                name = "mem_check_progress",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "0 KB",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(200, 300),
                                style = 4,
                                z_index = 1
                            }
                        )
                        self.stateTimer = 10
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 10
                if ____cond6 then
                    do
                        self.stateTimer = 10
                        self.memoryCounter = self.memoryCounter + (10 + math.floor(math.random() * 10)) * self.impatience
                        local mem = tostring(self.memoryCounter) .. " KB"
                        if self.memoryCounter >= 4096 then
                            mem = tostring(4096) .. " KB"
                            self.stateTimer = 0
                            self.state = self.state + 1
                        end
                        self.renderer:setElementComponentValue("mem_check_progress", "text", mem)
                        return
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 11
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "block_check",
                            {
                                name = "block_check",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "Checking nodes...",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(20, 400),
                                style = 4,
                                z_index = 1
                            }
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 13
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "block_check_passed",
                            {
                                name = "block_check_passed",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "passed",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(200, 400),
                                style = 4,
                                z_index = 1
                            }
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 15
                if ____cond6 then
                    do
                        self.renderer:addElement(
                            "all_passed",
                            {
                                name = "all_passed",
                                hud_elem_type = HudElementType.text,
                                scale = create(1, 1),
                                text = "All system checks passed.",
                                number = colors.colorHEX(100, 100, 100),
                                position = create(0, 0),
                                alignment = create(1, 1),
                                size = create(1, 1),
                                offset = create(20, 500),
                                style = 4,
                                z_index = 1
                            }
                        )
                        break
                    end
                end
                ____cond6 = ____cond6 or ____switch6 == 16
                if ____cond6 then
                    do
                        self.iMem = 1
                        self.renderer:removeElement("bios_logo")
                        self.renderer:removeElement("bios_name")
                        self.renderer:removeElement("cpu_detection")
                        self.renderer:removeElement("cpu_detection_passed")
                        self.renderer:removeElement("mem_check")
                        self.renderer:removeElement("mem_check_progress")
                        self.renderer:removeElement("block_check")
                        self.renderer:removeElement("block_check_passed")
                        self.renderer:removeElement("all_passed")
                    end
                    break
                end
            until true
            self.state = self.state + 1
            self.stateTimer = self.stateTimer - self.increments
        end
    end
    mineos.System:registerProgram(BiosProcedure)
end
