lib.locale()


ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Wait(100)
    end
end)

RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
    TriggerServerEvent("d-houserobbery:sync")
    TriggerServerEvent("d-houserobbery:missionsync2")
end)

RegisterNetEvent("d-houserobbery:notify")
AddEventHandler("d-houserobbery:notify", function(type, title, text)
    Notify(type, title, text)
end)

Notify = function(type, title, text)
    ESX.ShowNotification(text)
end

ProgressBar = function(duration, label)
    exports['mythic_progbar']:Progress({
        name = "house_robbery",
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }
    })
    Wait(duration)
end

TextUIShow = function(text)
    lib.showTextUI(text)
end

IsTextUIShowed = function()
    return lib.isTextUIOpen()
end

TextUIHide = function()
    lib.hideTextUI()
end

Draw3DText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    
    if onScreen then
        SetTextFont(Config.FontId)
        SetTextScale(0.33, 0.30)
        SetTextDropshadow(10, 100, 100, 100, 255)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 350
        DrawRect(_x,_y+0.0135, 0.025+ factor, 0.03, 0, 0, 0, 10)
    end
end

--Exports
Target = function()
    if Config.InteractionType == 'target' then
        return exports['qtarget']
    else
        return nil
    end
end

Dispatch = function(coords, type)
    if Config.Dispatch.enabled then
        if type == "houserobbery" then
            exports["ps-dispatch"]:CustomAlert({
                coords = coords,
                message = "House Robbery",
                dispatchCode = "10-90",
                description = "Alarm detected a house robbery",
                radius = 0,
                sprite = 40,
                color = 1,
                scale = 1.2,
                length = 3,
            })
        end
    end
end

function CheckJob()
    local HasJob = false
    for _, job in pairs(Config.PoliceJobs) do
        if GetJob() == job or job == nil or not job then
            HasJob = true
        end
    end
    if HasJob then
        return true
    else
        return false
    end
end

function GetJob()
    return ESX.GetPlayerData().job.name
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = cache.ped
        coords = GetEntityCoords(playerPed)
    end

    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end

    return nearbyEntities
end

function GetAvailableVehicleSpawnPoint(SpawnPoints)
    local spawnPoints = SpawnPoints
    local found, foundSpawnPoint = false, nil

    for i = 1, #spawnPoints, 1 do
        if IsSpawnPointClear(spawnPoints[i].Coords, spawnPoints[i].Radius) then
            found, foundSpawnPoint = true, spawnPoints[i]
            break
        end
    end

    if found then
        return true, foundSpawnPoint
    else
        Notify("error", locale("error"), locale("FreeSpace"))
        return false
    end
end

function GetVehicles()
    return GetGamePool('CVehicle')
end

function GetVehiclesInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(GetVehicles(), false, coords, maxDistance)
end

function IsSpawnPointClear(coords, maxDistance)
    return #GetVehiclesInArea(coords, maxDistance) == 0
end

SpawnVehicle = function(model, coords, heading)
    ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle)
        SetEntityHeading(vehicle, heading)
    end)
end

GetClosestCar = function(coords)
    return ESX.Game.GetClosestVehicle(coords)
end

HackingMinigame = function()
    local success = false
    TriggerEvent('mhacking:show')
    TriggerEvent('mhacking:start', 3, 30, function(outcome)
        TriggerEvent('mhacking:hide')
        success = outcome
    end)
    while success == false do
        Wait(100)
    end
    return success
end

LockPickMinigame = function()
    local luck = math.random(0,99)
    local success = createSafe({luck})
    return success
end

local minigamefinished = nil
DoorLockPickMinigame = function()
    local success = exports['ps-ui']:Circle(function(success)
        if success then
            print("success")
        else
            print("fail")
        end
    end, 4, 10)
    return success
end


AlarmSound = function()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 20.0, "alarm", 0.35)
end

DoorSound = function()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
end

RegisterNetEvent("d-houserobbery:lootbag")
AddEventHandler("d-houserobbery:lootbag", function()
    lib.requestAnimDict("anim@heists@ornate_bank@grab_cash")
    TaskPlayAnim(cache.ped, "anim@heists@ornate_bank@grab_cash", "intro", 3.0, 1.0, -1, 49, 0, false, false, false)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    Wait(1400)
    ClearPedTasks(cache.ped)
    SetPedComponentVariation(cache.ped, 5, Config.NeedBag.var, Config.NeedBag.color, 0)
end)

OnHouseEnter = function()
    if Config.TimeChange and Config.TimeSync == "realtime" then
        TriggerServerEvent("realtime:event")
    end
end

OnHouseLeave = function()
    if Config.TimeChange and Config.TimeSync == "realtime" then
        TriggerServerEvent("realtime:event")
    end
end