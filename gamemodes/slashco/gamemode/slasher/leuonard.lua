SlashCoSlasher.Leuonard = {}

SlashCoSlasher.Leuonard.Name = "Leuonard"
SlashCoSlasher.Leuonard.ID = 14
SlashCoSlasher.Leuonard.Class = 2
SlashCoSlasher.Leuonard.DangerLevel = 3
SlashCoSlasher.Leuonard.IsSelectable = true
SlashCoSlasher.Leuonard.Model = "models/slashco/slashers/leuonard/leuonard.mdl"
SlashCoSlasher.Leuonard.GasCanMod = 0
SlashCoSlasher.Leuonard.KillDelay = 2
SlashCoSlasher.Leuonard.ProwlSpeed = 150
SlashCoSlasher.Leuonard.ChaseSpeed = 290
SlashCoSlasher.Leuonard.Perception = 1.0
SlashCoSlasher.Leuonard.Eyesight = 5
SlashCoSlasher.Leuonard.KillDistance = 150
SlashCoSlasher.Leuonard.ChaseRange = 900
SlashCoSlasher.Leuonard.ChaseRadius = 0.86
SlashCoSlasher.Leuonard.ChaseDuration = 5.0
SlashCoSlasher.Leuonard.ChaseCooldown = 4
SlashCoSlasher.Leuonard.JumpscareDuration = 2
SlashCoSlasher.Leuonard.ChaseMusic = "slashco/slasher/leuonard_chase.mp3"
SlashCoSlasher.Leuonard.KillSound = "slashco/slasher/"
SlashCoSlasher.Leuonard.Description = "The Horny Slasher which rapes.\n\n-Leuonard's Rape will increase over time.\n-He must fuck a dog to decrease Rape.\n-Reaching 100% Rape will cause Leuonard to become powerful, but hard to control."
SlashCoSlasher.Leuonard.ProTip = "-This Slasher seems to have a fondness for dogs."
SlashCoSlasher.Leuonard.SpeedRating = "★★★★☆"
SlashCoSlasher.Leuonard.EyeRating = "★★★☆☆"
SlashCoSlasher.Leuonard.DiffRating = "★★★★☆"

SlashCoSlasher.Leuonard.OnSpawn = function(slasher)
    SlashCo.CreateItem("sc_dogg", SlashCo.TraceHullLocator(), Angle(0,0,0))
    slasher.soundon = 0
    slasher:SetNWBool("CanKill", true)
    slasher:SetNWBool("CanChase", true)
end

SlashCoSlasher.Leuonard.PickUpAttempt = function(ply)
    return false
end

SlashCoSlasher.Leuonard.OnTickBehaviour = function(slasher)

    v1 = slasher.SlasherValue1 --Rape
    v2 = slasher.SlasherValue2 --Tick to change mouse drift
    v3 = slasher.SlasherValue3 --Tick to move mouse

    if slasher.MouseDrift == nil then

        slasher.MouseDrift = Vector(0,0,0)

    end

    if v1 < 100 then
        if not slasher:GetNWBool("LeuonardRaping") then

            slasher.SlasherValue1 = v1 + ( FrameTime() * 0.5)

            --sound

            if math.floor(slasher.SlasherValue1) == 25 and slasher.soundon == 0 then
                slasher:EmitSound("slashco/slasher/leuonard_25_"..math.random(1,3)..".mp3")
                slasher.soundon = 1
            end

            if math.floor(slasher.SlasherValue1) == 50 and slasher.soundon == 1 then
                slasher:EmitSound("slashco/slasher/leuonard_50_"..math.random(1,3)..".mp3")
                slasher.soundon = 2
            end

            if math.floor(slasher.SlasherValue1) == 90 and slasher.soundon == 2 then
                slasher:EmitSound("slashco/slasher/leuonard_90_"..math.random(1,3)..".mp3")
                slasher.soundon = 3
            end

            --LOCATE THE DOG..........

            local find = ents.FindInSphere(slasher:GetPos(), 80)

            for f = 1, #find do
                local ent = find[f]

                if ent:GetClass() == "sc_dogg" then --I FOUND YOU........
                    slasher.soundon = 0
                    ent:Remove()
                    slasher:SetNWBool("LeuonardRaping", true)
                    slasher:EmitSound("slashco/slasher/leuonard_yell1.mp3")
                    slasher:Freeze(true)
                    timer.Simple(4, function() 
                        slasher:EmitSound("slashco/slasher/leuonard_grunt_loop.wav")
                        slasher:SetPlaybackRate(5)
                    end)
                end

            end

        else
            if v1 > 0 then
                slasher.SlasherValue1 = v1 - ( FrameTime() * 2)
                slasher:SetBodygroup(1,1)
            else
                slasher:SetNWBool("LeuonardRaping", false)
                slasher:SetBodygroup(1,0)
                slasher:Freeze(false)

                SlashCo.CreateItem("sc_dogg", SlashCo.TraceHullLocator(), Angle(0,0,0))

                slasher:StopSound("slashco/slasher/leuonard_grunt_loop.wav")
                slasher:EmitSound("slashco/slasher/leuonard_grunt_finish.mp3")

            end
        end
    else

        slasher.SlasherValue1 = 100.25
        slasher:SetNWBool("LeuonardFullRape", true)

        slasher:SetNWBool("CanKill", false)
        slasher:SetNWBool("CanChase", false)

    end

    if v1 == 100.25 then --100% bad word n stuff

        slasher.soundon = 0

        slasher:SetWalkSpeed(450)
        slasher:SetRunSpeed(450)

        if v2 < 0 then
            slasher.MouseDrift = Vector(math.random(-10,10),math.random(-10,10),0)
            slasher.SlasherValue2 = 2 + (math.random() * 2)

            slasher:EmitSound("slashco/slasher/leuonard_yell"..math.random(1,7)..".mp3")
        end

        slasher.SlasherValue2 = slasher.SlasherValue2 - FrameTime()
        slasher.SlasherValue3 = v3 + 1

        if slasher.SlasherValue3 > 1 then
            slasher.SlasherValue3 = 0
            slasher:SetEyeAngles( Angle( slasher:EyeAngles()[1] + (slasher.MouseDrift[1]/5), slasher:EyeAngles()[2] + (slasher.MouseDrift[2]/2), 0 ) )
        end

        local lol = math.random(0,1)

        slasher:SetVelocity( Vector(slasher.MouseDrift[1+lol] * 6,slasher.MouseDrift[2-lol] * 6,0) )

        local find = ents.FindInSphere(slasher:GetPos(), 80)

        for i = 1, #find do
            local ent = find[i]

            if ent:GetClass() == "prop_door_rotating" then
                SlashCo.BustDoor(slasher, ent, 25000)
            end

            if ent:IsPlayer() and ent ~= slasher then
                ent:SetVelocity( slasher:GetForward() * 300 )
                timer.Simple(0.05, function() ent:Kill() end)
            end

        end

    end

    slasher:SetNWInt("LeuonardRape", math.floor( v1 ))

    slasher:SetNWFloat("Slasher_Eyesight", SlashCoSlasher.Leuonard.Eyesight)
    slasher:SetNWInt("Slasher_Perception", SlashCoSlasher.Leuonard.Perception)
