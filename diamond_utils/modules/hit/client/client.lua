local Busy = false

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local hash = args[7]
        if GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
            if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(victim)) then
                if hash ~= -1569615261 and hash ~= 133987706 then return end
                if Busy then return end
                Busy = true
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.3)
                SetPedMotionBlur(PlayerPedId(), true)
                ClearTimecycleModifier()
                SetTimecycleModifier("REDMIST_blend")
                SetTimecycleModifierStrength(0.7)
                SetExtraTimecycleModifier("fp_vig_red")
                SetExtraTimecycleModifierStrength(1.0)
                Citizen.Wait(200)
                StopGameplayCamShaking(false)
                SetPedMotionBlur(PlayerPedId(), false)
                ClearTimecycleModifier()
                ClearExtraTimecycleModifier()
                Busy = false
            end
        end
    end
end)

function GetPlayerByEntityID(id)
	for i=0,255 do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
	end
	return nil
end