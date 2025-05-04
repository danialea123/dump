---@diagnostic disable: undefined-field, param-type-mismatch, missing-parameter, lowercase-global, undefined-global
ESX = nil

local InRealWorld = true
local CaptureIsActive = false
local IsNUIReady = false
local IsDead = false
local activeDrops = {}
local PlayerData = {}
local zoneTimers = {}
local sphere = {}
local inSafeZone = false
local playerinSafezone = false
local activeSafeZones = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
    PlayerData = data
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

function ShowMissionText(tx)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(tx)
    DrawSubtitleTimed(8000, 1)
end

RegisterNUICallback('NUIReady', function(data, cb)
    IsNUIReady = true
end)

RegisterNetEvent('Zone:CaptureStarted')
AddEventHandler('Zone:CaptureStarted', function()
    while not PlayerData and PlayerData.gang == nil do
        Citizen.Wait(100)
    end

    while IsNUIReady == false do
        Citizen.Wait(100)
    end

    CaptureIsActive = true

    if PlayerData.gang.name ~= 'nogang' then
        ShowHelps()
        ShowMarker()
    end
end)

function ShowHelps()
    CreateThread(function()
        if Config.Locations and Config.Locations.JoinExit then
            local v = Config.Locations.JoinExit
            if v.Blip.Show then
                startblip = AddBlipForCoord(v.Coord.x, v.Coord.y, v.Coord.z)
                SetBlipSprite(startblip, v.Blip.Sprite)
                SetBlipDisplay(startblip, 2)
                SetBlipScale(startblip, 0.6)
                SetBlipColour(startblip, v.Blip.Color)
                SetBlipAsShortRange(startblip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Blip.Name)
                EndTextCommandSetBlipName(startblip)
            end
        end
    end)
end

function ShowMarker()
    CreateThread(function()
        while CaptureIsActive do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local sleepThread = 1000
            if PlayerData.gang.name ~= 'nogang' then
                local point = Config.Locations.JoinExit
                if point.Marker.Show then
                    local distance = #(playerCoords - vector3(point.Coord.x, point.Coord.y, point.Coord.z))
                    if distance <= point.Marker.DrawDistance then
                        sleepThread = 1
    
                        DrawMarker(point.Marker.Type, point.Coord.x, point.Coord.y, point.Coord.z - 1, 0, 0, 0, 0, 0, 0, point.Marker.Radius, point.Marker.Radius, 1.0, point.Marker.Color.r, point.Marker.Color.g, point.Marker.Color.b, point.Marker.Color.a, false, true, 2, nil, nil, false)
                        
                        if distance <= point.Marker.Radius then
                            if point.Marker.Text then
                                ESX.ShowHelpNotification(point.Marker.Text)
                            end
                            if point.Marker.action then
                                if IsControlJustPressed(0, 38) then
                                    point.Marker.action()
                                end
                            end
                        end
                    elseif distance >= point.Marker.DrawDistance then
                        sleepThread = 1000
                    end
                end
            end
    
            Citizen.Wait(sleepThread)
        end
    end)
end

function openmenu()

    ESX.TriggerServerCallback('Zone:GetWorld',function(world)
        if world == 0 then
            local elements = {
                {label = "Vared Shodan Be World Zone Fight" , value = "enter"}
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
                {
                    title    = 'Zone menu',
                    align    = 'center',
                    elements = elements,
                },
        
                function(data, menu)
                    if data.current.value == "enter" then
                        menu.close()
                        local elements = {
                            {label = "Aya az Taghir World Khod motmaeen hastid?" , value = "none"},
                            {label = "✔️Bale✔️" , value = "yes"},
                            {label = "❌Kheir❌" , value = "no"},
                        }
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
                            {
                                title    = 'Zone menu',
                                align    = 'center',
                                elements = elements,
                            },
                            function(data2, menu2)
                                if data2.current.value == "yes" then    
                                    menu2.close()
                                    TriggerEvent("mythic_progbar:client:progress", {
                                        name = "process_robbery",
                                        duration = 5000,
                                        label = "",
                                        useWhileDead = false,
                                        canCancel = false,
                                        controlDisables = {
                                            disableMovement = true, 
                                            disableCarMovement = true, 
                                            disableMouse = false, 
                                            disableCombat = true
                                        },
                                    }, function(status)
                                        if not status then
                                           TriggerServerEvent("esx_zone:ChangeToCaptureWorld")
                                        end
                                    end)
                                elseif data2.current.value == "no" then      
                                    menu2.close()
                                end
                            end,
                            function(data2, menu2)
                                menu2.close()
                            end
                        )
                    end
                end,
                function(data, menu)
                    menu.close()
                end
            )
        else
            elements = {
                {label = "Back to real world", value = "back"}
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'back',
                {
                    title    = 'Zone menu',
                    align    = 'center',
                    elements = elements,
                }, function(data, menu)
                    menu.close()
                    if data.current.value == "back" then
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_robbery",
                            duration = 5000,
                            label = "",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = true, 
                                disableCarMovement = true, 
                                disableMouse = false, 
                                disableCombat = true
                            },
                        }, function(status)
                            if not status then
                                TriggerServerEvent("backme")
                            end
                        end)
                        
                    end
                end,

            function(data, menu)
                menu.close()
            end)
        end
    end)
