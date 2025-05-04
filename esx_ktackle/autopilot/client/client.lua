---@diagnostic disable: undefined-global, param-type-mismatch
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
end)

local AutoPilotActive = false
local AutoPilotName

local stopdistance = 15.0 --20
local claimedVeh = nil   
local npcdriver = nil
local DrivingStyle = 0
 
function StartAutoPilot(ped, speed, coord, drivingstyle, emergency)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then
        Notify(ConfigPilot.Texts["not_in_vehicle"], "error")
        return
    end

    if AutoPilotActive then
        AutoPilotActive = false
        local string = string.format(ConfigPilot.Texts["autoPilot_stop"], AutoPilotName) --uiden gelen bilgi)
        Notify(string, "primary")
        SendNUIMessage({
            action = "gfx:client:autopilot:otopilotActive",
            active = false,
        })
        return
    else
        AutoPilotActive = true
        local string = string.format(ConfigPilot.Texts["autoPilot_start"], AutoPilotName) --uiden gelen bilgi)
        Notify(string, "primary")
        SendNUIMessage({
            action = "gfx:client:autopilot:otopilotActive",
            active = true,
        })
    end
    claimedVeh = vehicle
    for i = 0, 7 do
        SetVehicleDoorShut(vehicle, i, false)
    end

    emergency = emergency ~= nil and emergency or false
    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, 0.0)
    if emergency then
        SetNewWaypoint(coord.x, coord.y)
        TaskVehicleDriveToCoordLongrange(ped, vehicle, coord.x, coord.y, coord.z, speed, ConfigPilot.EmergencyDrivingStyle,
            stopdistance)
    else
        SetNewWaypoint(coord.x, coord.y)
        TaskVehicleDriveToCoordLongrange(ped, vehicle, coord.x, coord.y, coord.z, speed, drivingstyle, stopdistance)
    end
    CreateThread(function()
        while AutoPilotActive do
            Citizen.Wait(150)
            local currentpos = GetEntityCoords(vehicle)
            local distance = GetDistanceBetweenCoords(currentpos.x, currentpos.y, currentpos.z, coord.x, coord.y, coord.z, false)
            --Vdist(currentpos.x, currentpos.y, currentpos.z, coord.x, coord.y, coord.z)

            local _, direction, _, turndistance = GenerateDirectionsToCoord(coord.x, coord.y, coord.z, true)
            local vehpos = GetEntityCoords(vehicle)
            if IsVehicleStoppedAtTrafficLights(vehicle) then
                --QBCore.Functions.DrawText3D(vehpos.x, vehpos.y, vehpos.z, "You are at the traffic light")
                SendNUIMessage({
                    action = "gfx:copilot:trafficLight",
                    trafficLight = true,
                })
            else
                SendNUIMessage({
                    action = "gfx:copilot:trafficLight",
                    trafficLight = false,
                })
            end
            if direction then --if direction ~= 0 and direction ~= 1 and direction ~= 8 then
                -- local string = string.format(directiontable[direction], math.floor(turndistance))
                -- QBCore.Functions.DrawText3D(vehpos.x, vehpos.y, vehpos.z, string)
                SendNUIMessage({
                    action = "gfx:copilot:direction",
                    direction = direction,
                    turndistance = turndistance,
                    currentLocation = GetStreetNameFromHashKey(GetStreetNameAtCoord(vehpos.x, vehpos.y, vehpos.z)),
                    destinationDistance = math.floor(distance),
                })
            end



            --Vdist(currentpos.x, currentpos.y, currentpos.z, destination.x, destination.y, destination.z)

            --z yi 0 verdiğimde daha iyi çalıştı
            --GetDistanceBetweenCoords(currentpos.x, currentpos.y, currentpos.z, coord.x, coord.y, coord.z, false)
            --#(coord - currentpos) --hata var
            --print("distance: ", distance)
            if GetScriptTaskStatus(ped, 0x21D33957) == 7 or distance <= 8.0 then
                --print("151 task finish script", GetScriptTaskStatus(ped, 0x21D33957), "distance: ", distance)
                SendNUIMessage({
                    action = "gfx:client:autopilot:otopilotActive",
                    active = false,
                })
                if emergency then
                    --print("emergency task")
                    StopVehSpeed(vehicle)
                    StartVehicleAlarm(vehicle)
                    SetVehicleAlarmTimeLeft(vehicle, 10000)
                    ClearPedTasks(ped)
                    Notify(ConfigPilot.Texts["reach_destination"])
                    AutoPilotActive = false
                    if ped ~= PlayerPedId() then
                        DeleteEntity(ped)
                    end
                else
                    StopVehSpeed(vehicle)
                    --print("not emergency task finish")
                    ClearPedTasks(ped)
                    Notify(ConfigPilot.Texts["reach_destination"])
                    AutoPilotActive = false
                    if ped ~= PlayerPedId() then
                        DeleteEntity(ped)
                    end
                end
            end
        end
    end)
