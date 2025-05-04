---@diagnostic disable: missing-parameter, undefined-field, undefined-global
ESX = nil
local PlayerData = {}
local testDriveVeh = nil
local inTestDrive = false
local vehicleShopPed = nil


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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function (gang)
	PlayerData.gang = gang
end)

RegisterNetEvent("esx_vehicleshop:sendData")
AddEventHandler("esx_vehicleshop:sendData", function(data)
    Config.Vehicles = data
end)

function InitializePed()
    local model = Config.PedModel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    vehicleShopPed = CreatePed(4, model, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z - 1.0, Config.PedLocation.w, false, true)
    FreezeEntityPosition(vehicleShopPed, true)
    SetBlockingOfNonTemporaryEvents(vehicleShopPed, true)

    local blip = AddBlipForCoord(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)
    SetBlipSprite(blip, 225)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehicle Shop")
    EndTextCommandSetBlipName(blip)

    exports['diamond_target']:AddTargetEntity(vehicleShopPed, {
        options = {
            {
                icon = 'fas fa-car',
                label = 'Browse Vehicles',
                action = function()
                    TriggerEvent('esx_vehicleshop:client:openShop')
                end,
                distance = 2.5,
            }
        }
    })
end

function EndTestDrive(reason)
    if testDriveVeh then

        DeleteVehicle(testDriveVeh)
        testDriveVeh = nil
        inTestDrive = false
        ESX.SetEntityCoords(PlayerPedId(), Config.DealershipCoords)
        ESX.ShowNotification(reason or "Test drive completed!")
        SendNUIMessage({
            action = "testDriveEnded"
        })

        Wait(100)
        SendNUIMessage({
            action = "resetTestDrive"
        })
        TriggerServerEvent("backme")
    end
end

function StartExitCheck()
    CreateThread(function()
        while inTestDrive and testDriveVeh do
            Wait(500)
            if not IsPedInVehicle(PlayerPedId(), testDriveVeh, false) then
                EndTestDrive("You exited the vehicle. Test drive cancelled.")
                break
            end
        end
    end)
end

function StartTestDriveCountdown()
    if inTestDrive then return end

    local timeLeft = Config.TestDriveTime
    inTestDrive = true

    SendNUIMessage({
        action = "updateTestDriveTime",
        time = timeLeft
    })

    StartExitCheck()


    CreateThread(function()
        while timeLeft > 0 and inTestDrive do
            Wait(1000)
            timeLeft = timeLeft - 1

            if not inTestDrive then break end

            SendNUIMessage({
                action = "updateTestDriveTime",
                time = timeLeft
            })
        end

        if inTestDrive then
            EndTestDrive()
        end
    end)
end

function SpawnVehicle(model, coords, testDrive, plate)
    if testDrive and inTestDrive then
        ESX.ShowNotification("Already in a test drive!")
        return
    end

    if not IsModelInCdimage(GetHashKey(model)) then
        ESX.ShowNotification("Invalid vehicle!")
        return
    end

    local modelValid = false
    for _, category in pairs(Config.Vehicles) do
        for _, vehicle in pairs(category) do
            if vehicle.model == model then
                modelValid = true
                break
            end
        end
        if modelValid then break end
    end

    if not modelValid then
        TriggerClientEvent('esx:showNotification', src, 'Invalid vehicle!')
        return
    end

    local dealershipCoords = vector3(Config.DealershipCoords.x, Config.DealershipCoords.y, Config.DealershipCoords.z)
    DoScreenFadeOut(100)
    
    if testDrive then
        TriggerServerEvent("vehisleshop:testWorld")
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
        Citizen.Wait(2500)
    end

    --hey zendegi
    local func = ESX.Game.SpawnVehicle
    if testDrive then
        func = ESX.Game.SpawnLocalVehicle
    end

    func(model, coords, coords.w, function(vehicle)
        if not DoesEntityExist(vehicle) then 
            ESX.ShowNotification("Failed to spawn vehicle!")
            return
        end

        SetEntityHeading(vehicle, coords.w)
        SetVehicleNumberPlateText(vehicle, plate or "TEST")
        if not testDrive then
            ESX.CreateVehicleKey(vehicle)
        end
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleModKit(vehicle, 0)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

        if testDrive then
            SetVehicleDoorsLocked(vehicle, 2)
            SetVehicleMaxSpeed(vehicle, 130.0)
            testDriveVeh = vehicle
            StartTestDriveCountdown()
        else
            local props = ESX.Game.GetVehicleProperties(vehicle)
            TriggerServerEvent('esx_vehicleshop:server:setVehicleOwned', props)
        end
        DoScreenFadeIn(100)
    end)
end

RegisterNUICallback('testDrive', function(data, cb)
    if not inTestDrive then
        
        SpawnVehicle(data.model, Config.TestDriveCoords, true)
        SetNuiFocus(false, false)
        ESX.ShowNotification("Test drive started! You have " .. Config.TestDriveTime .. " seconds.")
    else
        ESX.ShowNotification("You're already test driving a vehicle!")
    end
    cb('ok')
end)

RegisterNUICallback('buyVehicle', function(data, cb)
    if inTestDrive then
        EndTestDrive()
    end
    if data.forGang then
        TriggerServerEvent('esx_vehicleshop:server:buyVehicleForGang', data.model, data.price)
    else
        TriggerServerEvent('esx_vehicleshop:server:buyVehicle', data.model, data.price)
    end
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    if inTestDrive then
        EndTestDrive("Test drive cancelled")
    end
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent("esx_vehicleshop:client:openShop")
AddEventHandler("esx_vehicleshop:client:openShop", function()
    if inTestDrive then
        ESX.ShowNotification("Finish your test drive first!")
        return
    end

    inTestDrive = false
    if testDriveVeh then
        DeleteVehicle(testDriveVeh)
        testDriveVeh = nil
    end

    local gang = nil
    
    if PlayerData.gang and PlayerData.gang.name ~= 'nogang' then
        gang = PlayerData.gang.name
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        categories = Config.Categories,
        vehicles = Config.Vehicles,
        gang = gang
    })
end)

RegisterNetEvent("esx_vehicleshop:client:successfulBuy")
AddEventHandler("esx_vehicleshop:client:successfulBuy", function(model, plate)
    if GetInvokingResource() then return end
    SpawnVehicle(model, Config.VehicleSpawnCoords, false, plate)
    ESX.ShowNotification("Congratulations on your purchase! Vehicle spawned outside!")
end)

Citizen.CreateThread(function()
    Wait(1000)
    InitializePed()
end)

Citizen.CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)