end

function startZone()
    Citizen.CreateThread(function()
        while CaptureIsActive and not InRealWorld do
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local sleepThread = 1000
            
            for k, v in pairs(Config.Locations.Zones) do
                local distance = GetDistanceBetweenCoords(coords, v.Coord, false)
                
                if distance < 450 then
                    sleepThread = 1
                    DrawMarker(v.Marker.Type, v.Coord.x, v.Coord.y, v.Coord.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, v.Marker.Size, v.Marker.Color.r, v.Marker.Color.g, v.Marker.Color.b, 150, false, true, 2, false, false, false, false)

                    if not v.Captured then
                        local currentTime = GetGameTimer()
                
                        if not v.LastUpdateTime then
                            v.LastUpdateTime = 0
                        end
                
                        if distance < 1.5 then
                            v.Marker.Color = { r = 3, g = 252, b = 115 }
                
                            if currentTime - v.LastUpdateTime > 1000 then
                                if v.Marker.Type == 19 then
                                    v.Captured = true
                                    TriggerServerEvent('Zone:CaptureMe', k)                                           
                                elseif v.Marker.Type == 1 then
                                    v.Marker.Size = 1.5
                                    v.Marker.Type = 10
                                elseif v.Marker.Type < 19 then
                                    v.Marker.Type = v.Marker.Type + 1
                                end
                                v.LastUpdateTime = currentTime
                            end
                        else
                            v.Marker.Size = 100.5
                            v.Marker.Color = { r = 252, g = 3, b = 61 }
                            v.Marker.Type = 1
                        end
                    elseif distance >= 450 then
                        sleepThread = 1000
                    end
                end
            end
            Citizen.Wait(sleepThread)
        end
    end)
end

RegisterNetEvent("Zone:ResetZoneHandler", function(zone)
    local Zone = Config.Locations.Zones[zone]
    Zone.Marker.Color = { r = 252, g = 3, b = 61 }
    Zone.Marker.Type = 1
    Zone.Marker.Size = 100.5
    Zone.Captured = false
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Capture Zone ' .. Zone.Name)
    EndTextCommandSetBlipName(Zone.Blips.main)
end)

