local SlashCo = SlashCo

hook.Add("Tick", "HandleSlasherAbilities", function()

    local gens = ents.FindByClass("sc_generator")
    if #gens < 1 then return end

    local SO = SlashCo.CurRound.OfferingData.SO

    --Calculate the Game Progress Value
    --The Game Progress Value - Amount of fuel poured into the Generator + amount of batteries inserted (1 - 10)
    local totalProgress = 0
    for _, v in ipairs(gens) do
        totalProgress = totalProgress + (SlashCo.GasCansPerGenerator - (v.CansRemaining or SlashCo.GasCansPerGenerator)) + ((v.HasBattery and 1) or 0)
    end
    if SlashCo.CurRound.SlasherData.GameProgress > -1 then
        SlashCo.CurRound.SlasherData.GameProgress = totalProgress
    end

for i = 1, #team.GetPlayers(TEAM_SLASHER) do

        local slasherid = team.GetPlayers(TEAM_SLASHER)[i]:SteamID64()
        local dist = SlashCo.CurRound.SlasherData[slasherid].ChaseRange + (SO * 250)

        local slasher = team.GetPlayers(TEAM_SLASHER)[i]

        --Handle The Chase Functions \/ \/ \/
        SlashCo.CurRound.SlasherData[slasherid].IsChasing = slasher:GetNWBool("InSlasherChaseMode")
        if SlashCo.CurRound.SlasherData[slasherid].CanChase == false then SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick = 99 end

        if SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown > 0 then 

            SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown = SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown - FrameTime() 

        end

        if not slasher:GetNWBool("InSlasherChaseMode") or  SlashCo.CurRound.SlasherData[slasherid].SlashID == 3 then goto CONTINUE end
do
        a = SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick
        SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick = a + FrameTime()

        --local inv = (1 - SlashCo.CurRound.SlasherData[slasherid].ChaseRadius) / 2
        local inv = -0.2

        local find = ents.FindInCone( slasher:GetPos(), slasher:GetEyeTrace().Normal, dist * 2, SlashCo.CurRound.SlasherData[slasherid].ChaseRadius + inv )
        local find_p = NULL

        for p = 1, #find do

            if find[p]:IsPlayer() and find[p]:Team() == TEAM_SURVIVOR then

                SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick = 0
                find_p = find[p]

            end

        end

        if slasher:GetEyeTrace().Entity:IsPlayer() and slasher:GetEyeTrace().Entity:Team() == TEAM_SURVIVOR and slasher:GetPos():Distance(slasher:GetEyeTrace().Entity:GetPos()) < dist * 2 then
            SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick = 0
            find_p = slasher:GetEyeTrace().Entity
        end

        if IsValid( find_p ) and not find_p:GetNWBool("SurvivorChased") then find_p:SetNWBool("SurvivorChased",true) end

        if a > SlashCo.CurRound.SlasherData[slasherid].ChaseDuration then 

            slasher:SetNWBool("InSlasherChaseMode", false) 

            slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
            slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
            slasher:StopSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic)

            SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown = SlashCo.CurRound.SlasherData[slasherid].ChaseCooldown

            timer.Simple(0.25, function() slasher:StopSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic) end)
        end

        if not slasher:GetNWBool("InSlasherChaseMode") then
            for p = 1, #team.GetPlayers(TEAM_SURVIVOR) do
                local ply = team.GetPlayers(TEAM_SURVIVOR)[p]
                if ply:GetNWBool("SurvivorChased") then ply:SetNWBool("SurvivorChased",false) end
            end
        end
