ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local isGunGameDisplayed = false;
local isDisableControls = false;
local isWinnerCamera = false;
local isInGunGame = false;
local isCurrentWeapon = nil;


if Config.Blips  then
    local blipTimeout = 5000;
    Citizen.CreateThread(function()
        local blips = {}
        while true do
            if isInGunGame then
                blipTimeout = 0;
                for _,v in pairs(GetActivePlayers()) do
                    local playerPed = GetPlayerPed(v)
                    local playerName = GetPlayerName(NetworkGetPlayerIndexFromPed(playerPed))
                    if playerPed ~= PlayerPedId() then
                        RemoveBlip(blips[v])
                        local blip = AddBlipForEntity(playerPed)
                        SetBlipNameToPlayerName(blip, playerName)
                        SetBlipSprite(blip, 303)
                        SetBlipColour(blip, 1)
                        SetBlipScale(blip, 0.6)
                        SetBlipAsShortRange(blip, true)
                        blips[v] = blip;
                    end
                end
            else
                if blipTimeout > 5000 and not isInGunGame then
                    blipTimeout = 5000;
                end
                for k, v in pairs(blips) do
                    RemoveBlip(v)
                    blips[k] = nil
                end
            end
            Wait(blipTimeout)
        end
    end)
end

RegisterNetEvent("esx:GunGameStart")
AddEventHandler("esx:GunGameStart", function(Map)
    if GetInvokingResource() then return end
    isInGunGame = true
    currentMap = Map
    TriggerEvent("capture:inCapture", true)
    exports.esx_manager:setException(true)
    RemoveAllPedWeapons(PlayerPedId(), false)
    inGame = true
    ESX.Alert("/leave baraye khoruj az gungame", "info")
end)

AddEventHandler("esx:onPlayerDeath", function(data)
    if not inGame then return end
    DoScreenFadeOut(200)
    TriggerServerEvent("GunGame:Death", data.killer)
    Wait(1000)
    DoScreenFadeIn(600)
end)

Citizen.CreateThread(function()
    while true do
        if isGunGameDisplayed then
            DisplayRadar(false)
            DisableAllControlActions(0)
        else
            DisplayRadar(true)
        end
        if isDisableControls then
            DisableAllControlActions(0)
        end
        Wait(0)
    end
end)

RegisterNetEvent("GunGame:DisableControls", function(bool)
    isDisableControls = bool;
end)

RegisterNetEvent("GunGame:StartCountDown", function(time, bool)
    isCountdownDisplayed = bool
    if isCountdownDisplayed then
        SendNUIMessage({
            action = "showCountdown",
            countDown = time,
        })
    else
        SendNUIMessage({
            action = "hideCountdown",
        })
        isDisableControls = false;
    end
end)

RegisterNetEvent("GunGame:UpdateTimer", function(time)
    if isCountdownDisplayed then
        SendNUIMessage({
            action = "updateCountDown",
            countDown = time,
        })
    end
end)

RegisterNetEvent("GunGame:KillLeadersUI", function(bool, first, second, third, firstKills, secondKills, thirdKills)
    if bool then
        SendNUIMessage({action = "showKillLeaders",first = first,second = second,third = third,firstKills = firstKills,secondKills = secondKills,thirdKills = thirdKills,})
    else
        SendNUIMessage({
            action = "HideKillLeaders",
        })
    end
end)

