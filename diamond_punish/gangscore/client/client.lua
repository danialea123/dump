---@diagnostic disable: trailing-space, missing-parameter
displayed = false

RegisterCommand("showscoreboard",function()
    if not ESX.GetPlayerData().aduty then return end
    if ESX.GetPlayerData().permission_level <= 1 then return end
    if(not displayed) then
        ESX.TriggerServerCallback("mtmc-scoreboard:server:getscoreboard",function(res)
            SendNUIMessage({
                type = 'enable',
                playerData = res.playerData,
                jobData = res.jobData,
                gangData = res.gangData
            })
        end)
    else
        SendNUIMessage({
            type = 'disable',
        })
        
    end
    displayed = not displayed
end)

RegisterNetEvent("esx_bossaction:openMenu")
AddEventHandler("esx_bossaction:openMenu", function(gangs)
    local element = {}
    for k, v in pairs(gangs) do
        table.insert(element, {label = k, value = k})
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_ask', {
		title = "Open Gang Bossaction",
		align = 'center',
		elements = element,
	}, function(data, menu)
        local data = data
        TriggerServerEvent("esx:setGangAdmin", data.current.value)
        Citizen.Wait(2000)
        exports.gangs:OpenEmployeeList(data.current.value, true)
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterKeyMapping('showscoreboard', 'Display Scoreboard', 'keyboard', 'Home')

function startTurn(vehicle, direction)
    if direction ~= 'left' and direction ~= 'right' then return end
    local vehicle = vehicle
    SetVehicleSteeringAngle(vehicle, direction == 'left' and 30.0 or direction == 'right' and -30.0)
end

function stopTurn(vehicle)
    local vehicle = vehicle
    SetVehicleSteeringAngle(vehicle, 0.0)
end

function startMove(vehicle, direction)
    local vehicle = vehicle
    local playerId = PlayerId()
    local ped = PlayerPedId() 
    remotepush = true
    while remotepush do
        Wait(0)
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleBrake(vehicle, false)
        SetVehicleForwardSpeed(vehicle, direction == 'trunk' and 1.1 or -1.1)
        local owner = NetworkGetEntityOwner(vehicle)
        if owner ~= playerId then
            remotepush = false
            stopPushing()
            return 
        end
        if owner == playerId and seat == -1 then
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            if IsDisabledControlPressed(0, 34) then
                TaskVehicleTempAction(ped, vehicle, 11, 1000)
            elseif IsDisabledControlPressed(0, 35) then
                TaskVehicleTempAction(ped, vehicle, 10, 1000)
            end
        end
        if IsEntityInAir(vehicle) then
            remotepush = false
            stopPushing()
            return
        end
    end
end

function stopMove()
    remotepush = false
end

function startPushing(vehicle)
    local health = true
    local ped = PlayerPedId()
    if not health then return end
    local flipped = IsEntityUpsidedown(vehicle) and true or false
    if flipped then return end
    local min, max = GetModelDimensions(GetEntityModel(vehicle))
    local size = max - min
    local coords = GetEntityCoords(ped)
    local closest = #(coords - GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (size.y / 2), 0.0)) < #(coords - GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (-size.y / 2), 0.0)) and 'bonnet' or 'trunk'
    --local start = lib.callback.await('OT_pushvehicle:startPushing', false, NetworkGetNetworkIdFromEntity(vehicle), closest)
    --if start then
    --exports.essentialmode:DisableControl(true)
        vehiclepushing = vehicle
        pushing = true
        AttachEntityToEntity(ped, vehicle, 0, 0.0, closest == 'trunk' and min.y - 0.6 or -min.y + 0.4, closest == 'trunk' and min.z + 1.1 or max.z / 2, 0.0, 0.0, closest == 'trunk' and 0.0 or 180.0, 0.0, false, false, true, 0, true)
        RequestAnimDict('missfinale_c2ig_11')
        TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 1.5, 1.5, -1, 35, 0, false, false, false)
    --end
    TriggerEvent("dpemote:enable", false)
    TriggerEvent("dpclothingAbuse", true)
    ESX.SetPlayerData("isSentenced", true)
    startMove(vehicle, closest)
end

AddEventHandler("esx:PushVehicle", function(vehicle)
    if GetVehicleClass(vehicle) == 14 then return end
    startPushing(vehicle)
end)

AddEventHandler("onKeyDown", function(key)
    if key == "x" or key == "e" or key == "f" then
        stopPushing()
    end
end)

AddEventHandler("onKeyDown", function(key)
    if key == "d" then
        if vehiclepushing then
            startTurn(vehiclepushing, "right")
        end
    end
end)

AddEventHandler("onKeyDown", function(key)
    if key == "a" then
        if vehiclepushing then
            startTurn(vehiclepushing, "left")
        end
    end
end)

AddEventHandler("onKeyUP", function(key)
    if key == "d" then
        if vehiclepushing then
            stopTurn(vehiclepushing)
        end
    end
end)

AddEventHandler("onKeyUP", function(key)
    if key == "a" then
        if vehiclepushing then
            stopTurn(vehiclepushing)
        end
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    stopPushing()
end)

function stopPushing()
    if vehiclepushing then
        vehiclepushing = nil
        pushing = false
        remotepush = false
        --exports.essentialmode:DisableControl(false)
        TriggerEvent("dpemote:enable", true)
        TriggerEvent("dpclothingAbuse", false)
        ESX.SetPlayerData("isSentenced", false)
        DetachEntity(PlayerPedId(), true, false)
        ClearPedTasks(PlayerPedId())
    end
end

Citizen.CreateThread(function()
    RequestAnimDict('missfinale_c2ig_11')
end)