end
        ::CONTINUE::

        --Handle The Chase Functions /\ /\ /\

        --Other Shared Functionality:

        if SlashCo.CurRound.SlasherData[slasherid].KillDelayTick > 0 then SlashCo.CurRound.SlasherData[slasherid].KillDelayTick = SlashCo.CurRound.SlasherData[slasherid].KillDelayTick - 0.01 end


        --Bababooey's Abilites
        if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 1 then goto SID end
    do
        v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Cooldown for being able to trigger
        v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Cooldown for being able to kill
        v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Cooldown for spook animation

        if v1 > 0 then 
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = v1 - (FrameTime() + (SO * 0.04)) 
        end

        if v2 > 0 then 
            SlashCo.CurRound.SlasherData[slasherid].CanKill = false 
        elseif not slasher:GetNWBool("BababooeyInvisibility") then 
            SlashCo.CurRound.SlasherData[slasherid].CanKill = true 
        else 
            SlashCo.CurRound.SlasherData[slasherid].CanKill = false 
        end

        SlashCo.CurRound.SlasherData[slasherid].CanChase = not slasher:GetNWBool("BababooeyInvisibility")

        if v3 < 0.01 then slasher:SetNWBool("BababooeySpooking", false) end

        if v2 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - (FrameTime() + (SO * 0.04)) end
        if v3 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = v3 - (FrameTime() + (SO * 0.04)) end

    end
        ::SID::
        --Sid's Abilities
        if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 2 then goto TROLLGE end
    do
        v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Cookies Eaten
        v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Pacification
        v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Gun use cooldown
        v4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 --bullet spread
        v5 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 --chase speed increase

        if v2 > 0 then 

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - (FrameTime() + (SO * 0.04))  
            SlashCo.CurRound.SlasherData[slasherid].CanKill = false 
            SlashCo.CurRound.SlasherData[slasherid].CanChase = false 

        elseif slasher:GetNWBool("SidGun") then

            SlashCo.CurRound.SlasherData[slasherid].CanKill = false 
            SlashCo.CurRound.SlasherData[slasherid].CanChase = false 
            slasher:SetNWBool("DemonPacified", false)

        else

            SlashCo.CurRound.SlasherData[slasherid].CanKill = true 
            SlashCo.CurRound.SlasherData[slasherid].CanChase = true 
            slasher:SetNWBool("DemonPacified", false)

        end

        if v3 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = v3 - (FrameTime() + (SO * 0.04))  end
        if v4 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = v4 - (0.02 + (SO * 0.08))  end

        if v5 < 160 and slasher:GetNWBool("InSlasherChaseMode") then 
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 = v5 + (FrameTime() + (SO * 0.02)) + (v1*FrameTime()*0.5)
            slasher:SetRunSpeed(SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed + (v5/3.5))
            slasher:SetWalkSpeed(SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed + (v5/3.5))
        else
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 = 0
        end

        if not slasher:GetNWBool("DemonPacified") then

            if not slasher:GetNWBool("SidGun") then

                SlashCo.CurRound.SlasherData[slasherid].Eyesight = SlashCo.SlasherData[2].Eyesight
                SlashCo.CurRound.SlasherData[slasherid].Perception = SlashCo.SlasherData[2].Perception

            else

                if not slasher:GetNWBool("SidGunRage") then

                    SlashCo.CurRound.SlasherData[slasherid].Eyesight = SlashCo.SlasherData[2].Eyesight + (2 + (SO * 2))
                    SlashCo.CurRound.SlasherData[slasherid].Perception = SlashCo.SlasherData[2].Perception + (1.5 + (SO * 1))

                else

                    SlashCo.CurRound.SlasherData[slasherid].Eyesight = SlashCo.SlasherData[2].Eyesight + (5 + (SO * 2))
                    SlashCo.CurRound.SlasherData[slasherid].Perception = SlashCo.SlasherData[2].Perception + (1 + (SO * 3))

                end

            end

         else

            SlashCo.CurRound.SlasherData[slasherid].Eyesight = 0
            SlashCo.CurRound.SlasherData[slasherid].Perception = 0

        end



        if SlashCo.CurRound.SlasherData.GameProgress > 9 and not slasher:GetNWBool("SidGunRage") then 
            slasher:SetNWBool("SidGunRage", true) 

            if slasher:GetNWBool("SidGunEquipped") then 

                if not slasher:GetNWBool("SidGunAimed") and not slasher:GetNWBool("SidGunAiming") then
                    slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed )
                end

            end
        end

        if slasher:GetNWBool("SidGunRage") and not slasher:GetNWBool("SidGunLetterC") and slasher:GetNWBool("SidGunEquipped") then

            slasher:SetNWBool("SidGunLetterC", true)

            PlayGlobalSound("slashco/slasher/sid_THE_LETTER_C.wav",95,slasher, 0.5)

        end
    end
        ::TROLLGE::
        --Trollge's Abilities
        if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 3 then goto AMOGUS end
    do
        v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Stage
        v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Claw cooldown
        v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --blood

        if v2 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - FrameTime() end
        if v2 > 2 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 2 end
        if v2 < 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0 end

        if v1 == 0 then slasher:SetNWBool("TrollgeStage1", false) slasher:SetNWBool("TrollgeStage2", false) end
        if v1 == 1 then slasher:SetNWBool("TrollgeStage1", true) slasher:SetNWBool("TrollgeStage2", false) end
        if v1 == 2 then slasher:SetNWBool("TrollgeStage1", false) slasher:SetNWBool("TrollgeStage2", true) end

        if not slasher:GetNWBool("TrollgeTransition") and not slasher:GetNWBool("TrollgeStage1") and SlashCo.CurRound.SlasherData.GameProgress > 4 and v1 < 1 then

            slasher:SetNWBool("TrollgeTransition", true)
            slasher:Freeze(true)
            slasher:StopSound("slashco/slasher/trollge_breathing.wav")
            PlayGlobalSound("slashco/slasher/trollge_transition.mp3",125,slasher)

            for p = 1, #player.GetAll() do
                local ply = player.GetAll()[p]
                ply:SetNWBool("DisplayTrollgeTransition",true)
            end

            timer.Simple(7, function() --transit 
                slasher:StopSound("slashco/slasher/trollge_breathing.wav")
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 1
                slasher:SetNWBool("TrollgeTransition", false)
                slasher:Freeze(false)
                PlayGlobalSound("slashco/slasher/trollge_stage1.wav",60,ply)

                slasher:SetRunSpeed( 280 )
                slasher:SetWalkSpeed( 150  )
                --SlashCo.CurRound.SlasherData[slasherid].Eyesight = 4

                for i = 1, #player.GetAll() do
                    local ply = player.GetAll()[i]
                    ply:SetNWBool("DisplayTrollgeTransition",false)
                end
            end)

        end

        if v3 > 8 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 8 end

        if not slasher:GetNWBool("TrollgeTransition") and not slasher:GetNWBool("TrollgeStage2") and SlashCo.CurRound.SlasherData.GameProgress > (10 - (v3/2)) and v1 == 1 then

            slasher:SetNWBool("TrollgeTransition", true)
            slasher:Freeze(true)
            slasher:StopSound("slashco/slasher/trollge_stage1.wav")
            PlayGlobalSound("slashco/slasher/trollge_transition.mp3",125,slasher)

            for i = 1, #player.GetAll() do
                local ply = player.GetAll()[i]
                ply:SetNWBool("DisplayTrollgeTransition",true)
            end

            timer.Simple(7, function() --transit 
                slasher:StopSound("slashco/slasher/trollge_stage1.wav")
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 2
                slasher:SetNWBool("TrollgeTransition", false)
                slasher:Freeze(false)
                PlayGlobalSound("slashco/slasher/trollge_stage6.wav",60,ply)

                slasher:SetRunSpeed( 450 )
                slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed  )
                SlashCo.CurRound.SlasherData[slasherid].Eyesight = 10

                for i = 1, #player.GetAll() do
                    local ply = player.GetAll()[i]
                    ply:SetNWBool("DisplayTrollgeTransition",false)
                end
            end)

        end

        if v1 == 1 then

            SlashCo.CurRound.SlasherData[slasherid].Eyesight = 10 - (   slasher:GetVelocity():Length() / 35 )
            SlashCo.CurRound.SlasherData[slasherid].Perception = 5 - (   slasher:GetVelocity():Length() / 60 )

        end

    end

    ::AMOGUS::

    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 4 then goto THIRSTY end
    --Amogus' Abilities