end

SlashCoSlasher.Leuonard.OnPrimaryFire = function(slasher)
    SlashCo.Jumpscare(slasher)
end

SlashCoSlasher.Leuonard.OnSecondaryFire = function(slasher)
    SlashCo.StartChaseMode(slasher)
end

SlashCoSlasher.Leuonard.OnMainAbilityFire = function(slasher)

end


SlashCoSlasher.Leuonard.OnSpecialAbilityFire = function(slasher)

end

SlashCoSlasher.Leuonard.Animator = function(ply) 

    local chase = ply:GetNWBool("InSlasherChaseMode")

    if not chase then 
		ply.CalcIdeal = ACT_HL2MP_WALK 
		ply.CalcSeqOverride = ply:LookupSequence("walk")
	else
		ply.CalcIdeal = ACT_HL2MP_RUN 
		ply.CalcSeqOverride = ply:LookupSequence("chase")
	end

	if ply:GetNWBool("LeuonardFullRape") then
		ply.CalcIdeal = ACT_HL2MP_RUN 
		ply.CalcSeqOverride = ply:LookupSequence("specialrun")
	end

	if ply:GetVelocity():Length() < 2 then
		ply.CalcIdeal = ACT_HL2MP_IDLE 
		ply.CalcSeqOverride = ply:LookupSequence("ragdoll")
	end

	if ply:GetNWBool("LeuonardRaping") then
		ply.CalcSeqOverride = ply:LookupSequence("mondaynightraw")
	end

    return ply.CalcIdeal, ply.CalcSeqOverride

end

SlashCoSlasher.Leuonard.Footstep = function(ply)

    if SERVER then
        ply:EmitSound( "slashco/slasher/leuonard_step"..math.random(1,3)..".mp3")
        return true 
    end

    if CLIENT then
		return true 
    end

end

if CLIENT then

    hook.Add("HUDPaint", SlashCoSlasher.Leuonard.Name.."_Jumpscare", function()

        if LocalPlayer():GetNWBool("SurvivorJumpscare_Leuonard") == true  then


            
        end

    end)

    SlashCoSlasher.Leuonard.UserInterface = function(cx, cy, mainiconposx, mainiconposy)

        local willdrawkill = true
        local willdrawchase = true
        local willdrawmain = true

        surface.SetDrawColor( 0, 0, 0)
        surface.DrawRect( cx-200, cy +ScrH()/4, 400, 25 )

        local b_pad = 6

        local rape_val = LocalPlayer():GetNWInt("LeuonardRape")

        surface.SetDrawColor( 255, 0, 0)
        surface.DrawRect( cx-200+(b_pad/2),(b_pad/2)+cy +ScrH()/4, (400-b_pad)*(rape_val/100), 25-b_pad )

        draw.SimpleText( "RAPE", "ItemFontTip", cx-300, cy +ScrH()/4 , Color( 255, 0, 0, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_RIGHT ) 
        draw.SimpleText( math.floor(rape_val).." %", "ItemFontTip", cx+220, cy +ScrH()/4 , Color( 255, 0, 0, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_RIGHT ) 

        return willdrawkill, willdrawchase, willdrawmain

    end

    SlashCoSlasher.Leuonard.ClientSideEffect = function()

    end

end