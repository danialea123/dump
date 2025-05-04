---@diagnostic disable: undefined-field, undefined-global
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(1000)
    end

    PlayerData = ESX.GetPlayerData()
    PlayerData.World = 0
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if GetInvokingResource() then return end
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

local wl = {
    [35714] = true,
    [35715] = true,
}

local Break = false

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
    if GetInvokingResource() then return end
    local Bucket = Bucket
    PlayerData.World = Bucket
    Break = true
    Citizen.Wait(3000)
    Break = false
    local Emergency = Config.HeliJobs[PlayerData.job.name]
    if Emergency and wl[Bucket] then
        RunHeliThread()
    end
end)

local heli = {
    vector4(242.25,285.0,105.55,161.31),
    vector4(915.33,-2268.24,30.56,343.66),
    vector4(450.63,-3069.21,6.07,4.91),
    vector4(-121.04,6482.74,31.47,129.61),
    vector4(-1093.34,-277.52,37.78,291.67)
}

function OpenHeliMenu(coord)
    ESX.UI.Menu.CloseAll()
    local elem = {}
    if PlayerData.job.name == "police" then
        elem = {
            {label = 'Heli - 1', value = 'polmav'},
            {label = 'Heli - 2', value = 'mh6pd'},
        }
    end
    if PlayerData.job.name == "sheriff" then
        elem = {
            {label = 'Heli - 1', value = 'polmash'},
            {label = 'Heli - 2', value = 'buzzard2'},
        }
    end
    if PlayerData.job.name == "forces" then
        elem = {
            {label = 'Heli - 1', value = 'polsp'},
            {label = 'Heli - 2', value = 'buzzard2'},
        }
    end
    if PlayerData.job.name == "fbi" then
        elem = {
            {label = 'Heli - 1', value = 'fblsp'},
            {label = 'Heli - 2', value = 'buzzard2'},
        }
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'heli_spawner',
    {
        title    = 'Helicopter Menu',
        align    = 'top-left',
        elements = elem
    }, function(data, menu)
        menu.close()
        if data.current.value == 'polmav' then
            ESX.Game.SpawnVehicle('polmav', coord.xyz, coord.w or coord.a or coord.h, function(vehicle)
                SetVehicleModKit(vehicle, 0)
                SetVehicleLivery(vehicle, 0)
                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                ESX.CreateVehicleKey(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        end
        if data.current.value == 'mh6pd' then
            ESX.Game.SpawnVehicle('mh6pd', coord.xyz, coord.w or coord.a or coord.h, function(vehicle)
                Wait(2000)
                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                ESX.CreateVehicleKey(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        end
        if data.current.value == 'fblsp' then
            ESX.Game.SpawnVehicle('fblsp', coord.xyz, coord.w or coord.a or coord.h, function(vehicle)
                SetVehicleModKit(vehicle, 0)
                SetVehicleLivery(vehicle, 0)
                Citizen.Wait(2000)
                TriggerServerEvent('savedVehicles', 'fbi', VehToNet(vehicle))
                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                ESX.CreateVehicleKey(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        end
        if data.current.value == 'polsp' then
            ESX.Game.SpawnVehicle('polsp', coord.xyz, coord.w or coord.a or coord.h, function(vehicle)
                SetVehicleModKit(vehicle, 0)
                SetVehicleLivery(vehicle, 0)
                Citizen.Wait(2000)
                TriggerServerEvent('savedVehicles', 'forces', VehToNet(vehicle))
                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                ESX.CreateVehicleKey(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        end
        if data.current.value == 'buzzard2' then
            ESX.Game.SpawnVehicle('buzzard2', coord.xyz, coord.w or coord.a or coord.h, function(vehicle)
                Wait(2000)
                TriggerServerEvent('savedVehicles', 'forces', VehToNet(vehicle))
                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                ESX.CreateVehicleKey(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        end
        if data.current.value == 'polmash' then
            ESX.Game.SpawnVehicle('polmash', coord.xyz, coord.w or coord.a or coord.h, function(vehicle)
                SetVehicleModKit(vehicle, 0)
                SetVehicleLivery(vehicle, 0)
                Citizen.Wait(2000)
                TriggerServerEvent('savedVehicles', 'sheriff', VehToNet(vehicle))
                exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
                ESX.CreateVehicleKey(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

function RunHeliThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2)
            if Break then
                break
            end
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local Pause = true
            for k, v in pairs(heli) do
                local dist = #(vector3(v.x, v.y, v.z) - playerCoords)
                if dist < 10.0 then
                    Pause = false
                    DrawMarker(7, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 0, 0, 255, 100, false, true, 2, false, false, false, false)
                    if dist < 2.0 then
                        if IsControlJustReleased(0, 38) then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                            else
                                OpenHeliMenu(v)
                            end
                        end
                    end
                end
            end
            if Pause then Citizen.Wait(710) end
        end
    end)
end

local Busy = false

function OpenRobberyMenu(robName)
    local robName = robName
    if Busy then return end
    local isEmergency = Config.EmergencyJobs[PlayerData.job.name]
    ESX.UI.Menu.CloseAll()
    if true then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'robbery_emergency_view',
        {
            title    = 'World Robbery',
            align    = 'center',
            elements = {
                {label = "World 1", value = 35714},
                {label = "World 2", value = 35715}
            }
        },function(data, menu)
            Busy = true
            menu.close()
            local action = data.current.value
            TriggerEvent('mythic_progbar:client:progress', {
                name = 'cast',
                duration = math.random(5000, 10000),
                label = 'Changing World...',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }
            }, function(status)
                Busy = false
                if not status then
                    TriggerServerEvent("esx_worldRob:ChangeWorld", action)
                    Citizen.Wait(3000)
                    local c = Config.RobberyList[robName].coords
                    local r = Config.RobberyList[robName].radius
                    CheckDistance(c, r)
                end
            end)
        end,function(data, menu)
            menu.close()
        end)
    else
        ESX.TriggerServerCallback('esx_worldRob:CanJoin', function(data)
            if data then
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'robbery_emergency_view',
                {
                    title    = 'World Robbery',
                    align    = 'center',
                    elements = {
                        {label = "Join Robbery World", value = data},
                    }
                },function(data, menu)
                    Busy = true
                    menu.close()
                    local action = data.current.value
                    TriggerEvent('mythic_progbar:client:progress', {
                        name = 'cast',
                        duration = math.random(5000, 10000),
                        label = 'Changing World...',
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }
                    }, function(status)
                        Busy = false
                        if not status then
                            TriggerServerEvent("esx_worldRob:ChangeWorld", action)
                            Citizen.Wait(3000)
                            local c = Config.RobberyList[robName].coords
                            local r = Config.RobberyList[robName].radius
                            CheckDistance(c, r)
                        end
                    end)
                end,function(data, menu)
                    menu.close()
                end)
            else
                ESX.Alert("Shoma Dastresi Be Robbery Zone Nadarid", "info")
            end
        end, robName)
    end
end

function OpenExitMenu()
    if Busy then return end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'go_back_menu_gang',
    {
        title    = 'Robbery Exit Menu',
        align    = 'center',
        elements = {
            {label = 'Leave Robbery Zone', value = 'back'},
        }
    },function(data, menu)
        Busy = true
        menu.close()
        TriggerEvent('mythic_progbar:client:progress', {
            name = 'cast',
            duration = math.random(5000, 10000),
            label = 'Changing World...',
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }
        }, function(status)
            Busy = false
            if not status then
                TriggerServerEvent('esx_worldRob:ChangeWorld', 0)
            end
        end)
    end,function(data, menu)
        menu.close()
    end)
end

function CheckDistance(data, radius)
    local Coord = vector3(data.x, data.y, data.z)
    Citizen.CreateThread(function()
        while PlayerData.World ~= 0 do
            Citizen.Wait(1000)
            local c = GetEntityCoords(PlayerPedId())
            local dis = #(Coord.xy - c.xy)
            print(dis)
            if dis >= radius then
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                ESX.SetEntityCoords(PlayerPedId(), Coord)
                Citizen.Wait(500)
                ESX.SetEntityCoords(PlayerPedId(), Coord)
                TriggerServerEvent("backme")
                ESX.Alert("Shoma Az Zone Robbery Fasele Gereftid", "info")
                break
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local Pause = true
        for robberyName, robbery in pairs(Config.RobberyList) do
            local dist = #(vector3(robbery.coords.x, robbery.coords.y, robbery.coords.z) - playerCoords)
            if dist < 10.0 then
                Pause = false
                DrawMarker(1, robbery.coords.x, robbery.coords.y, robbery.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
                if dist < 2.0 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to open robbery menu')
                    if IsControlJustReleased(0, 38) then
                        if PlayerData.World == 0 then
                            OpenRobberyMenu(robberyName)
                        else
                            OpenExitMenu()
                        end
                    end
                end
            end
        end
        if Pause then Citizen.Wait(750) end
    end
end)