do
    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Transformation type
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Transform cooldown
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Fuel Can EntIndex

    if IsValid(ents.GetByIndex(SlashCo.CurRound.SlasherData[slasherid].SlasherValue3)) then
        ents.GetByIndex(SlashCo.CurRound.SlasherData[slasherid].SlasherValue3):SetAngles(Angle(0,slasher:EyeAngles()[2],0))
    end

    if v2 > 0 then 
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - FrameTime() 
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false
        --SlashCo.CurRound.SlasherData[slasherid].CanChase = false
    else
        if not slasher:GetNWBool("AmogusDisguised") and not slasher:GetNWBool("AmogusDisguising") then
            SlashCo.CurRound.SlasherData[slasherid].CanKill = true
            SlashCo.CurRound.SlasherData[slasherid].CanChase = true
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 0
        else
            SlashCo.CurRound.SlasherData[slasherid].CanKill = false
            SlashCo.CurRound.SlasherData[slasherid].CanChase = false
        end
    end   
    
    
end
    ::THIRSTY::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 5 then goto MALE07 end
    --Thirsty's Abilities
do
    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Milk drank
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Pacification
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Thirst

    if v2 > 0 then --Thirsty is pacified

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 0

        SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed = 100
        SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed = 100
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 0
        SlashCo.CurRound.SlasherData[slasherid].Perception = 0

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - (0.01 + (SO * 0.04))  
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false 
        SlashCo.CurRound.SlasherData[slasherid].CanChase = false 
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 0
        slasher:SetNWBool("DemonPacified", true)

    else --Thirsty is not pacified

        if v3 < 100 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = v3 + (FrameTime()/(2 - (SO/2))) end
        --Deplete thirst

        SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed = 285 - ( v1 * 10)
        SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed = 100 + ( (    ( v3 / (7 - v1)   )   ) + ( v1 * 20 )   )*(0.8+(SO*0.5))
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 2 + (    ( v3 / (28.5 - (v1*4))   )   )  
        SlashCo.CurRound.SlasherData[slasherid].Perception = 1.0 + (    ( v3 / (44.5 - (v1*8))   )   )  
        --Thirsty's basic stats raise the thirstier he is, and are also multiplied by how much milk he has drunk.
        --His chase speed is greatest at low milk drank, and the more he drinks, it is converted to prowl speed.

        SlashCo.CurRound.SlasherData[slasherid].CanKill = true 
        SlashCo.CurRound.SlasherData[slasherid].CanChase = true 
        slasher:SetNWBool("DemonPacified", false)

        if slasher:GetNWBool("InSlasherChaseMode") then 

            slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed )
            slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed )
        else

            slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
            slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )

        end

    end

end
    ::MALE07::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 6 then goto TYLER end
    --Male_07's Abilities