local activeBlips = {}
function ShowSafeZoneHelps()
    CreateThread(function()
        for k, v in pairs(Config.Locations.SafeZone) do
            if v.Blip and v.Blip.Show then
                local blipRadius = AddBlipForRadius(v.Coord.x, v.Coord.y, v.Coord.z, 50.0)
                local blip = AddBlipForCoord(v.Coord.x, v.Coord.y, v.Coord.z)
                
                SetBlipSprite(blip, v.Blip.Sprite)
                SetBlipDisplay(blip, 2)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, v.Blip.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Blip.Name)
                EndTextCommandSetBlipName(blip)

                SetBlipColour(blipRadius, 2)
                SetBlipAlpha(blipRadius, 100)
                SetBlipAsShortRange(blipRadius, true)
                
                table.insert(activeBlips, blip)
                table.insert(activeBlips, blipRadius)
            end

            local safeZone = lib.zones.sphere({
                coords = v.Coord,
                radius = 50.0,
                debug = false,
                inside = function()
                    if not playerinSafezone then
                        NetworkSetFriendlyFireOption(false)
                        ClearPlayerWantedLevel(PlayerId())
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                        playerinSafezone = true
                        ShowMissionText('~g~You entered a Safe Zone')
                    end
                    
                    DisableControlAction(2, 37, true)
                    DisableControlAction(1, 140, true)
                    DisableControlAction(1, 141, true)
                    DisableControlAction(1, 142, true)
                    DisableControlAction(1, 37, true)
                    DisableControlAction(1, 73, true)
                    DisablePlayerFiring(PlayerId(), true)
                    DisableControlAction(0, 106, true)

                    if IsDisabledControlJustPressed(2, 37) then 
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                    end
                    if IsDisabledControlJustPressed(0, 106) then
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                    end
                end,
                onEnter = function()
                    NetworkSetFriendlyFireOption(false)
                    ClearPlayerWantedLevel(PlayerId())
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                    playerinSafezone = true
                    ShowMissionText('~g~You entered a Safe Zone')
                end,
                onExit = function()
                    NetworkSetFriendlyFireOption(true)
                    playerinSafezone = false
                    ShowMissionText('~r~You left the Safe Zone')
                end
            })
            table.insert(activeSafeZones, safeZone)
        end
    end)
end

local ActiveReviveZone = {}
function CreateReviveZone()
    for k, v in pairs(Config.Locations.SafeZone) do
        RequestModel(v.ReviveZone.Ped)
        while not HasModelLoaded(v.ReviveZone.Ped) do
            Wait(1)
        end
        local ped = CreatePed(2, v.ReviveZone.Ped, v.ReviveZone.PedCoord.x, v.ReviveZone.PedCoord.y, v.ReviveZone.PedCoord.z-1, v.ReviveZone.PedCoord.w, false, false)
        SetPedFleeAttributes(ped, 0, 0)
        SetPedDiesWhenInjured(ped, false)
        SetPedKeepTask(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
	    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
        table.insert(ActiveReviveZone, ped)
    end
end

function CreateSafeZones()
    ShowSafeZoneHelps()
    CreateReviveZone()
    Citizen.CreateThread(function()
        while CaptureIsActive and not InRealWorld do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local sleepThread = 1000

            if PlayerData.gang.name ~= 'nogang' then
                for k, v in pairs(Config.Locations.SafeZone) do
                    for l, point in pairs(v.Zones) do
                        local Coord = point.Marker.Coord ~= nil and point.Marker.Coord or v.Coord
                        local distance = #(playerCoords - vector3(Coord.x, Coord.y, Coord.z))

                        if distance <= 100.0 or distance <= point.Marker.DrawDistance then
                            sleepThread = 1
                        end

                        if distance <= 100.0 then
                            DrawMarker(28, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 50.0, 50.0, 50.0, 175, 237, 174, 100, false, false, 2, false, false, false, false)
                        end

                        if distance <= point.Marker.DrawDistance then
                            if point.Marker.ShowMarker then
                                DrawMarker(point.Marker.Type, Coord.x, Coord.y, Coord.z, 0, 0, 0, 0, 0, 0, point.Marker.Radius, point.Marker.Radius, point.Marker.Radius, point.Marker.Color.r, point.Marker.Color.g, point.Marker.Color.b, point.Marker.Color.a, false, true, 2, nil, nil, false)
                            end

                            if distance <= point.Marker.Radius then
                                if point.Marker.Text then
                                    ESX.ShowHelpNotification(point.Marker.Text)
                                end
                                if point.Marker.action then
                                    if IsControlJustPressed(0, 38) then
                                        point.Marker.action(k, l, point)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            Citizen.Wait(sleepThread)
        end
    end)
end


function RemoveSafeZoneHelps()
    for _, blip in ipairs(activeBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    activeBlips = {}

    for _, zone in ipairs(activeSafeZones) do
        zone:remove()
    end
    activeSafeZones = {}
end

function RemoveReviveZone()
    for _, ped in ipairs(ActiveReviveZone) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    ActiveReviveZone = {}
end

function Teleport(coord, needfoundGround)
    local coordZ = 0
    local height = 300.0

    local foundGround = false
    if needfoundGround then 
        repeat
            Wait(10)
            ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, height)

            foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)
            coordZ = z + 1
            height = height - 1.0
        until foundGround or height < -100
    end

    if not foundGround then
        coordZ = coord.z
    end

    ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, coordZ)