end

local placingObject = false
local parkingStyle = 1
local parkingStart = false
local parkingActive = false
function ParkVehicle()
    Citizen.CreateThread(function()
        if parkingActive then
            parkingActive = false
            if npcdriver ~= nil then
                DeleteEntity(npcdriver)
                npcdriver = nil
                DeleteEntity(placingObject)
            end
            ClearPedTasks(PlayerPedId())
            Notify(ConfigPilot.Texts.parkingPilot_stop, "error")
            return
        else
            parkingActive = true
            Notify(ConfigPilot.Texts.parkingPilot, "success")
        end
        local driverSeat = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
        local ped
        if  driverSeat ~= PlayerPedId() then
            npcdriver= MakeDriverForMe(GetVehiclePedIsIn(PlayerPedId(), false))
            ped =  npcdriver
        else
            ped = PlayerPedId()
        end

        local vehicle = GetVehiclePedIsIn(ped, false)
        placingObject = CreateVehicle(GetEntityModel(GetVehiclePedIsIn(ped, false)), 0, 0, 0, 0, false, false)
        local r,g,b = GetVehicleColor(vehicle)
        SetEntityCollision(placingObject, false, false)
        SetVehicleColours(placingObject, r, r)
        SetEntityAlpha(placingObject, 150, false)
        SetVehicleCustomPrimaryColour(placingObject, r, g, b)
        SetVehicleCustomSecondaryColour(placingObject, r, g, b)

        while placingObject do
            Citizen.Wait(1)
            DisableControls()
            local vehheading = GetEntityHeading(placingObject)
            local hit, coords, surfaceNormal = RayCastGamePlayCamera(25.0)
            if hit and parkingStart == false then --selecting
                local x, y, z = table.unpack(coords)
                SetEntityCoords(placingObject, x, y, z, 0, 0, 0, false)
                SetEntityDrawOutline(placingObject, true)
                SetEntityDrawOutlineColor(0, 255, 0, 255)
            end
            if IsControlJustPressed(0, ConfigPilot.Keys.H) then --cancelling
                DeleteEntity(placingObject)
                placingObject = false
                parkingActive = false
                return
            end
            if IsControlPressed(0, ConfigPilot.Keys["RIGHT_ARROW"]) then
                SetEntityHeading(placingObject, vehheading + 1)
            end
            if IsControlPressed(0, ConfigPilot.Keys["LEFT_ARROW"]) then
                SetEntityHeading(placingObject, vehheading - 1)
            end
            if IsControlJustPressed(0, ConfigPilot.Keys["E"]) then
                Pos = GetEntityCoords(placingObject)
                parkingStart = true
                local heading = GetEntityHeading(placingObject)
                SetEntityCoordsNoOffset(placingObject, Pos.x, Pos.y, Pos.z, 0, 0, 0, false)
                SetEntityHeading(placingObject, heading)
                FreezeEntityPosition(placingObject, true)
                -- if parkingStyle == 0 then
                --     TaskVehiclePark(ped, vehicle, pos.x, pos.y, pos.z, heading, parkingStyle, 20.0, true)
                -- else
                --if parkingStyle == 1 then
                    TaskVehiclePark(ped, vehicle, Pos.x, Pos.y, Pos.z, heading, parkingStyle, 20.0, true)
                --elseif parkingStyle == 2 then
                    --TaskVehiclePark(ped, vehicle, pos.x, pos.y, pos.z, heading, parkingStyle, 20.0, false)
                --end
                --print("parkpos:", Pos, "parkheading:", heading)
                
                
                DeleteEntity(placingObject)
                placingObject = false
            end

            if parkingStart then
                local parkpos = Pos
                local vehpos = GetEntityCoords(vehicle)
                local distance = GetDistanceBetweenCoords(parkpos.x, parkpos.y, parkpos.z, vehpos.x, vehpos.y, vehpos.z, false)
                --local dist = #(GetEntityCoords(Pos) - GetEntityCoords(vehicle))
                --print(#(GetEntityCoords(pos) - GetEntityCoords(vehicle)))
                --print("distance",distance)
                --print("park status",GetScriptTaskStatus(ped, 0xEFC8537E))
                if GetScriptTaskStatus(ped, 0xEFC8537E) == 7  then
                    --print("parking finish")
                    ClearPedTasks(ped)
                    DeleteEntity(placingObject)
                    placingObject = false
                    parkingStart = false
                    parkingActive = false
                    Notify(ConfigPilot.Texts.parkingPilot_stop, "primary")
                    if npcdriver ~= nil then
                        DeleteEntity(npcdriver)
                        npcdriver = nil
                    end
                    break
                end
            end
        end
    end)
end

local dancing = false
function DanceCar()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if dancing then
            for i = 0, 7 do
                SetVehicleDoorShut(vehicle, i, false)
            end
            dancing = false
            --ClearPedTasks(ped)
            local str = string.format(ConfigPilot.Texts.stopped_dancing, AutoPilotName)
            Notify(str, "error")

            return
        else
            dancing = true
            local str = string.format(ConfigPilot.Texts.started_dancing, AutoPilotName)
            Notify(str, "success")
        end
        while dancing do
            local randomDoor = math.random(0, 7)
            SetVehicleDoorOpen(vehicle, math.random(0, 7), false, false)
            SetVehicleDoorShut(vehicle, math.random(0, 7), false)
            Citizen.Wait(100)
        end
    end)