do
    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --State
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Time Spent Human Chasing
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Cooldown
    v4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 --Slash Cooldown

    if v3 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = v3 - FrameTime() end
    if v4 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = v4 - FrameTime() end

    if v1 == 0 then --Specter mode

        SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed = 300
        SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed = 300
        SlashCo.CurRound.SlasherData[slasherid].Perception = 0.0
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 10

        SlashCo.CurRound.SlasherData[slasherid].CanKill = false 
        SlashCo.CurRound.SlasherData[slasherid].CanChase = false

    elseif v1 == 1 then --Human mode

        SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed = 100
        SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed = 302
        SlashCo.CurRound.SlasherData[slasherid].Perception = 1.0
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 2
        SlashCo.CurRound.SlasherData[slasherid].ChaseRange = 400

        SlashCo.CurRound.SlasherData[slasherid].CanKill = true 
        SlashCo.CurRound.SlasherData[slasherid].CanChase = true

        if SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick == 99 then SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick = 0 end

    elseif v1 == 2 then --Monster mode

        SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed = 150
        SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed = 285
        SlashCo.CurRound.SlasherData[slasherid].Perception = 1.5
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 5
        SlashCo.CurRound.SlasherData[slasherid].ChaseRange = 700

        SlashCo.CurRound.SlasherData[slasherid].CanKill = false 

    end

    if slasher:GetNWBool("InSlasherChaseMode") then 

        if v1 == 1 then

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 + FrameTime()

            --Timer - 10 seconds + Game Progress (1-10) ^ 3 (SO - x2)

            if v2 > 1 + (SlashCo.CurRound.SlasherData.GameProgress*1.5) +  (0.75 * math.pow( SlashCo.CurRound.SlasherData.GameProgress, 2 ) ) * (1 + SO) then 

                --Become Monster

                local modelname = "models/slashco/slashers/male_07/male_07_monster.mdl"
	            util.PrecacheModel( modelname )
	            slasher:SetModel( modelname )

                slasher:SetNWBool("Male07Transforming", true)
                slasher:SetNWBool("Male07Slashing", false)
                slasher:Freeze(true)

                local vPoint = slasher:GetPos() + Vector(0,0,50)
                local bloodfx = EffectData()
                bloodfx:SetOrigin( vPoint )
                util.Effect( "BloodImpact", bloodfx )

                slasher:EmitSound("vo/npc/male01/no02.wav") 

                slasher:EmitSound("NPC_Manhack.Slice") 
               
                timer.Simple(3, function() 

                    slasher:SetNWBool("Male07Transforming", false)
                    slasher:Freeze(false)

                    if slasher:GetNWBool("InSlasherChaseMode") then

                        slasher:SetRunSpeed(285)
                        slasher:SetWalkSpeed(285)

                    end

                end)

                SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 2

            end

        end

    end