end

function openteleportmenu(ignorezone)
    local elements = {}
    for k, v in pairs(Config.Locations.SafeZone) do
        if k ~= ignorezone then
            table.insert(elements, {
                label = "Teleport To SafeZone " .. k,
                zone = k,
                value = "teleport"
            })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
    {
        title    = 'Safe Zone Teleport Menu',
        align    = 'center',
        elements = elements,
    },function(data, menu)
        if data.current.value == "teleport" then
            menu.close()
            local elements = {
                {label = "Aya az Raftan Be SafeZone "..data.current.zone.." motmaeen hastid?" , value = "none"},
                {label = "✔️Bale✔️" , value = "yes"},
                {label = "❌Kheir❌" , value = "no"},
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'safezone_teleport_confirm',
            {
                title    = 'Safe Zone Teleport Menu',
                align    = 'center',
                elements = elements,
            },function(data2, menu2)
                if data2.current.value == "yes" then    
                    menu2.close()
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "process_robbery",
                        duration = 5000,
                        label = "",
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true, 
                            disableCarMovement = true, 
                            disableMouse = false, 
                            disableCombat = true
                        },
                    }, function(status)
                        if not status then
                            Teleport(Config.Locations.SafeZone[data.current.zone].Coord, false)
                        end
                    end)
                elseif data2.current.value == "no" then      
                    menu2.close()
                end
            end,function(data2, menu2)
                menu2.close()
            end)
        end
    end,function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('esx:RoutingBucketChanged')
AddEventHandler('esx:RoutingBucketChanged',function(world)
    if world == 0 then
        if exports.capture:CaptureIsActive() then return end
        TriggerEvent('capture:inCapture', false)
        RemoveZoneBlips()
        RemoveSafeZoneHelps()
        RemoveReviveZone()
        SendNUIMessage({
            type = "HideHud"
        })

        for k, v in pairs(Config.Locations.Zones) do
            v.Marker.Type = 1
            v.Marker.Size = 100.5
            v.Captured = false
            v.Marker.Color = {
                r = 252,
                g = 3,
                b = 61
            }
        end

        for _, data in ipairs(activeDrops) do
            if DoesEntityExist(data.vehicle) then
                DeleteEntity(data.vehicle)
            end
            if DoesEntityExist(data.pilot) then
                DeleteEntity(data.pilot)
            end
            if data.drop and DoesEntityExist(data.drop) then
                DeleteEntity(data.drop)
            end
        end

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local point = Config.Locations.JoinExit
        local distance = #(playerCoords - vector3(point.Coord.x, point.Coord.y, point.Coord.z))
        if not InRealWorld then
            Teleport(point.Coord, true)
        end
        InRealWorld = true
    elseif world == 2467 then
        while IsNUIReady == false do
            Citizen.Wait(100)
        end
        TriggerEvent('capture:inCapture', true)
        InRealWorld = false
        startZone()
        CreateZoneBlip()
        CreateSafeZones()
        SendNUIMessage({
            type = "showHud"
        })
        ESX.TriggerServerCallback("esx_zone:GetCaptureData", function(startTime, gameTimer, currentTime, handlers)
            local currentTime = currentTime
            for k, v in pairs(handlers) do
                TriggerEvent("Zone:ChangeZoneHandler", v, k)
            end
            Citizen.CreateThread(function()
                while not InRealWorld do
                    Citizen.Wait(1000)
                    currentTime = currentTime + 1
                    local elapsedTime = currentTime - startTime
                    local remainingTime = gameTimer - elapsedTime
                    local hours = math.floor(remainingTime / 3600)
                    local minutes = math.floor((remainingTime % 3600) / 60)
                    local seconds = remainingTime % 60
                    local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
                    SendNUIMessage({
                        type = "UpdateHud",
                        action = "GameTime",
                        value = formattedTime
                    })
                end
            end)
        end)
    end
end)