end

function StopVehSpeed(vehicle)
    CreateThread(function()
        BringVehicleToHalt(vehicle, 5.0, 1, 0)
        -- while not IsVehicleStopped(vehicle) do
        --     Citizen.Wait(0)
        --     TaskVehicleTempAction(driverped, vehicle, 27, 1000)
        --     Citizen.Wait(200)
        --     print("stopveh func-speed: ", GetEntitySpeed(vehicle))
        -- end
    end)
end

function Comehere()
    CreateThread(function()
        if not DoesEntityExist(claimedVeh) then
            claimedVeh = nil
            Notify(ConfigPilot.Texts.cant_come, "error")
            return
        end
        --local blip = CreateBlipEntity(claimedVeh)
        local pedpos = GetEntityCoords(PlayerPedId())
        -- eğer başka bir sürücü varsa sürücüyü araçtan at
        local driverSeat = GetPedInVehicleSeat(claimedVeh, -1)
        if driverSeat ~= 0 and driverSeat ~= PlayerPedId() and IsPedInVehicle(PlayerPedId(), claimedVeh, false) == false then
            TaskLeaveVehicle(driverSeat, claimedVeh, 4160)
        end
        local valedriver = MakeDriverForMe(claimedVeh)

        loadAnimDict("anim@mp_player_intmenu@key_fob@")
        TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, 1000, 49, 0, false, false, false)
        --print("vehpos: ", vehpos)
        TaskVehicleDriveToCoordLongrange(valedriver, claimedVeh, pedpos.x, pedpos.y, pedpos.z, ConfigPilot.ComehereModSpeed, ConfigPilot.ComehereModDriveStyle, 8.0)

        while valedriver do
            Wait(10)
            --print("comehere task status: ", GetScriptTaskStatus(valedriver, 0x21D33957))
            pedpos = GetEntityCoords(PlayerPedId())
            local vehiclepos = GetEntityCoords(claimedVeh)
            local distance = #(vehiclepos - pedpos)
            --GetDistanceBetweenCoords(pedpos, vehiclepos, false) 
            --print("distance: ", distance)
            if distance < 9 then
                SetVehicleForwardSpeed(claimedVeh, 0.0)
                SetVehicleDoorOpen(claimedVeh, 0, false, false)
                --ClearPedTasks(valedriver)
                --ClearVehicleTasks(claimedVeh)
                DeleteEntity(valedriver)
                --RemoveBlip(blip)
                valedriver = nil
                local str = string.format(ConfigPilot.Texts.vehicle_came_to_you, AutoPilotName)
                Notify(str)
                break
            end
        end
    end)