end
    ::TYLER::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 7 then goto BORGMIRE end
    --Tyler's Abilities
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --State
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Time Spent as Creator or destroyer
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Times Found
    v4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 --Destruction power
    v5 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 --Destoyer Blink

    local ms = SlashCo.Maps[SlashCo.ReturnMapIndex()].SIZE

    SlashCo.CurRound.SlasherData[slasherid].CanChase = false

    if v1 == 0 then --Specter

        slasher.TylerSongPickedID = nil

        slasher:SetNWBool("TylerFlash", false)

        slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed ) 
        slasher:SetRunSpeed(SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed)
        slasher:SetWalkSpeed(SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed)
        slasher:SetNWBool("TylerTheCreator", false)
        slasher:SetBodygroup( 0, 0 )
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false
        SlashCo.CurRound.SlasherData[slasherid].Perception = 6.0

    elseif v1 == 1 then --Creator

        slasher:SetNWBool("TylerFlash", false)

        slasher:SetSlowWalkSpeed( 1 ) 
        slasher:SetRunSpeed(1)
        slasher:SetWalkSpeed(1)
        slasher:Freeze(true)
        slasher:SetNWBool("TylerTheCreator", true)
        slasher:SetBodygroup( 0, 0 )
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 + FrameTime()
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false
        SlashCo.CurRound.SlasherData[slasherid].Perception = 0.0

        if not slasher:GetNWBool("TylerCreating") and slasher.TylerSongPickedID == nil then
            slasher.TylerSongPickedID = math.random(1,6)

            PlayGlobalSound("slashco/slasher/tyler_song_"..slasher.TylerSongPickedID..".mp3",  98 , slasher,  0.8 - (SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 * 0.12))
        end

        if v2 > ( ms * 40) - (v4 * 4) then --Time ran out

            local stop_song = slasher.TylerSongPickedID

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 2
            slasher:StopSound("slashco/slasher/tyler_song_"..stop_song..".mp3")
            timer.Simple(0.1, function() slasher:StopSound("slashco/slasher/tyler_song_"..stop_song..".mp3") end)
            slasher.TylerSongPickedID = nil

        end

        for i = 1, #team.GetPlayers(TEAM_SURVIVOR) do --Survivor found tyler

            local surv = team.GetPlayers(TEAM_SURVIVOR)[i]

            local stop_song = slasher.TylerSongPickedID

            if not slasher:GetNWBool("TylerCreating") and surv:GetPos():Distance( slasher:GetPos() ) < 400 and surv:GetEyeTrace().Entity == slasher then

                slasher:SetNWBool("TylerCreating", true)
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0
                slasher:StopSound("slashco/slasher/tyler_song_"..stop_song..".mp3")
                timer.Simple(0.1, function() slasher:StopSound("slashco/slasher/tyler_song_"..stop_song..".mp3") end)
                slasher.TylerSongPickedID = nil

            end

        end

        if slasher:GetNWBool("TylerCreating") and SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 ~= 1.8 then

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 = 1.8
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0

            slasher:EmitSound("slashco/slasher/tyler_create.mp3")

            timer.Simple(3, function() 
            
                SlashCo.CreateGasCan(slasher:GetPos() + (slasher:GetForward() * 60) + Vector(0,0,18), Angle(0,0,0))
            
            end)

            timer.Simple(4, function() 
            
                slasher:SetNWBool("TylerCreating", false)
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 0
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 + 1
                SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 = 0

                slasher:Freeze(false)

                slasher:SetColor(Color(0,0,0,0))
                slasher:DrawShadow(false)
		        slasher:SetRenderMode(RENDERMODE_TRANSALPHA)
		        slasher:SetNoDraw(true)
            
            end)

        end

        slasher.tyler_destroyer_entrance_antispam = nil

    elseif v1 == 2 then --Pre-Destroyer

        slasher.TylerSongPickedID = nil

        slasher:Freeze(true)

        if slasher.tyler_destroyer_entrance_antispam == nil then

            PlayGlobalSound("slashco/slasher/tyler_alarm.wav", 110, slasher, 1)
            if CLIENT then
                slasher.TylerSong:Stop() 
                slasher.TylerSong = nil
            end

            slasher.tyler_destroyer_entrance_antispam = 0
        end

        local decay = v4 / 2

        if v4 > 14 then decay = 7 end 

        if slasher.tyler_destroyer_entrance_antispam < (12 - decay) then
            slasher.tyler_destroyer_entrance_antispam = slasher.tyler_destroyer_entrance_antispam + FrameTime()
        else

            slasher:StopSound("slashco/slasher/tyler_alarm.wav")
            timer.Simple(0.1, function() slasher:StopSound("slashco/slasher/tyler_alarm.wav") end) --idk man only works if i stop it twice shut up

            PlayGlobalSound("slashco/slasher/tyler_destroyer_theme.wav", 98, slasher, 1)
            PlayGlobalSound("slashco/slasher/tyler_destroyer_whisper.wav", 101, slasher, 0.75)

            slasher:Freeze(false)

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 3

            for i = 1, #player.GetAll() do
                local ply = player.GetAll()[i]
                ply:SetNWBool("DisplayTylerTheDestroyerEffects",true)
            end

        end

        slasher:SetSlowWalkSpeed( 1 ) 
        slasher:SetRunSpeed(1)
        slasher:SetWalkSpeed(1)
        slasher:SetNWBool("TylerTheCreator", false)
        slasher:SetBodygroup( 0, 1 )
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false
        SlashCo.CurRound.SlasherData[slasherid].Perception = 0.0

    elseif v1 == 3 then --Destroyer

        slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed ) 
        slasher:SetRunSpeed(SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed)
        slasher:SetWalkSpeed(SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed)
        slasher:SetNWBool("TylerTheCreator", false)
        slasher:SetBodygroup( 0, 1 )
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 + FrameTime()
        SlashCo.CurRound.SlasherData[slasherid].CanKill = true
        SlashCo.CurRound.SlasherData[slasherid].Perception = 2.0

        if v2 > ((ms * 15) + 60 + (v4 * 10)) then

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 0

            slasher:StopSound("slashco/slasher/tyler_destroyer_theme.wav")
            slasher:StopSound("slashco/slasher/tyler_destroyer_whisper.wav")
            timer.Simple(0.1, function() slasher:StopSound("slashco/slasher/tyler_destroyer_theme.wav") slasher:StopSound("slashco/slasher/tyler_destroyer_whisper.wav") end)

            slasher:SetColor(Color(0,0,0,0))
            slasher:DrawShadow(false)
            slasher:SetRenderMode(RENDERMODE_TRANSALPHA)
            slasher:SetNoDraw(true)
            slasher:SetNWBool("TylerFlash", false)

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 - 1

            for i = 1, #player.GetAll() do
                local ply = player.GetAll()[i]
                ply:SetNWBool("DisplayTylerTheDestroyerEffects",false)
            end

        end

    end

    if v1 > 1 then

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 = v5 + FrameTime()

        if v5 > 0.85 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue5 = 0 end

        if v5 <= 0.5 then 
            slasher:SetColor(Color(0,0,0,0))
            slasher:DrawShadow(false)
		    slasher:SetRenderMode(RENDERMODE_TRANSALPHA)
		    slasher:SetNoDraw(true)
            slasher:SetNWBool("TylerFlash", false)
        else
            slasher:SetColor(Color(255,255,255,255))
            slasher:DrawShadow(true)
		    slasher:SetRenderMode(RENDERMODE_TRANSCOLOR)
		    slasher:SetNoDraw(false)
            slasher:SetNWBool("TylerFlash", true)
        end

    end