RegisterNetEvent('Zone:ChangeZoneHandler')
AddEventHandler('Zone:ChangeZoneHandler', function(gang, zone)
    local Zone = Config.Locations.Zones[zone]
    if not PlayerData or not Zone or not Zone.Blips then
        return
    end

    while IsNUIReady == false do
        Citizen.Wait(100)
    end

    if PlayerData.gang.name ~= gang then
        ShowMissionText('Gang ~o~' .. gang .. '~w~ Zone Island Ra Capture Kard: ' .. Zone.Name)
        Zone.Marker.Color = { r = 252, g = 3, b = 61 }
        Zone.Marker.Type = 1
        Zone.Marker.Size = 100.5
        Zone.Captured = false
    else
        ShowMissionText('~g~Your gang is capturing Island Zone ' .. Zone.Name)
        Zone.Marker.Color = { r = 3, g = 252, b = 115 }
        Zone.Marker.Type = 1
        Zone.Marker.Size = 100.5
        Zone.Captured = true
    end

    Zone.CapturedBy = gang
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Captured By ' .. gang)
    EndTextCommandSetBlipName(Zone.Blips.main)
end)


function CreateZoneBlip()
    CreateThread(function()
        for k, v in pairs(Config.Locations.Zones) do
            local blipRadius = AddBlipForRadius(v.Coord.x, v.Coord.y, v.Coord.z, v.Marker.Radius)
            local blip = AddBlipForCoord(v.Coord.x, v.Coord.y, v.Coord.z)
            
            SetBlipSprite(blip, v.Blip.Sprite)
            SetBlipDisplay(blip, 2)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, v.Blip.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Capture Zone ' .. v.Name)
            EndTextCommandSetBlipName(blip)
            
            SetBlipColour(blipRadius, 49)
            SetBlipAlpha(blipRadius, 100)
            SetBlipAsShortRange(blipRadius, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Zone_' .. v.Name)
            EndTextCommandSetBlipName(blipRadius)

            v.Blips = {main = blip, radius = blipRadius}
        end
    end)
end

function RemoveZoneBlips()
    for k, v in pairs(Config.Locations.Zones) do
        if v.Blips then
            if DoesBlipExist(v.Blips.main) then
                RemoveBlip(v.Blips.main)
            end
            if DoesBlipExist(v.Blips.radius) then
                RemoveBlip(v.Blips.radius)
            end

            v.Blips = nil
        end
    end
end
 
RegisterNetEvent('Zone:UpdateHud')
AddEventHandler('Zone:UpdateHud', function(type, ...)
    if not InRealWorld then
        local args = { ... }

        if type == "Zone" then
            local name = args[1]
            local score = args[2]
            local currentGang = args[3]

            if name and score then
                SendNUIMessage({
                    type = "UpdateHud",
                    action = "Zone" .. name,
                    value = score
                })
            end
        elseif type == "Time" then
            local time = args[1]
            if time then
                SendNUIMessage({
                    type = "UpdateHud",
                    action = "GameTime",
                    value = time
                })
            end
        elseif type == "AnnounceKill" then
            local killer = args[1]
            local killed = args[2]
            local weapon = args[3]

            ESX.TriggerServerCallback('Zone:GetWorld',function(world)
                if world ~= 0 then
                    SendNUIMessage({
                        type = 'newKill',
                        killer = killer,
                        killed = killed,
                        weapon = weapon,
                    })
                end
            end)
        elseif type == "AnnounceDeath" then
            local killed = args[1]
            ESX.TriggerServerCallback('Zone:GetWorld',function(world)
                if world ~= 0 then
                    SendNUIMessage({
                        type = 'newDeath',
                        killed = killed,
                    })
                end
            end)
        end
    end
end)

RegisterNetEvent('Zone:CaptureEnded')
AddEventHandler('Zone:CaptureEnded', function()
    Citizen.CreateThread(function()
        while not PlayerData and PlayerData.gang == nil do
            Citizen.Wait(100)
        end
    
        while IsNUIReady == false do
            Citizen.Wait(100)
        end

        if PlayerData.gang.name ~= 'nogang' then
            ShowMissionText('~r~Island Zone Be Payan Resid')
        end
        
        if not InRealWorld then
            Teleport(Config.Locations.JoinExit.Coord, true)
        end

        RemoveZoneBlips()
        RemoveBlip(startblip)
        RemoveSafeZoneHelps()
        RemoveReviveZone()
        
        SendNUIMessage({
            type = "HideHud"
        })
        InRealWorld = true
        CaptureIsActive = false

        for k, v in pairs(Config.Locations.Zones) do
            v.Marker.Type = 1
            v.Marker.Size = 100.5
            v.Captured = false
            v.Marker.Color = {
                r = 252,
                g = 3,
                b = 61
            }
        end
    end)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    if not InRealWorld then
        IsDead = true
        Dead()
    end
end)

function Dead()
    while IsDead do
        Wait(5)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(95, 95, 95, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)

        SetTextEntry("STRING")
        AddTextComponentString("~g~[E] ~w~For Respawn To SafeZone")
        DrawText(0.5, 0.700)

        if IsControlJustPressed(0, 38) then
            ESX.UI.Menu.CloseAll()
            IsDead = false
            TriggerEvent("mythic_progbar:client:progress", {
                name = "process_robbery",
                duration = 5000,
                label = "Respawning To Safe Zone...",
                useWhileDead = true,
                canCancel = false,
                controlDisables = {
                    disableMovement = true, 
                    disableCarMovement = true, 
                    disableMouse = false, 
                    disableCombat = true
                },
            }, function(status)
                if not status then
					FreezeEntityPosition(PlayerPedId(), false)
					TriggerEvent("esx_inventoryhud:closeHud")
					ESX.SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()), false, false, false, true)
					NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
					ESX.SetPlayerInvincible(PlayerPedId(), false)							
					ESX.SetPedArmour(PlayerPedId(), 0)						
					ClearPedBloodDamage(PlayerPedId())
					ESX.UI.Menu.CloseAll()
					ESX.SetEntityHealth(PlayerPedId(), 200)
					TriggerEvent('esx_status:setirs', 'hunger', 1000000)
					TriggerEvent('esx_status:setirs', 'thirst', 1000000)
					TriggerEvent('esx_status:setirs', 'mental', 1000000)
                    local SafeZone = Config.Locations.SafeZone[math.random(1, #Config.Locations.SafeZone)]
                    Teleport(SafeZone.ReviveZone.RevCoord, false)
                end
            end)
        end
    end
end

AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end

    local victim = data[1]
    local victimDied = data[4]

    if not IsPedAPlayer(victim) then return end

    local player = PlayerId()
    local playerPed = PlayerPedId()

    if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim)) then
		local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
        local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

        if killerEntity and killerClientId ~= -1 and NetworkIsPlayerActive(killerClientId) then
            if killerEntity ~= playerPed then
                TriggerServerEvent('Zone:Hud:KillFeed:Killed', GetPlayerServerId(killerClientId), hashToWeapon(deathCause))
            else
                TriggerServerEvent('Zone:Hud:KillFeed:Died')
            end
        else
            TriggerServerEvent('Zone:Hud:KillFeed:Died')
        end
    end
