local SlashCo = SlashCo

SlashCo.SlasherCallForChaseMode = function(slasher)

    local slasherid = slasher:SteamID64()

    local SO = SlashCo.CurRound.OfferingData.SO

    if slasher:GetNWBool("SidGunEquipped") then goto sidaim end

    if SlashCo.CurRound.SlasherData[slasherid].SlasherID == 12 then goto crimclone end
do
    if SlashCo.CurRound.SlasherData[slasherid].CanChase == false then return end

    if SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown > 0 then return end

    SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown = SlashCo.CurRound.SlasherData[slasherid].ChaseCooldown

    if slasher:GetNWBool("InSlasherChaseMode") then 

        slasher:SetNWBool("InSlasherChaseMode", false) 

        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:StopSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic)

        timer.Simple(0.25, function() slasher:StopSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic) end)

        return 
    end

    local dist = SlashCo.CurRound.SlasherData[slasherid].ChaseRange

    local find = ents.FindInCone( slasher:GetPos(), slasher:GetEyeTrace().Normal, dist, SlashCo.CurRound.SlasherData[slasherid].ChaseRadius )

    local target = NULL

    if slasher:GetEyeTrace().Entity:IsPlayer() and slasher:GetEyeTrace().Entity:Team() == TEAM_SURVIVOR and slasher:GetPos():Distance(slasher:GetEyeTrace().Entity:GetPos()) < dist then
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

    if not target:IsValid() then 
        return
    end

    local tr = util.TraceLine( {
        start = slasher:EyePos(),
        endpos = target:GetPos()+Vector(0,0,50),
        filter = slasher
    } )

    if tr.Entity ~= target then return end
end
    ::FOUND::

    if SlashCo.CurRound.SlasherData[slasherid].SlasherID == 9 then --Manspider Condition

        if target:SteamID64() ~= SlashCo.CurRound.SlasherData[slasherid].SlasherValue1 then return end

    end

    if slasher:GetPos():Distance(target:GetPos()) < dist then

        slasher:SetNWBool("InSlasherChaseMode", true)
        SlashCo.CurRound.SlasherData[slasherid].CurrentChaseTick = 0

        if SlashCo.CurRound.SlasherData[slasherid].SlasherID == 6 then SlashCo.CurRound.SlasherData[slasherid].SlasherValue2 = 0 end

    end

    local chase = slasher:GetNWBool("InSlasherChaseMode")

    if chase then 

        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed  )
        PlayGlobalSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic,95,slasher)

    else
        slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )
        slasher:StopSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic)
        timer.Simple(0.25, function() slasher:StopSound(SlashCo.CurRound.SlasherData[slasherid].ChaseMusic) end)
    end

end
    ::sidaim::
do
    if not slasher:GetNWBool("SidGunEquipped") then return end
    local gunrage = slasher:GetNWBool("SidGunRage")

    if not slasher:GetNWBool("SidGunAimed") and not slasher:GetNWBool("SidGunAiming") and SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 < 0.01 then

        slasher:SetNWBool("SidGunAiming", true)
        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 2
        slasher:SetSlowWalkSpeed( 1 )  
        slasher:SetWalkSpeed( 1 )
        slasher:SetRunSpeed( 1 )
        slasher:EmitSound("slashco/slasher/sid_draw.wav",75,110)

        timer.Simple(1, function() 

            slasher:SetNWBool("SidGunAiming", false)       
            slasher:SetNWBool("SidGunAimed", true)
            slasher:EmitSound("slashco/slasher/sid_clipout.wav")
            SlashCo.CurRound.SlasherData[slasherid].SlasherValue4 = 2

        end)

    elseif slasher:GetNWBool("SidGunAimed") and SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 < 0.01 then

        SlashCo.CurRound.SlasherData[slasherid].SlasherValue3 = 2
        slasher:SetNWBool("SidGunAiming", false)   
        slasher:SetNWBool("SidGunAimed", false) 
        slasher:SetSlowWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )  
        slasher:SetWalkSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed )

        if not gunrage then 
            slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ProwlSpeed ) 
        else
            slasher:SetRunSpeed( SlashCo.CurRound.SlasherData[slasherid].ChaseSpeed ) 
        end

    end
end
    ::crimclone::
do
    if SlashCo.CurRound.SlasherData[slasherid].SlasherID ~= 12 then return end

    if SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown > 0 then return end
    SlashCo.CurRound.SlasherData[slasherid].ChaseActivationCooldown = SlashCo.CurRound.SlasherData[slasherid].ChaseCooldown

    if slasher:GetNWBool("CriminalCloning") then

        for i = 1, #ents.FindByClass("sc_crimclone") do

            local cln = ents.FindByClass("sc_crimclone")[i]

            if cln.IsMain ~= true then cln:Remove() end
            cln:StopSound("slashco/slasher/criminal_loop.wav")	
            cln:StopSound("slashco/slasher/criminal_rage.wav")	

        end

        slasher:SetNWBool("CriminalCloning", false)
        slasher:SetNWBool("CriminalRage", false)

    else

        for i = 1, math.random(4+(SO * 3),6+(SO * 3)) do

            local clone = ents.Create( "sc_crimclone" )

            clone:SetPos( slasher:GetPos() )
            clone:SetAngles( slasher:GetAngles() )
            clone.AssignedSlasher = slasher:SteamID64()
            clone.IsMain = false
            clone:Spawn()
            clone:Activate()

        end

        slasher:SetNWBool("CriminalCloning", true)

    end
end

end