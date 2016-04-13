class 'marioPlayer'

function marioPlayer:__init(plr_obj)
    self.plr_obj = plr_obj
    if(self.plr_obj.stateID==1)then
        self.plr_obj.health = 1
    elseif(self.plr_obj.stateID>=2)then
        self.plr_obj.health = 2
    end
end

function marioPlayer:onLoop(tickTime)
    if(Settings.isDebugInfoShown())then
        Renderer.printText("It's me, Mario!", 100, 230, 0, 15, 0xFFFF0055)
        Renderer.printText("Player x: "..tostring(self.plr_obj.x), 100, 260, 0, 15, 0xFFFF0055)
        Renderer.printText("Player y: "..tostring(self.plr_obj.y), 100, 300, 0, 15, 0xFFFF0055)
    end

    if((self.plr_obj.stateID==4) or (self.plr_obj.stateID==5))then
        if((not self.plr_obj.onGround) and self.plr_obj:getKeyState(KEY_JUMP) )then
            if(self.plr_obj.speedY>=2)then
                self.plr_obj.speedY=2
                self.plr_obj:setAnimation(15, 128)
            end
        end
    end
end

function marioPlayer:onHarm(harmEvent)
    processPlayerHarm(self.plr_obj, harmEvent)
end

function marioPlayer:onTakeNpc(npcObj)
    ProcessPlayerPowerUP(self.plr_obj, npcObj)
end

function marioPlayer:onKeyPressed(keyType)
    if(keyType==KEY_RUN)then
        self:shoot()
        Audio.playSound(18)
    end
end

function marioPlayer:shoot()
    local thrownNPC=self.plr_obj:spawnNPC(13, GENERATOR_APPEAR, SPAWN_UP, false)
    if(thrownNPC~=nil)then
        thrownNPC.motionSpeed = 256 + math.abs(self.plr_obj.speedX)*32
        thrownNPC.direction = self.plr_obj.direction
        if(self.plr_obj:getKeyState(KEY_UP))then
            thrownNPC.speedY = -4
        else
            thrownNPC.speedY = 3
        end
        thrownNPC.center_x = self.plr_obj.center_x + self.plr_obj.direction*(self.plr_obj.width/2)
        thrownNPC.center_y = self.plr_obj.center_y-16
        thrownNPC.special1 = 0
        thrownNPC.controller:setCharacter(self.plr_obj.characterID)
    end
end

return marioPlayer