end)

function hashToWeapon(hash)
	if Config.Weapons[hash] ~= nil then
		return Config.Weapons[hash]
	else
		return 'weapon_unknown'
	end
end

RegisterNetEvent('Zone:drop:create',function(FinalCoord, i)
    SpawnPlane(FinalCoord, i)
end)

function LoadModel(model)
    local modelHash = model
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
      Wait(0)
    end
end

function SpawnPlane(coords, i)
    local model = `titan`
    LoadModel(model)

    local pilotModel = `a_m_o_salton_01`
    LoadModel(pilotModel)

    local vehicleCoords = vector3(-1327.69,-2954.3,703.08)
    local heading = GetHeadingFromVector_2d(coords.x - vehicleCoords.x, coords.y - vehicleCoords.y)
    local vehicle = CreateVehicle(model, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)
    local pilot = CreatePed(4, pilotModel, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)
    SetPedIntoVehicle(pilot, vehicle, -1)

    ControlLandingGear(vehicle, 3)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetEntityVelocity(vehicle, 95.0, 0.0, 0.0)

    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 307)
    SetBlipColour(blip, 6)
    SetBlipRotation(blip, GetEntityHeading(pilot))

    local dropData = {
        vehicle = vehicle,
        pilot = pilot,
        target = coords,
        hasDropped = false,
        blip = blip
    }
    table.insert(activeDrops, dropData)

    Citizen.CreateThread(function()
        MonitorPlaneDrop(dropData, i)
    end)
end

