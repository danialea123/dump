exports('GetClosetStat',function()
    local id,dist = GetClosestPlayer()

    if id ~= -1 and dist ~= -1 then
        if dist < 3.0 then
            local serverid = GetPlayerServerId(id)
            TriggerServerEvent("GetDiagnosis", serverid)
        end
    end
end)

function Close()
    if opened then
        TriggerEvent("CloseNui")
    end
end

AddEventHandler('onKeyUP', function(key)
    if key == "back" or key == "escape" then
        Close()
    end
end)

-- Open Nui
RegisterNetEvent("OpenBodyDamage")
AddEventHandler("OpenBodyDamage", function(m_body, m_body_model, m_punch, m_shots, m_cuts, m_bruises, m_cause_death)
    opened = true
    SendNUIMessage({
        NuiOpen = true,
        conditions_m = m_body,
        scale = scale, x = pos_x, y = pos_y,
        body = m_body_model,
        cause_death = m_cause_death,
        punch = m_punch, shots = m_shots, cuts = m_cuts, bruises = m_bruises,
        texts_nui = texts_nui,
    }) 
end)

-- Get information from another player
RegisterNetEvent("PassDiagnosis")
AddEventHandler("PassDiagnosis", function()
    TriggerServerEvent("PassDiagnosis", body, GetModel(), punch, shots, cuts, bruises, cause_death)
end)

-- Closes the NUI
RegisterNetEvent("CloseNui")
AddEventHandler("CloseNui", function()
    opened = false
    SendNUIMessage({
        NuiOpen = false,
    })
end)

CreateThread(function()
    local prev_health = max_health
    while true do
        if opened then
            if IsPauseMenuActive() then
                TriggerEvent("CloseNui")
            end
        end

        local ped = PlayerPedId()
        local bool, bone = GetPedLastDamageBone(ped)
        local body_id = string.format("%x", bone)
        local dead = nil

        local player = PlayerId()
        SetPlayerHealthRechargeMultiplier(player, 0.0)

        ClearEntityLastWeaponDamage(ped)
        ClearPedLastWeaponDamage(ped)
        ClearPedLastDamageBone(ped)

        if IsPedDeadOrDying(ped) or IsEntityDead(ped) then
            dead = GetPedCauseOfDeath(ped)
        end

        local health = GetEntityHealth(ped)
        if health < prev_health then
            if body_id ~= 0 then
                for i, k in pairs(body) do
                    if i == body_id then
                        k.bruised = true
                        bruises = bruises + 1

                        for a,b in pairs(weapon_list) do
                            if HasPedBeenDamagedByWeapon(ped, b.name) then
                                if a ~= 0 then
                                    if a >= 19 then
                                        k.shots = true
                                        shots = shots + 1
                                    elseif a > 2 and a < 19 then
                                        k.cuts = true 
                                        cuts = cuts + 1
                                    elseif a <= 2 then
                                        k.punch = true
                                        punch = punch + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if dead then
                local res_death = false

                for a,b in pairs(weapon_list) do
                    if HasPedBeenDamagedByWeapon(ped, b.name) then
                        if a ~= 0 then
                            if a >= 19 then
                                if shots >= 4 then
                                    cause_death = text_death_shots .. " " .. text_dead
                                else
                                    cause_death = text_death_shots
                                end
                            elseif a > 2 and a < 19 then
                                if cuts >= 4 then
                                    cause_death = text_death_cuts .. " " .. text_dead
                                else
                                    cause_death = text_death_cuts
                                end
                            elseif a <= 2 then
                                cause_death = text_death_punch
                            end
                            res_death = true
                        end
                    end
                end
        
                local random_reason_death = math.random(1,5)
                for i, k in pairs(reasons_death) do
                    if dead == k.death then
                        if random_reason_death == 3 then
                            cause_death = k.reason .. " " .. text_dead
                        else
                            cause_death = k.reason
                        end
                        res_death = true

                        if k.all_bruises ~= nil and k.all_bruises then
                            for h,j in pairs(body) do
                                j.bruised = true 
                                bruises = bruises + 1
                            end
                        end
                    end
                end

                if not res_death then
                    cause_death = "Unknown death"
                end

                -- Automatically
                if OpenClose_nui_automatically then
                    SetTimeout(250, function()
                        TriggerEvent("OpenBodyDamage", body, GetModel(), punch, shots, cuts, bruises, cause_death)
                    end)
                end

                if notify_attacker then
                    SetTimeout(500, function()
                        NotifyAttacker()
                    end)
                end
            end
        elseif health >= max_health and health > prev_health then
            for i,k in pairs(body) do
                k.bruised = false 
                k.shots = false 
                k.punch = false
                k.cuts = false 
            end

            punch = 0
            shots = 0
            cuts = 0
            bruises = 0
            cause_death = ''

            if opened and OpenClose_nui_automatically then
                TriggerEvent("CloseNui")
            end
        end
        prev_health = health

        Wait(500)
    end
end)

-- function NotifyAttacker()
--     local ped = GetPlayerPed(-1)

--     local attacker = GetPedKiller(ped)  
--     local ped_attacker = 0

--     for id = 0, 255 do
--         if NetworkIsPlayerActive(id) and NetworkIsPlayerConnected(id) then
--             local player = GetPlayerFromServerId(GetPlayerServerId(id))
--             local ped_player = GetPlayerPed(player)

--             if IsPedAPlayer(ped_player) then
--                 if attacker == ped_player and attacker ~= ped then
--                     ped_attacker = GetPlayerServerId(player)

--                     TriggerServerEvent("Mx :: PassDiagnosis", ped_attacker, body, GetModel(), punch, shots, cuts, bruises, cause_death)

--                     break
--                 end
--             end
--         end
--     end
-- end