end
    ::BORGMIRE::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 8 then goto MANSPIDER end
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Time Spent chasing
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Punch Cooldown
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Punch Slowdown

    if v2 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - FrameTime() end

    if v3 > 1 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = v3 - (FrameTime()/(2-SO)) end
    if v3 < 1 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 1 end

    if not slasher:GetNWBool("InSlasherChaseMode") then

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 0

        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )

        slasher.ChaseSound = nil 

        if slasher.IdleSound == nil then

            PlayGlobalSound("slashco/slasher/borgmire_breath_base.wav", 60, slasher, 1)

            slasher:StopSound("slashco/slasher/borgmire_breath_chase.wav")
            timer.Simple(0.1, function() slasher:StopSound("slashco/slasher/borgmire_breath_chase.wav") end)

            slasher.IdleSound = true
        end

    else

        slasher.IdleSound = nil 

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = v1 + FrameTime()

        slasher:SetRunSpeed(  (     SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - math.sqrt( v1 * (14-(SO*7)) )   ) / v3 )
        slasher:SetWalkSpeed( (     SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - math.sqrt( v1 * (14-(SO*7)) )   ) / v3 )

        if slasher.ChaseSound == nil then

            PlayGlobalSound("slashco/slasher/borgmire_breath_chase.wav", 70, slasher, 1)

            PlayGlobalSound("slashco/slasher/borgmire_anger.mp3", 75, slasher, 1)

            PlayGlobalSound("slashco/slasher/borgmire_anger_far.mp3", 110, slasher, 1)

            slasher:StopSound("slashco/slasher/borgmire_breath_base.wav")
            timer.Simple(0.1, function() slasher:StopSound("slashco/slasher/borgmire_breath_base.wav") end)

            slasher.ChaseSound = true
        end

    end

end
    ::MANSPIDER::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 9 then goto WATCHER end
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Target SteamID
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Leap Cooldown
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Time spend nested
    v4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 --Aggression

    if v2 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - FrameTime() end

    if not isstring(v1) or v1 == 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = "" end

    if v1 == "" then

        SlashCo.CurRound.SlasherData[slasherid].CanChase = false
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false

    else

        SlashCo.CurRound.SlasherData[slasherid].CanChase = true
        SlashCo.CurRound.SlasherData[slasherid].CanKill = true

        if not IsValid(  player.GetBySteamID64( v1 ) ) or player.GetBySteamID64( v1 ):Team() ~= TEAM_SURVIVOR then SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = "" end

    end

    for i = 1, #team.GetPlayers(TEAM_SURVIVOR) do --Switch Target if too close

        local s = team.GetPlayers(TEAM_SURVIVOR)[i]

        local d = s:GetPos():Distance( slasher:GetPos() )

        if d < (150) then

            local tr = util.TraceLine( {
                start = slasher:EyePos(),
                endpos = s:GetPos()+Vector(0,0,40),
                filter = slasher
            } )

            if tr.Entity == s then

                if SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 ~= s:SteamID64() then

                    SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = s:SteamID64()
                    slasher:EmitSound("slashco/slasher/manspider_scream"..math.random(1,4)..".mp3")

                end

            end

        end

    end

    if slasher:GetNWBool("ManspiderNested") then

        --Find a survivor
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = v3 + FrameTime()

        for i = 1, #team.GetPlayers(TEAM_SURVIVOR) do

            local s = team.GetPlayers(TEAM_SURVIVOR)[i]

            if s:GetPos():Distance( slasher:GetPos() ) < (1000 + (v3 * 3) + (SO * 750)) then

                local tr = util.TraceLine( {
                    start = slasher:EyePos(),
                    endpos = s:GetPos()+Vector(0,0,40),
                    filter = slasher
                } )

                if tr.Entity == s then
                    slasher:EmitSound("slashco/slasher/manspider_scream"..math.random(1,4)..".mp3")
                    SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = s:SteamID64()
                    slasher:SetNWBool("ManspiderNested", false)

                    slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
                    slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
                    slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
                end

            end

        end

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = 0

    else

        --Not nested
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 0

        if v1 == "" then

            for i = 1, #team.GetPlayers(TEAM_SURVIVOR) do

                local s = team.GetPlayers(TEAM_SURVIVOR)[i]

                local d = s:GetPos():Distance( slasher:GetPos() )
    
                if d < (1000) then
    
                    local tr = util.TraceLine( {
                        start = slasher:EyePos(),
                        endpos = s:GetPos()+Vector(0,0,40),
                        filter = slasher
                    } )
    
                    if tr.Entity == s then

                        SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = v4 + ( FrameTime() + (  (1000-d)  / 10000  )   )  + (SO * FrameTime())

                        if v4 > 100 then
                            SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = s:SteamID64()
                            slasher:EmitSound("slashco/slasher/manspider_scream"..math.random(1,4)..".mp3")
                        end

                    end
    
                end
    
            end

        else

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = 0

        end

    end

