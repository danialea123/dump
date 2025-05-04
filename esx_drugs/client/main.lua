---@diagnostic disable: undefined-global
Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
ESX = nil
local count = 0
local price = {}
LastZone                = nil
CurrentAction           = nil
CurrentActionMsg        = ''
CurrentActionData       = {}
HasAlreadyEnteredMarker = false
local menuOpen = false

_ClearPedTasks = ClearPedTasks
ClearPedTasks = function(...)
    ESX.UI.Menu.CloseAll()
    ESX.SetPlayerData('isSentenced', true)
    SetTimeout(6000, function()
        ESX.SetPlayerData('isSentenced', false)
    end)
    _ClearPedTasks(...)
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.TriggerServerCallback('getDrugPrices', function(data)
        price = data
    end)

    ESX.TriggerServerCallback('getDrugDealerPos', function(data)
        DealerPos = data
        Citizen.CreateThread(function()
            local model = Config.Bots[math.random(1, #Config.Bots)]
            
            RequestModel(model)
            
            while not HasModelLoaded(model) do
                Citizen.Wait(100)
            end
        
            math.randomseed(GetGameTimer())
            DealerPed = CreatePed(4, model, DealerPos.c.x, DealerPos.c.y, DealerPos.c.z, DealerPos.h)
            SetEntityAsMissionEntity(DealerPed)
            SetBlockingOfNonTemporaryEvents(DealerPed, true)
            Wait(100)
            FreezeEntityPosition(DealerPed, true)
            SetEntityInvincible(DealerPed, true)
            ClearPedTasks(DealerPed)
            TaskStartScenarioInPlace(DealerPed, "WORLD_HUMAN_SMOKING", 0, true)
            SetModelAsNoLongerNeeded(model)
        end)
        if DealerThread then DealerThread = DealerThread.remove() end
        RemoveBlip(DealerBlip)
        RemoveBlip(RadiusBlip)

        DealerBlip, RadiusBlip = CreateBlipCircle(DealerPos.c, "Drug Dealer", 1.0, 30, 355)
        DealerThread = RegisterPoint(DealerPos.c, 1.5, true)
        DealerThread.set('InAreaOnce', function ()
            TriggerEvent('esx_drugs:hasEnteredMarker', 'drug_dealer')
        end, function ()
            TriggerEvent('esx_drugs:hasExitMarker', 'drug_dealer')
        end)
    end)

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    Citizen.CreateThread(function()

        if Config.ShowBlips then
            for k,v in pairs(Config.FieldZones) do
                if v.special then
                    if v.special == ESX.PlayerData.gang.name then
                        CreateBlipCircle(v.coords, v.name, v.radius, v.color, v.sprite)
                    end
                else
                    CreateBlipCircle(v.coords, v.name, v.radius, v.color, v.sprite)
                end
            end
    
            for k,v in pairs(Config.ProcessZones) do
                CreateBlipCircle(v.coords, v.name, v.radius, v.color, v.sprite)
            end
        end
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)
    local blip2 = AddBlipForRadius(coords, radius)

    SetBlipHighDetail(blip2, true)
    SetBlipColour(blip2, 1)
    SetBlipAlpha (blip2, 128)
    SetBlipAsShortRange(blip2, true)

    -- create a blip in the middle
    local blip = AddBlipForCoord(coords)

    SetBlipHighDetail(blip, true)
    SetBlipSprite (blip, sprite)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)

    return blip, blip2
end

Citizen.CreateThread(function()
    for k,v in pairs(Config.Peds) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do
            Wait(1)
        end

        -- If the zone is for a dealer, render a PED
        local seller = CreatePed(1, v.ped, v.x, v.y, v.z, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(seller, true)
        SetPedDiesWhenInjured(seller, false)
        SetPedCanPlayAmbientAnims(seller, true)
        SetPedCanRagdollFromPlayerImpact(seller, false)
        SetEntityInvincible(seller, true)
        FreezeEntityPosition(seller, true)
        TaskStartScenarioInPlace(seller, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end
end)

RegisterNetEvent('esx_jk_drugs:useItem')
AddEventHandler('esx_jk_drugs:useItem', function(itemName)
    ESX.UI.Menu.CloseAll()

    if itemName == 'marijuana' then
        local lib, anim = 'amb@world_human_smoking_pot@male@base', 'base'
        local playerPed = PlayerPedId()

        ESX.Alert(_U('weed_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:onPot')
        end)

    elseif itemName == 'cocaine' then
        local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Alert(_U('cocaine_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:cokedOut')
        end)

    elseif itemName == 'meth' then
        local lib, anim = 'mp_weapons_deal_sting', 'crackhead_bag_loop' -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Alert(_U('meth_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:icedOut')
        end)

    elseif itemName == 'crack' then
        local lib, anim = 'mp_weapons_deal_sting', 'crackhead_bag_loop' -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Alert(_U('crack_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:crackedOut')
        end)

    elseif itemName == 'heroine' then
        local lib, anim = 'rcmpaparazzo1ig_4', 'miranda_shooting_up' -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Alert(_U('heroine_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:noddinOut')
        end)

    elseif itemName == 'drugtest' then
        local lib, anim = 'misscarsteal2peeing', 'peeing_intro'
        local playerPed = PlayerPedId()

        ESX.Alert(_U('drug_test'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:testing')
        end)

    elseif itemName == 'fakepee' then

        ESX.Alert(_U('fake_pee'))
        TriggerEvent('esx_jk_drugs:fakePee')

    elseif itemName == 'beer' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.Alert(_U('beer'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:buzzin')
        end)

    elseif itemName == 'tequila' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.Alert(_U('tequila'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:drunk')
        end)

    elseif itemName == 'vodka' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.Alert(_U('vodka'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:drunk')
        end)
    elseif itemName == 'whiskey' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.Alert(_U('whiskey'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:drunk')
        end)
    elseif itemName == 'breathalyzer' then

        ESX.Alert(_U('forced'))
        TriggerEvent('esx_jk_drugs:breathalyzer')
    end
end)

RegisterNetEvent('esx_drugs:Cartel')
AddEventHandler('esx_drugs:Cartel', function(itemName)
    ESX.TriggerServerCallback('esx_drugs:Cartel:use', function(removed)
        if removed then
            if itemName == 'desomorphine' then
                local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
                local playerPed = PlayerPedId()
                TriggerServerEvent("esx:usingDrugs")
                TriggerEvent("esx:DrugUsed")
                Citizen.Wait(150)
                ExecuteCommand("ooc Az Desomorphine Estefade Kard ^2[+50 Armor]")
                ESX.Alert('You smoked some desomorphine', "check")
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)
    
                    Citizen.Wait(500)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
    
                    local lastArmor = GetPedArmour(playerPed)
                    local incrArmor = 50
                    local newArmor = lastArmor + incrArmor
    
                    if newArmor > 100 then
                        incrArmor = incrArmor - (newArmor - 100)
                    end
    
                    ESX.SetPedArmour(playerPed, newArmor)
    
                    -- trigger event disable armour update
                    SetTimeout(1000*60*30, function()
                        local poolBack = GetPedArmour(PlayerPedId()) - incrArmor
                        -- trigger event enable armour update
                        ESX.SetPedArmour(PlayerPedId(), poolBack)
                    end)
                end)
            elseif itemName == 'proplus' then
                local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
                local playerPed = PlayerPedId()
                TriggerServerEvent("esx:usingDrugs")
                TriggerEvent("esx:DrugUsed")
                Citizen.Wait(150)
                ExecuteCommand("ooc Az ProPlus Estefade Kard ^2[No Recoil]")
                ESX.Alert('You put ProPlus on your tongue', "check")
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)
    
                    Citizen.Wait(500)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
    
                    TriggerEvent('weaponry:ReduceRecoil')
                end)
            elseif itemName == 'modafinil' then
                local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
                local playerPed = PlayerPedId()
                TriggerServerEvent("esx:usingDrugs")
                TriggerEvent("esx:DrugUsed")
                Citizen.Wait(150)
                ExecuteCommand("ooc Az Modafinil Estefade Kard ^2[Fast Run]")
                ESX.Alert("You put Modafinil on your tongue", "check")
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)
    
                    Citizen.Wait(500)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
    
                    Citizen.CreateThread(function()
                        local timer = true
                        SetTimeout(1000*20, function()
                            timer = false
                        end)
                        SetPedMoveRateOverride(PlayerId(), 10.0)
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                        while timer do
                            Citizen.Wait(0)
                            RestorePlayerStamina(PlayerPedId(), 1.0)
                        end
                        SetPedMoveRateOverride(PlayerId(), 0.0)
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    end)
                end)
            end
        else
            ESX.Alert('30 Daghighe CoolDown Baraye Estefade Az Har Ghors', "info")
        end
    end, itemName)
end)

RegisterNetEvent('esx_jk_drugs:onPot')
AddEventHandler('esx_jk_drugs:onPot', function()
    RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
    while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
    SetPedIsDrunk(PlayerPedId(), true)
    DoScreenFadeIn(1000)
    Citizen.Wait(600000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedIsDrunk(PlayerPedId(), false)
    SetPedMotionBlur(PlayerPedId(), false)
    ESX.Alert(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:cokedOut')
AddEventHandler('esx_jk_drugs:cokedOut', function()
    RequestAnimSet("move_m@hurry_butch@a")
    while not HasAnimSetLoaded("move_m@hurry_butch@a") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry_butch@a", true)
    SetPedRandomProps(PlayerPedId(), true)
    SetRunSprintMultiplierForPlayer(PlayerPedId(), 2.5)
    DoScreenFadeIn(1000)
    Citizen.Wait(300000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedRandomProps(PlayerPedId(), false)
    ClearAllPedProps(PlayerPedId(), true)
    SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.0)
    SetPedMotionBlur(PlayerPedId(), false)
    ESX.Alert(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:icedOut')
AddEventHandler('esx_jk_drugs:icedOut', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry_butch@b", true)
    DoScreenFadeIn(1000)
	repeat
		TaskJump(PlayerPedId(), false, true, false)
		Citizen.Wait(60000)
		count = count  + 1
	until count == 5
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
    ClearAllPedProps(PlayerPedId(), true)
    SetPedMotionBlur(PlayerPedId(), false)
    ESX.Alert(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:noddinOut')
AddEventHandler('esx_jk_drugs:noddinOut', function()
    RequestAnimSet("move_m@hurry_butch@c")
    while not HasAnimSetLoaded("move_m@hurry_butch@c") do
        Citizen.Wait(0)
    end
    onDrugs = true
    --DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry_butch@c", true)
    --DoScreenFadeIn(1000)
    repeat
		--DoScreenFadeOut(1000)
		SetPedToRagdoll(PlayerPedId(), 5000, 0, 0, false, false, false)
		Citizen.Wait(5000)
		--DoScreenFadeIn(1000)
		count = count + 1
	until count == 5
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedMotionBlur(PlayerPedId(), false)
    ESX.Alert(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:buzzin')
AddEventHandler('esx_jk_drugs:buzzin', function()
    RequestAnimSet("move_m@buzzed")
    while not HasAnimSetLoaded("move_m@buzzed") do
        Citizen.Wait(0)
    end
    onBeer = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@buzzed", true)
    DoScreenFadeIn(1000)
    Citizen.Wait(150000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedMotionBlur(PlayerPedId(), false)
    ESX.Alert(_U('wearin_off'))
    onBeer = false

end)

RegisterNetEvent('esx_jk_drugs:drunk')
AddEventHandler('esx_jk_drugs:drunk', function()
    RequestAnimSet("move_m@drunk@moderatedrunk")
    while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
    end
    onLiquor = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@moderatedrunk", true)
    SetPedIsDrunk(PlayerPedId(), true)
    DoScreenFadeIn(1000)
    Citizen.Wait(600000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedMotionBlur(PlayerPedId(), false)
    SetPedIsDrunk(PlayerPedId(), false)
    ESX.Alert(_U('wearin_off'))
    onLiquor = false

end)

RegisterNetEvent('esx_jk_drugs:testing')
AddEventHandler('esx_jk_drugs:testing', function()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    if onDrugs then
        ESX.Alert(_U('drug_fail'))
        TriggerServerEvent('esx_jk_drugs:testResultsFail')
    else
        ESX.Alert(_U('drug_pass'))
        TriggerServerEvent('esx_jk_drugs:testResultsPass')
    end
end)

RegisterNetEvent('esx_jk_drugs:fakePee')
AddEventHandler('esx_jk_drugs:fakePee', function()
    local wasDrugged = false
    if onDrugs then
        ESX.Alert(_U('fake_clean'))
        wasDrugged = true
        onDrugs = false
    else
        ESX.Alert(_U('not_needed'))
    end
    Citizen.Wait(60000)
    if wasDrugged then
        onDrugs = true
    end
end)

RegisterNetEvent('esx_jk_drugs:breathalyzer')
AddEventHandler('esx_jk_drugs:breathalyzer', function()

    if onBeer then
        ESX.Alert(_U('fail_tipsy'))
        TriggerServerEvent('esx_jk_drugs:testResultsFailTipsy')
    elseif onLiquor then
        ESX.Alert(_U('fail_drunk'))
        TriggerServerEvent('esx_jk_drugs:testResultsFailDrunk')
    else
        ESX.Alert(_U('bca_pass'))
        TriggerServerEvent('esx_jk_drugs:testResultsPassBCA')
    end
end)

RegisterNetEvent('esx_jk_drugs:crackedOut')
AddEventHandler('esx_jk_drugs:crackedOut', function()
    RequestAnimSet("move_m@hurry_butch@a")
    while not HasAnimSetLoaded("move_m@hurry_butch@a") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry_butch@a", true)
    SetPedRandomProps(PlayerPedId(), true)
    SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.49)
    DoScreenFadeIn(1000)
   repeat
		TaskJump(PlayerPedId(), false, true, false)
		Citizen.Wait(60000)
		count = count  + 1
	until count == 5
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedRandomProps(PlayerPedId(), false)
    ClearAllPedProps(PlayerPedId(), true)
    SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.0)
    SetPedMotionBlur(PlayerPedId(), false)
    ESX.Alert(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:selling')
AddEventHandler('esx_jk_drugs:selling', function()

    local playerPed = PlayerPedId()
    PedPosition        = GetEntityCoords(playerPed)
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local streetName, crossing = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local streetName, crossing = GetStreetNameAtCoord(x, y, z)
    streetName = GetStreetNameFromHashKey(streetName)
    crossing = GetStreetNameFromHashKey(crossing)
	
	if Config.UseESXPhone then
        if crossing ~= nil then

            local coords      = GetEntityCoords(PlayerPedId())

            TriggerServerEvent('esx_phone:send', "police", "Some shady prick is selling drugs on " .. streetName .. " and " .. crossing, true, {
                x = coords.x,
                y = coords.y,
                z = coords.z
            })
        else
            TriggerServerEvent('esx_phone:send', "police", "Some shady prick is selling drugs on " .. streetName, true, {
                x = coords.x,
                y = coords.y,
                z = coords.z
            })
        end
    elseif Config.UseGCPhone then
        if crossing ~= nil then
            local coords      = GetEntityCoords(PlayerPedId())

            TriggerServerEvent('esx_addons_gcphone:startCall', 'police', "Some shady prick is selling drugs on " .. streetName .. " and " .. crossing, PlayerCoords, {
                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
            })
        else
            TriggerServerEvent('esx_addons_gcphone:startCall', "police", "Some shady prick is selling drugs on " .. streetName, PlayerCoords, {
                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
            })
        end
    else
		TriggerServerEvent('esx_jk_drugs:policeAlert')
	end
end)

-- Give Cops access to test kits

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)	
--         if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
        
--             local coords = GetEntityCoords(PlayerPedId())

--             if f(coords, 479.94, -1008.36, 34.23, true) < 15 then
--                 DrawMarker(21, 479.94, -1008.36, 34.23, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 50, 50, 204, 100, true, true, 2, false, false, false, false)
--             end
        
--             if f(coords, 479.94, -1008.36, 34.23, true) < 1 then
--                 ESX.Alert("You grabbed some test kits")
--                 TriggerServerEvent('esx_jk_drugs:giveItem1234556', 'drugtest')
--                 TriggerServerEvent('esx_jk_drugs:giveItem1234556', 'breathalyzer')
--                 Citizen.Wait(10000)
--             end
--         end
--     end
-- end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        local Interact
        local Point = RegisterPoint(vector3(v.Pos.x, v.Pos.y, v.Pos.z), Config.DrawDistance, true)
        Point.set('InArea', function ()
            DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end)
        Point.set('InAreaOnce', function ()
            Interact = RegisterPoint(vector3(v.Pos.x, v.Pos.y, v.Pos.z), v.Size.x, true)
            Interact.set('InAreaOnce', function ()
                TriggerEvent('esx_drugs:hasEnteredMarker', k)
            end, function ()
                TriggerEvent('esx_drugs:hasExitMarker', k)
            end)
        end, function ()
            if Interact then
                Interact = Interact.remove()
            end
        end)
    end
end)

AddEventHandler('esx_drugs:hasEnteredMarker', function(zone)
    if zone == 'drug_dealer' then
		CurrentAction     = 'drug_dealer'
		CurrentActionMsg  = _U('dealer_prompt')
		CurrentActionData = {}
    elseif zone == "drug_1" then
		CurrentAction     = 'crack_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Crack ~w~besazid'
		CurrentActionData = {}
	elseif zone == "drug_2" then
		CurrentAction     = 'cocke_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Cocaine ~w~besazid'
		CurrentActionData = {}
    elseif zone == "drug_3" then
		CurrentAction     = 'ephedrine_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Ephedrine ~w~besazid'
        CurrentActionData = {}
    elseif zone == "drug_4" then
		CurrentAction     = 'meth_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Shishe ~w~besazid'
        CurrentActionData = {}
	end
    Hint:Create(CurrentActionMsg)
end)

-- Kharej shodan az marker coke
AddEventHandler('esx_drugs:hasExitMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
    Hint:Delete()
end)

RegisterKey('E', false, function ()
    if not CurrentAction then
        return
    end
    if CurrentAction == 'drug_dealer' then
        OpenDrugShop()
    elseif CurrentAction == 'cocke_menu' then
        ESX.DoesHaveItem('coca', 5, function()
            SetEntityHeading(PlayerPedId(), 332.93)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_cocaine",
                duration = 7000,
                label = "Dar hale sakhtane Cocaine",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processCocaPlant')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end, 'Tokhmn Cocaine')

    elseif CurrentAction == 'crack_menu' then
        
        ESX.DoesHaveItem('cocaine', 2, function()
            SetEntityHeading(PlayerPedId(), 161.77)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_crack",
                duration = 14000,
                label = "Dar hale sakhtane Crack",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processCoke')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end)
    
    elseif CurrentAction == "marijuana_menu" then
        ESX.DoesHaveItem('cannabis', 5, function()
        
            SetEntityHeading(PlayerPedId(), 150.32)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_marijuana",
                duration = 10000,
                label = "Dar hale sakhtane Marijuana",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processCannabis')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end, 'Barge Shahdane')

    elseif CurrentAction == "ephedrine_menu" then
        ESX.DoesHaveItem('ephedra', 5, function()
            
            SetEntityHeading(PlayerPedId(), 216.87)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_ephedrine",
                duration = 10000,
                label = "Dar hale sakhtane Ephedrine",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processEphedra')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end)

    elseif CurrentAction == "poppy_menu" then
        ESX.DoesHaveItem('poppy', 5, function()
            
            SetEntityHeading(PlayerPedId(), 164.56)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_opium",
                duration = 10000,
                label = "Dar hale sakhtane Teryak",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processPoppy')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end, 'Khash-Khaash')

    elseif CurrentAction == "opium_menu" then
        ESX.DoesHaveItem('opium', 10, function()
            
            SetEntityHeading(PlayerPedId(), 295.5)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_opium",
                duration = 20000,
                label = "Dar hale sakhtane Heroine",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processOpium')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end, 'Teryak')
        
    elseif CurrentAction == "meth_menu" then
        ESX.DoesHaveItem('ephedrine', 10, function()
            
            SetEntityHeading(PlayerPedId(), 108.86)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_meth",
                duration = 20000,
                label = "Dar hale sakhtane Shishe",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@idle_a",
                    anim = "idle_a",
                    }
            }, function(status)
                if not status then

                    TriggerServerEvent('esx_jk_drugs:processEphedrine')
        
                elseif status then

                    ClearPedTasksImmediately(playerPed)

                end
            end)
        end)

    end
end)

RegisterNetEvent('esx_jk_drugs:getPrice')
AddEventHandler('esx_jk_drugs:getPrice', function(data)
    price = data
end)

RegisterNetEvent('esx_jk_drugs:getDrugDealerPos')
AddEventHandler('esx_jk_drugs:getDrugDealerPos', function(data)
    DealerPos = data
    ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'drug_shop')
    if DealerThread then 
        TriggerEvent('esx_drugs:hasExitMarker', 'drug_dealer')
        DealerThread = DealerThread.remove() 
    end
    RemoveBlip(DealerBlip)
    RemoveBlip(RadiusBlip)
    DeleteEntity(DealerPed)

    DealerBlip, RadiusBlip = CreateBlipCircle(DealerPos.c, "Drug Dealer", 1.0, 30, 355)
    DealerThread = RegisterPoint(DealerPos.c, 1.5, true)
    DealerThread.set('InAreaOnce', function ()
        TriggerEvent('esx_drugs:hasEnteredMarker', 'drug_dealer')
    end, function ()
        TriggerEvent('esx_drugs:hasExitMarker', 'drug_dealer')
    end)

    Citizen.CreateThread(function()
        local model = Config.Bots[math.random(1, #Config.Bots)]
        
        RequestModel(model)
        
        while not HasModelLoaded(model) do
            Citizen.Wait(100)
        end
    
        math.randomseed(GetGameTimer())
        DealerPed = CreatePed(4, model, DealerPos.c.x, DealerPos.c.y, DealerPos.c.z, DealerPos.h)
        SetEntityAsMissionEntity(DealerPed)
        SetBlockingOfNonTemporaryEvents(DealerPed, true)
        Wait(100)
        FreezeEntityPosition(DealerPed, true)
        SetEntityInvincible(DealerPed, true)
        _ClearPedTasks(DealerPed)
        TaskStartScenarioInPlace(DealerPed, "WORLD_HUMAN_SMOKING", 0, true)
        SetModelAsNoLongerNeeded(model)
    end)
end)

function OpenDrugShop(sold)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

    for k, v in pairs(ESX.GetPlayerData().inventory) do
        for c,d in ipairs(price) do
            if (v.name == d.name) and (v.name ~= sold) then
                if d.price and v.count > 0 then
                    table.insert(elements, {
                        label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(d.price*v.count))),
                        name = v.name,
                    })
                end
            end
        end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        TriggerServerEvent('esx_drugs:sellDrug', data.current.name)
        menu.close()
        Citizen.Wait(500)
        OpenDrugShop(data.current.name)
	end, function(data, menu)
		menu.close()
		menuOpen = false
    end, function()
    end,
    function()
        menuOpen = false
    end)
end