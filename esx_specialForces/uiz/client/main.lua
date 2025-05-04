---@diagnostic disable: lowercase-global, undefined-global, redundant-parameter, undefined-field
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    StartHUD()
end)


---@diagnostic disable: cast-local-type
local directions <const> = {
    N = 360, 0,
    NE = 315,
    E = 270,
    SE = 225,
    S = 180,
    SW = 135,
    W = 90,
    NW = 45
}

function RefreshTimeAndPlayers()
    Citizen.CreateThread(function()
        while true do
            Wait(1000)

            local hour = GetClockHours()
            local minute = GetClockMinutes()
            local timestamp <const> = GetCloudTimeAsInt()
            local players <const> = #GetActivePlayers()
            if hour < 10 then
                hour = "0"..hour
            end
            if minute < 10 then
                minute = "0"..minute
            end
    
            SendNUIMessage({
                action = 'refreshtime',
                hour = hour,
                minute = minute,
                timestamp = timestamp,
                players = players
            })
            SendNUIMessage({
                action = 'refreshid',
                playerid = GetPlayerServerId(PlayerId())
            })
        end
    end)
end

function RefreshVehicleHUD()
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    while vehicle ~= 0 do
        Citizen.Wait(100)
        vehicle = GetVehiclePedIsIn(cache.ped, false)
        local vehicleSpeed <const> = math.floor(GetEntitySpeed(vehicle) * 3.6)
        local vehicleEngine <const> = math.floor(GetVehicleEngineHealth(vehicle) * 0.067)
        local vehicleEngineStats <const> = GetVehicleEngineHealth(vehicle) <= 400
        local vehicleGear <const> = GetVehicleCurrentGear(vehicle)
        local vehicleFuel <const> = math.floor(exports["LegacyFuel"]:GetFuel(vehicle) * 0.67)
        local _, vehicleLight, highbeamsOn <const> = GetVehicleLightsState(vehicle)
        SendNUIMessage({
            action = 'refreshvehiclehud',
            speed = vehicleSpeed,
            engine = vehicleEngine,
            enginestats = vehicleEngineStats,
            gear = vehicleGear == 0 and 'R' or vehicleGear,
            fuel = vehicleFuel,
            light = highbeamsOn == 1 and true or false,
            door = GetVehicleDoorLockStatus(vehicle) == 2,
            seatbelt = slb
        })
    end
end

function ShowVehicleHUD(vehicle)
    SendNUIMessage({
        action = 'enteredvehicle'
    })
    RefreshVehicleHUD(vehicle)
end

function StartHUD()
    SendNUIMessage({
        action = 'hudstats',
        display = true
    })
    RefreshTimeAndPlayers()
end

CreateThread(function ()
    while true do
        Wait(1500)

        local playerTalking <const> = NetworkIsPlayerTalking(cache.playerId)
        local pausemenu <const> = IsPauseMenuActive()

        SendNUIMessage({
            action = 'playertalking',
            stats = playerTalking
        })

        if pausemenu ~= false then
            SendNUIMessage({
                action = 'hudstats',
                display = false
            })
        else
            SendNUIMessage({
                action = 'hudstats',
                display = true
            })
        end
    end
end)

CreateThread(function ()
    while true do
        Wait(500)

        local playerPed <const> = cache.ped
        local playerCoords <const> = GetEntityCoords(playerPed)
        local zone <const> = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)
        local zoneLabel <const> = GetLabelText(zone)
        local var1 <const>, _ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        local streetHash <const> = GetStreetNameFromHashKey(var1)

        local playerDirection  = GetEntityHeading(playerPed)

        for k, v in pairs(directions) do
            if (math.abs(playerDirection - v) < 22.5) then
                playerDirection = k

                if (playerDirection == 1) then
                    playerDirection = 'N'
                    break
                end

                break
            end
        end

        SendNUIMessage({
            action = 'refreshstreatlabel',
            location = playerDirection,
            zonelabel = zoneLabel,
            streetlabel = streetHash
        })
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = cache.ped
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            ShowVehicleHUD()
        else
            SendNUIMessage({
                action = 'exitedvehicle'
            })
        end
    end
end)

slb = false

AddEventHandler("seatbelt:hudState", function(state)
    slb = state
end)