end

    ::WATCHER::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 10 then goto ABOMIGNAT end
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Survey Length
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Survey Cooldown
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Watched
    v4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 --Stalk time

    SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = BoolToNumber( slasher:GetNWBool("WatcherWatched") )

    if not slasher:GetNWBool("WatcherRage") then
        if v1 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = v1 - FrameTime() end
    else
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 1
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 0.65 
        SlashCo.CurRound.SlasherData[slasherid].CanChase = false
    end

    if slasher:GetNWBool("InSlasherChaseMode") or slasher:GetNWBool("WatcherRage") then

        slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - (v3 * 80) )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - (v3 * 80) )
        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - (v3 * 80) )

    else

        slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed - (v3 * 120) )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed - (v3 * 120) )
        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed - (v3 * 120) )

    end

    if v2 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = v2 - FrameTime() end

    local isSeen = false

    for s = 1, #team.GetPlayers(TEAM_SURVIVOR) do

        local surv = team.GetPlayers(TEAM_SURVIVOR)[s]

        if v1 > 0 then

            if not surv:GetNWBool("SurvivorWatcherSurveyed") then surv:SetNWBool("SurvivorWatcherSurveyed", true) end

        else

            if surv:GetNWBool("SurvivorWatcherSurveyed") then surv:SetNWBool("SurvivorWatcherSurveyed", false) end

            local find = ents.FindInCone( surv:GetPos(), surv:GetEyeTrace().Normal, 3000, 0.5 )

            local target = NULL

            if surv:GetEyeTrace().Entity == slasher then
                target = slasher
                goto FOUND
            end

            do
                for i = 1, #find do
                    if find[i] == slasher then 
                        target = find[i]
                        break 
                    end
                end

                if IsValid(target) then
                    local tr = util.TraceLine( {
                        start = surv:EyePos(),
                        endpos = target:GetPos()+Vector(0,0,50),
                        filter = surv
                    } )

                    if tr.Entity ~= target then target = NULL end
                end

            end
            ::FOUND::

            if IsValid(target) and target == slasher then 
                surv:SetNWBool("SurvivorWatcherSurveyed", true) 
                isSeen = true
            else
                if surv:GetNWBool("SurvivorWatcherSurveyed") then surv:SetNWBool("SurvivorWatcherSurveyed", false) end
            end

        end

    end

    slasher:SetNWBool("WatcherWatched", isSeen) 

    --Stalk Survivors

    local find = ents.FindInCone( slasher:GetPos(), slasher:GetEyeTrace().Normal, 1500, 0.85 )

    local target = NULL

    if slasher:GetEyeTrace().Entity:IsPlayer() and slasher:GetEyeTrace().Entity:Team() == TEAM_SURVIVOR then
        target = slasher:GetEyeTrace().Entity
        goto FOUND
    end

    do
         for i = 1, #find do
            if find[i]:IsPlayer() and find[i]:Team() == TEAM_SURVIVOR then 
                target = find[i]
                break 
            end
        end

        if IsValid(target) then
            local tr = util.TraceLine( {
                start = slasher:EyePos(),
                endpos = target:GetPos()+Vector(0,0,50),
                filter = slasher
            } )

            if tr.Entity ~= target then target = NULL end
        end

    end
    ::FOUND::

    if IsValid( target ) and isSeen == false and not slasher:GetNWBool("InSlasherChaseMode") then
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = v4 + FrameTime()
        if not slasher:GetNWBool("WatcherStalking") then slasher:SetNWBool("WatcherStalking", true) end
    else
        if slasher:GetNWBool("WatcherStalking") then slasher:SetNWBool("WatcherStalking", false) end
    end