function MonitorPlaneDrop(dropData, i)
    local vehicle = dropData.vehicle
    local pilot = dropData.pilot
    local targetCoords = dropData.target
    local blip = dropData.blip

    while DoesEntityExist(vehicle) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local dist = #(vehicleCoords - targetCoords)

        SetBlipRotation(blip, math.ceil(GetEntityHeading(vehicle)))
        SetBlipColour(blip, dropData.hasDropped and 6 or 3)

        if not dropData.hasDropped then
		    TaskPlaneMission(pilot, vehicle, 0, 0, targetCoords.x, targetCoords.y, targetCoords.z + 300, 6, 0, 0, GetEntityHeading(vehicle), 2000.0, 400.0)
        else
            TaskPlaneMission(pilot, vehicle, 0, 0, -3500, 3500, 900, 6, 0, 0, GetEntityHeading(vehicle), 2000.0, 400.0)
        end

        if dist < 350 and not dropData.hasDropped then
            local pos = vector3(targetCoords.x, targetCoords.y, targetCoords.z + 100)
            local drop = AirDrop(pos, i)
            dropData.drop = drop
            dropData.hasDropped = true
        end

        if dist > 1500 and dropData.hasDropped then
            DeleteEntity(vehicle)
            DeleteEntity(pilot)
            RemoveBlip(blip)
            break
        end

        Citizen.Wait(1000)
    end
end

local Drops = {}

function AirDrop(coords, i)
    LoadModel('prop_drop_armscrate_01')
    local drop = CreateObject('prop_drop_armscrate_01', coords.x, coords.y, coords.z, false, true)
    Drops[i] = drop
    SetObjectPhysicsParams(drop,99999.0, 0.1, 0.0, 0.0, 0.0, 700.0, 0.0, 0.0, 0.0, 0.1, 0.0)
    SetEntityLodDist(drop, 1000)
    ActivatePhysics(drop)
    SetDamping(drop, 2, 0.1)
    SetEntityVelocity(drop, 0.0, 0.0, math.random() + math.random(-21, -5))
    exports['diamond_target']:AddTargetEntity(drop, {
        options = {
            {
                label = 'Loot Drop',
                icon = 'fa-solid fa-parachute-box',
                distance = 2,
                action = function(_)
                    TriggerServerEvent("Zone:drop:GiveLoot", i)
                end,
            }
        },
    })

    Citizen.SetTimeout(2000, function()
        local blip = AddBlipForEntity(drop)
        SetBlipSprite(blip, 568)
        SetBlipColour(blip, 31)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Drop")
        EndTextCommandSetBlipName(blip)
        SetBlipRotation(blip, GetEntityHeading(drop))
    end)

    return drop
end

RegisterNetEvent("esx_zone:DeleteBox", function(i)
    if not Drops[i] then return end
    DeleteEntity(Drops[i])
end)

local datas = {}

RegisterNetEvent('Zone:UpdateTimer')
AddEventHandler('Zone:UpdateTimer', function(zone, time)
    local time = time
    local zone = zone
    zoneTimers[zone] = time
    datas[zone] = true
    Citizen.CreateThread(function()
        while datas[zone] do
            Citizen.Wait(1000)
            time = time - 1
            zoneTimers[zone] = time
            if time == 0 then
                zoneTimers[zone] = nil
                datas[zone] = nil
                TriggerEvent("Zone:ResetZoneHandler", zone)
            end
        end
        zoneTimers[zone] = nil
    end)
end)

RegisterNetEvent('Zone:CancelTimer')
AddEventHandler('Zone:CancelTimer', function(zone)
    zoneTimers[zone] = nil
    datas[zone] = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not InRealWorld and CaptureIsActive then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for zone, time in pairs(zoneTimers) do
                local zoneData = Config.Locations.Zones[zone]
                if zoneData then
                    local dist = #(playerCoords - zoneData.Coord)
                    if dist < 80.0 then
                        local minutes = math.floor(time / 60)
                        local seconds = time % 60
                        local coords = vector3(zoneData.Coord.x, zoneData.Coord.y, zoneData.Coord.z + 10.0)
                        DrawText3D(coords, string.format("~HC_12~Next Drop~HC_0~: ~HC_27~% 02d:%02d ~HC_0~", minutes, seconds))
                    end
                end
            end
        end
    end
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.60, 0.60)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end