end

function MakeDriverForMe(currentveh)
    local model = GetHashKey("S_M_M_HighSec_01")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local driverped = CreatePedInsideVehicle(currentveh, 4, model, -1, false, false)
    SetEntityAlpha(driverped, 0, true)
    SetDriverAbility(driverped, 1.0)
    SetDriverAggressiveness(driverped, 0.0)
    SetEntityInvincible(driverped, true)
    SetPedCanRagdoll(driverped, false)
    SetPedDiesWhenInjured(driverped, false)
    SetPedCanPlayInjuredAnims(driverped, false)
    
    SetBlockingOfNonTemporaryEvents(driverped, true)
    TaskSetBlockingOfNonTemporaryEvents(driverped, true)
    SetPedKeepTask(driverped, true)
    return driverped
end

--#region
function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination
        .x, destination.y, destination.z, -1, -1, 1))
    return b, c, e
end

function DisableControls()
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 170, true)
    DisableControlAction(0, 167, true)
    DisableControlAction(0, 26, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(0, 59, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(2, 36, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(27, 75, true)
end
local directionOffsets = {
    --["left"] = vector3(-1.0, 0.0, 0.0),
    --["right"] = vector3(1.0, 0.0, 0.0),
    ["front"] = vector3(0.0, 1.0, 0.02),
    --["frontRight"] = vector3(1.0, 1.0, 0.0),
    --["frontLeft"] = vector3(-1.0, 1.0, 0.0),
    --["mid-right"] = vector3(0.5, 1.5, 0.0),
    --["mid-left"] = vector3(-0.5, 1.5, 0.0),
    --["little-left"] = vector3(-0.2, 1.0, 0.0),
    --["little-right"] = vector3(0.2, 1.0, 0.0),
    ["crossRight"] = vector3(0.5, 1.5, 0.02),
    ["crossLeft"] = vector3(-0.5, 1.5, 0.02),
}
--#endregion
local rayLength = 20.0
function CheckDirectionsForVehicles(vehicle)
    --local vehpos = GetEntityCoords(vehicle)
    for k, v in pairs(directionOffsets) do
        local playerPos = GetEntityCoords(vehicle)
        local playerOffset = GetOffsetFromEntityInWorldCoords(vehicle, v.x * rayLength, v.y * rayLength, v.z * rayLength)
        --DrawLine(playerPos.x, playerPos.y, playerPos.z, playerOffset.x, playerOffset.y, playerOffset.z, 255,0, 0,255)
        local rayHandle = StartShapeTestRay(playerPos.x, playerPos.y, playerPos.z, playerOffset.x,playerOffset.y, playerOffset.z, 2, vehicle, 0)
        local _, hit, endCoords, _, entity = GetShapeTestResult(rayHandle)
        if entity ~= 0 and IsEntityAVehicle(entity) then
            --print("key:"..k, "value:"..v, "vehicle:"..vehicle)
            --DrawLine(playerPos.x, playerPos.y, playerPos.z, endCoords.x, endCoords.y, endCoords.z, 0, 255, 0,255)
            SendNUIMessage({
                action = "gfx:copilot:vehicleInDirection",
                direction = k,
            })
        else
            SendNUIMessage({
            action = "gfx:copilot:vehicleInNotDirection",
            direction = k,
            })
        end
    end
end

RegisterNetEvent("es:GroupChanged")
AddEventHandler("es:GroupChanged", function(gp)
    PlayerData.group = gp
end)

Active = false

AddEventHandler("onKeyDown", function(key)
    if key == "g" then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if IsPedInAnyVehicle(ped, false) then
            local class = GetVehicleClass(vehicle)
            if class == 16 or class == 15 then return end
            Active = not Active
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local model = GetEntityModel(vehicle)
        if ConfigPilot.Vehicles[model] or PlayerData.group == "premium" and Active then
            sleep = 1
            if IsControlJustPressed(0, ConfigPilot.Keys.K) then -- open cursor
                SetNuiFocus(true, true)
            end
            if AutoPilotActive then
                if IsControlJustPressed(0, ConfigPilot.Keys.U) then --cancel trip
                    if npcdriver ~= nil then
                        StopVehSpeed(GetVehiclePedIsIn(npcdriver, false))
                        Wait(200)
                        ClearPedTasks(npcdriver)
                        DeleteEntity(npcdriver)
                        npcdriver = nil
                        AutoPilotActive = false
                        Notify(string.format(ConfigPilot.Texts.autoPilot_stop, AutoPilotName), "primary")
                    else
                        StopVehSpeed(GetVehiclePedIsIn(PlayerPedId(), false))
                        ClearPedTasks(PlayerPedId())
                        AutoPilotActive = false
                        Notify(string.format(ConfigPilot.Texts.autoPilot_stop, AutoPilotName), "primary")
                    end
                    SendNUIMessage({
                        action = "gfx:client:autopilot:otopilotActive",
                        active = false,
                    })
                end
            end
            if parkingActive then
                if IsControlJustPressed(0, ConfigPilot.Keys.U) then --cancel parking
                    if npcdriver ~= nil then
                        DeleteEntity(npcdriver)
                        npcdriver = nil
                    end
                    ClearPedTasks(PlayerPedId())
                    Notify(ConfigPilot.Texts.parkingPilot_stop, "error")
                    parkingActive = false
                end
            end
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if not IsPedInAnyVehicle(ped, false) then
            Active = false
        end
        if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) ~= ped then
            Active = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        local vehicle = GetVehiclePedIsIn(ped, false)
        local model = GetEntityModel(vehicle)
        if Active and (PlayerData.group == "premium" or (ConfigPilot.Vehicles[model] and GetPedInVehicleSeat(vehicle, -1) == ped) or ConfigPilot.Vehicles[model] and GetPedInVehicleSeat(vehicle, -1) == 0 or ConfigPilot.Vehicles[model] and GetPedInVehicleSeat(vehicle, -1) == npcdriver) then
            sleep = 200
            local vehpos = GetEntityCoords(vehicle)
            local t = { h = GetClockHours(), m = GetClockMinutes(), d = GetClockDayOfWeek() }
            local speed = 0
            local speedlimit = ConfigPilot.SpeedLimits[GetStreetNameFromHashKey(GetStreetNameAtCoord(vehpos.x, vehpos.y, vehpos.z))]

            if ConfigPilot.UseKmh == "kmh" then
                speed = GetEntitySpeed(vehicle) * 3.6
            elseif ConfigPilot.UseKmh == "mph" then
                speed = GetEntitySpeed(vehicle) * 2.236936
            end
            SendNUIMessage({
                action = "gfx:copilot:openAndProcessData",
                mypos = GetEntityCoords(vehicle),
                speed = speed,
                fuel = exports["LegacyFuel"]:GetFuel(vehicle),
                speedLimit = speedlimit,
                time = t,
            })
            CheckDirectionsForVehicles(vehicle)
            if claimedVeh == nil or claimedVeh ~= vehicle then
                claimedVeh = vehicle
            end
        else
            if npcdriver ~= nil then --oyuncu araçta değilken npc driver varsa
                AutoPilotActive = false
                ClearPedTasks(npcdriver)
                StopVehSpeed(vehicle)
                DeleteEntity(npcdriver)
                npcdriver = nil
            end
            SendNUIMessage({
                action = "gfx:autopilot:close",
            })
            sleep = 1000
        end
        Wait(sleep)
    end
end)

function table.find(tbl, search)
    for k, v in ipairs(tbl) do
        if v == search then
            return true
        end
    end
    return false
end

RegisterCommand("comehere", function() --açıklama yaz
    Comehere()
end, false)

--#region CreateCallback
RegisterNUICallback("gfx:client:autopilot:emptyDriverSeat", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetPedInVehicleSeat(vehicle, -1) == 0 then
        cb("empty")
    elseif GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        cb("iAmDriver")
    else
        cb("otherdriver")
    end
end)
RegisterNUICallback("gfx:client:autopilot:exit", function(data)
    SetNuiFocus(data, data)
end)
RegisterNUICallback("gfx:client:autopilot:ready", function(data, cb)
    cb(ConfigPilot.FixedLocations)
end)
RegisterNUICallback("gfx:client:autopilot:emergency", function(data)
    -- if ConfigPilot.UseKmh == "kmh" then
    --     _, Speed = Convertspeed(GetVehiclePedIsIn(PlayerPedId(), false))
    -- elseif ConfigPilot.UseKmh == "mph" then
    --     Speed, _ = Convertspeed(GetVehiclePedIsIn(PlayerPedId(), false))
    -- end
    if data.seatFree == "empty" then
        npcdriver = MakeDriverForMe(GetVehiclePedIsIn(PlayerPedId(), false))
        StartAutoPilot(npcdriver, ConfigPilot.speedMultiplier.emergency, ConfigPilot.EmergencyLocation,ConfigPilot.EmergencyDrivingStyle, true)
    elseif data.seatFree == "iAmDriver" then
        StartAutoPilot(PlayerPedId(), ConfigPilot.speedMultiplier.emergency, ConfigPilot.EmergencyLocation,ConfigPilot.EmergencyDrivingStyle, true)
    else
        Notify(ConfigPilot.Texts.driver_in_vehicle, "error")
    end
end)
RegisterNUICallback("gfx:client:autopilot:dance", function()
    DanceCar()
end)
RegisterNUICallback("gfx:client:autopilot:park", function()
    ParkVehicle()
end)
RegisterNUICallback("gfx:client:autopilot:comehere", function()
    Comehere()
end)
RegisterNUICallback("gfx:client:autopilot:openHood", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorOpen(vehicle, 4, false, false)
    end
end)
RegisterNUICallback("gfx:client:autopilot:openTrunk", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
        SetVehicleDoorShut(vehicle, 5, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end)
RegisterNUICallback("gfx:client:autopilot:Notify", function()
    Notify(ConfigPilot.Texts.otopilot_active_cant_park , "primary")
end)
RegisterNUICallback("gfx:client:autopilot:route", function(data)
    --local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    -- if ConfigPilot.UseKmh == "kmh" then
    --     _, Speed = Convertspeed(vehicle)
    -- elseif ConfigPilot.UseKmh == "mph" then
    --     Speed, _ = Convertspeed(vehicle)
    -- end

    if data.type == "custom" then
        --print(json.encode(data))
        local coord = {}
        coord.x = tonumber(data.coordx)
        coord.y = tonumber(data.coordy)

        SetNewWaypoint(coord.x, coord.y)
        local test = GetBlipCoords(GetFirstBlipInfoId(8))
        local _, z = GetGroundZFor_3dCoord(coord.x, coord.y, test.z, false)

        coord.z = z
        DrivingStyle = data.driveStyle
        --print(DrivingStyle)

        if data.seatFree == "empty" then
            npcdriver = MakeDriverForMe(GetVehiclePedIsIn(PlayerPedId(), false))
            --print("npcdriver: ", npcdriver)
            StartAutoPilot(npcdriver, ConfigPilot.speedMultiplier[data.speedType], coord, DrivingStyle, false)
            --print("npcdriver: ", npcdriver)
        elseif data.seatFree == "iAmDriver" then
            StartAutoPilot(PlayerPedId(),  ConfigPilot.speedMultiplier[data.speedType], coord, DrivingStyle, false)
        else
            Notify(ConfigPilot.Texts.driver_in_vehicle, "error")
        end
    elseif data.type == "fixed" then
        --print(json.encode(data))
        DrivingStyle = data.driveStyle
        --print(data.seatFree)
        if data.seatFree == "empty" then
            npcdriver = MakeDriverForMe(GetVehiclePedIsIn(PlayerPedId(), false))
            StartAutoPilot(npcdriver,  ConfigPilot.speedMultiplier[data.speedType],
                ConfigPilot.FixedLocations[data.location].coords, DrivingStyle, false)
        elseif data.seatFree == "iAmDriver" then
            StartAutoPilot(PlayerPedId(),  ConfigPilot.speedMultiplier[data.speedType],
                ConfigPilot.FixedLocations[data.location].coords, DrivingStyle, false)
        else
            Notify(ConfigPilot.Texts.driver_in_vehicle, "error")
        end
    elseif data.type == "saved" then
        --print(json.encode(data))
        DrivingStyle = data.driveStyle
        local coord = {}
        coord.x = tonumber(data.coordx)
        coord.y = tonumber(data.coordy)
        SetNewWaypoint(coord.x, coord.y)
        local test = GetBlipCoords(GetFirstBlipInfoId(8))
        local _, z = GetGroundZFor_3dCoord(coord.x, coord.y, test.z, false)
        coord.z = z
        --print(coord.x, coord.y, coord.z, _)
        if data.seatFree == "empty" then
            npcdriver = MakeDriverForMe(GetVehiclePedIsIn(PlayerPedId(), false))
            StartAutoPilot(npcdriver,  ConfigPilot.speedMultiplier[data.speedType], coord, DrivingStyle, false)
        elseif data.seatFree == "iAmDriver" then
            StartAutoPilot(PlayerPedId(),  ConfigPilot.speedMultiplier[data.speedType], coord, DrivingStyle, false)
        else
            Notify(ConfigPilot.Texts.driver_in_vehicle, "error")
        end
    end
end)
RegisterNUICallback("gfx:client:autopilot:cancelTrip", function()
    if AutoPilotActive then
        if npcdriver ~= nil then
            StopVehSpeed(GetVehiclePedIsIn(npcdriver, false))
            Wait(200)
            ClearPedTasks(npcdriver)
            DeleteEntity(npcdriver)
            npcdriver = nil
            AutoPilotActive = false
            Notify(string.format(ConfigPilot.Texts.autoPilot_stop, AutoPilotName), "primary")
        else
            StopVehSpeed(GetVehiclePedIsIn(PlayerPedId(), false))
            ClearPedTasks(PlayerPedId())
            AutoPilotActive = false
            Notify(string.format(ConfigPilot.Texts.autoPilot_stop, AutoPilotName), "primary")
        end
        SendNUIMessage({
            action = "gfx:client:autopilot:otopilotActive",
            active = false,
        })
    else
        Notify(string.format(ConfigPilot.Texts.autoPilot_not_active, AutoPilotName), "error")
    end
end)
RegisterNUICallback("gfx:client:autopilot:cursor", function()
SetNuiFocus(true, true)
end)
RegisterNUICallback("gfx:client:autopilot:AutoPilotName", function(data)
    AutoPilotName = data.name
end)
--#endregion


function Convertspeed(vehicle)
    local speed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
    local mph = speed / 1.207
    local kmh = mph * 1.609
    return mph, kmh
end
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if npcdriver ~= nil then
            DeleteEntity(npcdriver)
            ClearPedTasks(npcdriver)
            npcdriver = nil
        end
        AutoPilotActive = false
        ClearPedTasks(PlayerPedId())
    end
end)
--[[   https://discord.gg/vf1    ]]      