end

    ::ABOMIGNAT::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 11 then goto CRIMINAL end
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Main Slash Cooldown
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Forward charge
    v3 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 --Lunge Finish Antispam
    v4 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 --Lunge Duration

    if v1 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = v1 - FrameTime() end

    if slasher:IsOnGround() then slasher:SetVelocity(slasher:GetForward() * v2 * 8) end

    if slasher:GetNWBool("AbomignatLunging") then

        local target = slasher:TraceHullAttack( slasher:EyePos(), slasher:LocalToWorld(Vector(45,0,30)), Vector(-15,-15,-60), Vector(15,15,60), 50, DMG_SLASH, 5, false )

        SlashCo.BustDoor(slasher, target, 25000)

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = v4 + 1

        if ( slasher:GetVelocity():Length() < 450 or target:IsValid() ) and v4 > 30 and SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 == 0 then

            slasher:SetNWBool("AbomignatLungeFinish",true)
            timer.Simple(0.6, function() slasher:EmitSound("slashco/slasher/abomignat_scream"..math.random(1,3)..".mp3") end)

            slasher:SetNWBool("AbomignatLunging",false)
            slasher:SetCycle( 0 )

            SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 1

            timer.Simple(4, function() 
                if v3 == 1 then
                    SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 2
                    SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = 0
                    slasher:SetNWBool("AbomignatLungeFinish",false)   
                    slasher:Freeze(false)  
                end       
            end)

        end


    end

    if slasher:GetNWBool("AbomignatCrawling") then 
    
        SlashCo.CurRound.SlasherData[slasherid].CanChase = false

        slasher:SetSlowWalkSpeed( 350 )
        slasher:SetWalkSpeed( 350 )
        slasher:SetRunSpeed( 350 )

        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 0
        SlashCo.CurRound.SlasherData[slasherid].Perception = 0

        if slasher:GetVelocity():Length() < 3 then 
            slasher:SetNWBool("AbomignatCrawling",false) 
            SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown = SlashCo.CurRound.SlasherData[slasherid].ChaseCooldown 
        end

        if not slasher:IsOnGround() then 
            slasher:SetNWBool("AbomignatCrawling",false) 
            SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown = SlashCo.CurRound.SlasherData[slasherid].ChaseCooldown 
        end

        slasher:SetViewOffset( Vector(0,0,20) )
        slasher:SetCurrentViewOffset( Vector(0,0,20) )

    else

        SlashCo.CurRound.SlasherData[slasherid].CanChase = true

        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 6
        SlashCo.CurRound.SlasherData[slasherid].Perception = 0.5

        slasher:SetViewOffset( Vector(0,0,70) )
        slasher:SetCurrentViewOffset( Vector(0,0,70) )

        if not slasher:GetNWBool("InSlasherChaseMode") then
            slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
            slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
            slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        end

    end

end

    ::CRIMINAL::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 12 then goto FREESMILEY end
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Cloning Duration

    if slasher:GetVelocity():Length() > 5 then
        SlashCo.CurRound.SlasherData[slasherid].CanKill = false
    else
        SlashCo.CurRound.SlasherData[slasherid].CanKill = true
    end

    
    if slasher:GetNWBool("CriminalCloning") then

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = v1 + FrameTime()

        if not slasher:GetNWBool("CriminalRage") then

            local speed = SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - ( v1 / (4 + SO))

            slasher:SetSlowWalkSpeed( speed )
            slasher:SetWalkSpeed( speed  )
            slasher:SetRunSpeed( speed  )
        else

            local speed = 25 + SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed - ( v1 / (5 + SO))

            slasher:SetSlowWalkSpeed( speed )
            slasher:SetWalkSpeed( speed  )
            slasher:SetRunSpeed( speed  )
        end

        SlashCo.CurRound.SlasherData[slasherid].Perception = 0
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 3

    else
        slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 0

        SlashCo.CurRound.SlasherData[slasherid].Perception = 1
        SlashCo.CurRound.SlasherData[slasherid].Eyesight = 6

    end

end
    ::FREESMILEY::
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 13 then goto BREN end
do

    v1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 --Summon Cooldown
    v2 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 --Selected Summon

    if v1 > 0 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = v1 - FrameTime() end



end
    ::BREN::

end

end)

SlashCo.ThirstyRage = function(ply)

    local pos = ply:GetPos()

    for i = 1, #team.GetPlayers(TEAM_SLASHER) do

        local slasherid = team.GetPlayers(TEAM_SLASHER)[i]:SteamID64()
        local slasher = team.GetPlayers(TEAM_SLASHER)[i]

        if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 5 then return end

        if slasher:GetPos():Distance( pos ) > 1600 then return end

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = 6
        slasher:SetNWBool("ThirstyBigMlik", true)

        for i = 1, #player.GetAll() do
            local ply = player.GetAll()[i]
            ply:SetNWBool("ThirstyFuck",true)
        end

        timer.Simple(3, function() 
        
            for i = 1, #player.GetAll() do
                local ply = player.GetAll()[i]
                ply:SetNWBool("ThirstyFuck",false)
            end
        
        end)

    end

end

SlashCo.SidRage = function(ply)

    local pos = ply:GetPos()

    for i = 1, #team.GetPlayers(TEAM_SLASHER) do

        local slasherid = team.GetPlayers(TEAM_SLASHER)[i]:SteamID64()
        local slasher = team.GetPlayers(TEAM_SLASHER)[i]

        if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 2 then return end

        if slasher:GetPos():Distance( pos ) > 1800 then return end

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 = SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 + 2

        PlayGlobalSound("slashco/slasher/sid_angry_"..math.random(1,4)..".mp3", 95, slasher, 1)

        for i = 1, #player.GetAll() do
            local ply = player.GetAll()[i]
            ply:SetNWBool("SidFuck",true)
        end

        timer.Simple(3, function() 
        
            for i = 1, #player.GetAll() do
                local ply = player.GetAll()[i]
                ply:SetNWBool("SidFuck",false)
            end

            PlayGlobalSound("slashco/slasher/sid_sad_1.mp3", 85, slasher, 1)
        
        end)

    end

end