RegisterNetEvent("GunGame:WinnerCamera", function(firstName, firstKills, src, winner)
    isGunGameDisplayed = not isGunGameDisplayed
    SendNUIMessage({action = "hideAllUIs"})
    local playerIdx = GetPlayerFromServerId(src)
    local ped = GetPlayerPed(playerIdx)
    print(Config.Cards[math.random(1, #Config.Cards)].path)
    if isGunGameDisplayed then
        SendNUIMessage({
            action = "showGunGameWinner",
            firstName = firstName,
            firstKills = firstKills,
            calling = Config.Cards[math.random(1, #Config.Cards)].path,
        })
        isWinnerCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA')
        local coordsCam = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.5)
        local coordsPly = GetEntityCoords(ped)
        SetCamCoord(isWinnerCamera, coordsCam)
        PointCamAtCoord(isWinnerCamera, coordsPly['x'], coordsPly['y'], coordsPly['z'] + 0.2)
        SetCamActive(isWinnerCamera, true)
        RenderScriptCams(true, true, 500, true, true)
        if winner then
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GUARD_STAND", 0, true)
        end
        if not HasNamedPtfxAssetLoaded(Config.EffectDict) then
            RequestNamedPtfxAsset(Config.EffectDict)
            while not HasNamedPtfxAssetLoaded(Config.EffectDict) do
                Wait(10)
            end
        end
        SetParticleFxNonLoopedColour(1.0, 0.0, 0.0)
        local CurrentPlayerCoords = GetEntityCoords(ped)
        local a = 0
        while a < 25 do
            UseParticleFxAssetNextCall(Config.EffectDict)
            StartParticleFxNonLoopedAtCoord(Config.particleName, CurrentPlayerCoords[1], CurrentPlayerCoords[2] - 0.6, CurrentPlayerCoords[3], 0.0, 0.0, 0.0, 0.2, false, false, false)
            a = a + 1
            Citizen.Wait(500)
        end
        RemoveNamedPtfxAsset(Config.EffectDict) 
    else
        SendNUIMessage({
            action = "hideGunGameWinner",
        })
        RenderScriptCams(false, false, 0, 1, 0)
        SetCamActive(isWinnerCamera, false)
        DestroyCam(isWinnerCamera, true)
        isGunGameDisplayed = false; 
    end
end)

RegisterNetEvent("GunGame:SetEntityCoord", function(coord)
    print(coord.x, coord.y, coord.z)
    ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)
end)

RegisterNetEvent("GunGame:End", function()
    isInGunGame = false
    currentMap = nil
    TriggerEvent("capture:inCapture", false)
    exports.esx_manager:setException(false)
    RemoveAllPedWeapons(PlayerPedId(), false)
    inGame = false
    Citizen.Wait(5000)
    TriggerEvent('esx:restoreLoadout')
    isInGunGame = false
end)

RegisterNetEvent("GunGame:SetEntityHealth", function(amount, isRevive, isArmour)
    local ped = PlayerPedId()
    if isArmour then
        ESX.SetPedArmour(ped, 100)
    end
    if isRevive then
        local coord = GetEntityCoords(PlayerPedId())
        ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)
        NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
        ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)
    else
        ESX.SetEntityHealth(ped, amount)
    end
end)

RegisterNetEvent("GunGame:PlayScreenEffect", function(stop, name)
    if stop then 
        StopScreenEffect(name)
    else
        StartScreenEffect(name, 0, true)
    end
end)

RegisterNetEvent("GunGame:DisplayNotification", function(isMessage)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(isMessage)
    DrawNotification(true, false)
end)

RegisterNetEvent("GunGame:SetGunGameVar", function(isWeapon, Weapon, isGunGame)
    if isWeapon then
        isCurrentWeapon = Weapon;
    end 
    if isGunGame then
        NetworkSetFriendlyFireOption(true)
        isInGunGame = not isInGunGame;
    end
end)

Citizen.CreateThread(function()
    while true do
        if isInGunGame then
            local ped = PlayerPedId()
            if GetSelectedPedWeapon(ped) ~= isCurrentWeapon then
                SetCurrentPedWeapon(ped, isCurrentWeapon, true)
            end
        else
            Citizen.Wait(750)
        end
        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        if isInGunGame and currentMap then
            local coordination = math.floor(#Config.Locations[currentMap].PVP/2)
            local coord = Config.Locations[currentMap].PVP[coordination]
            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), vector3(coord[1], coord[2], coord[3]))
            if distance >= 120.0 then
                ESX.SetEntityCoords(PlayerPedId(), coord[1], coord[2], coord[3])
            end
            DrawMarker(1, coord[1], coord[2], coord[3] - 100, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 200.0, 200.0, 200.0, 100, 120, 200, 255, false, true, 2, false, false, false, false)
        else
            Citizen.Wait(750)
        end   
    end
end)

RegisterNetEvent("GunGame:PlayClientSound", function(audio, volume)
    SendNUIMessage({
        action = "playAudio",
        audioFile = audio,
        volume = volume,
    })
end)

Citizen.CreateThread(function()
    RequestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do
        Wait(100)
    end
    local displayPed = CreatePed("CIVMALE", Config.PedModel, Config.StartGunGame[1],Config.StartGunGame[2],Config.StartGunGame[3] - 0.99999, Config.Heading, false, false)
    SetBlockingOfNonTemporaryEvents(displayPed, true)
    SetEntityInvincible(displayPed, true)
    FreezeEntityPosition(displayPed, true)
    SetModelAsNoLongerNeeded(Config.PedModel)
end)

local canPlay = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canPlay = true
    else
        canPlay = false
    end
end)

local loopTimeout = 5000
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local c = #(GetEntityCoords(ped) - Config.StartGunGame)
        if c < 30.0 then
            loopTimeout = 0;
        else
            if c > 30.0 and loopTimeout > 5000 then
                loopTimeout = 5000;
            end
        end
        if c < 2.0 then
            DrawMarker(20, Config.StartGunGame[1], Config.StartGunGame[2], Config.StartGunGame[3] + 1.0,0.0, 0.0, 0.0,0.0, 0.0, 0.0,0.2, 0.2, 0.2,250, 0, 0, 128,false,   false,2,true,nil,nil,false)
            if canPlay and IsControlJustPressed(0, 51) then
                TriggerServerEvent("GunGameAction:Start", "Casual")
            end
        end
        Wait(loopTimeout)
    end
end)

RegisterNetEvent("esx_gunGame:AddWeapon")
AddEventHandler("esx_gunGame:AddWeapon", function(gun)
    print(gun, isInGunGame)
    if GetInvokingResource() then return end
    while not isInGunGame do 
        Citizen.Wait(500)
    end
    RemoveAllPedWeapons(PlayerPedId(), false)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey(gun), 250, false, true)
end)