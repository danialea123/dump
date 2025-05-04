---@diagnostic disable: missing-parameter
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

postNUI = function(data)
    SendNUIMessage(data)
end

OpenDMV = function()
    ESX.TriggerServerCallback('esx_dmv:getData', function(licenses, money, bank) 
        postNUI({
            type = "SET_CONFIG",
            config = Config
        })
        postNUI({
            type = "SET_MONEY",
            contanti = bank,
            banca = bank
        })
        postNUI({
            type = "OPEN",
            licenses = licenses,
            license = Config.License
        })
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(500)
    end)
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
end)

RegisterNUICallback('removeMoney', function(data)
    local account = data.account
    local amount = tonumber(data.amount)
    TriggerServerEvent('esx_dmv:removeMoney', amount)
end)

RegisterNetEvent('esx_dmv:updateLicense')
AddEventHandler('esx_dmv:updateLicense', function()
    ESX.TriggerServerCallback('esx_dmv:getData', function(licenses) 
        postNUI({
            type = "UPDATE_LICENSE",
            licenses = licenses,
        })
    end)
end)

RegisterNUICallback('theoryOk', function(data)
    local license = data.license
    onCompleteTheory(license)
end)

RegisterNUICallback('practiceOk', function(data)
    local license = data.license
    onCompletePractice(license)
end)

local step = 0
local maxSpeed = nil
local sleep = 1000
local error = 0

SetUpMarker = function()
    step = step + 1
    local randomNumber = math.random(1, #Config.PracticeCoords)
    local coords = Config.PracticeCoords[randomNumber]
    coords = coords[step]
    if coords == nil then
        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        postNUI({
            type = "DISPLAY_RISULTATO",
            errori = error,
        })
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(500)
        step = 0
        error = 0
        sleep = 1000
        return
    end
    maxSpeed = coords.speedLimit or nil
    coords = coords.coordinate
    SetNewWaypoint(coords.x, coords.y)
    sleep = 0
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(sleep)
            DrawMarker(Config.MarkerSettings.type, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, Config.MarkerSettings.size, Config.MarkerSettings.color, 100, Config.MarkerSettings.bump, true, 2, Config.MarkerSettings.rotate, false, false, false)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= nil then
                local speed = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
                if maxSpeed ~= nil and speed > maxSpeed then
                    sleep = 1000
                    error = error + 1
                    ESX.ShowNotification("Sorat Shoma Kheily Ziad Ast!, Ekhtar: "..error.."/10")
                else
                    sleep = 0
                end
            else
                sleep = 1000
                error = error + 1
                ESX.ShowNotification("Savar Mashin Shavid!, Ekhtar: "..error.."/10")
            end
            local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, GetEntityCoords(PlayerPedId()), true)
            if distance < 1.5 and IsPedInAnyVehicle(PlayerPedId()) then
                SetUpMarker()
                break 
            end
        end
    end)
end

RegisterNUICallback('startPractice', function(data)
    local license = data.license 
    for k,v in pairs(Config.License) do 
        if v.id == license then
            local vehicle = v.vehicle
            ESX.Game.SpawnVehicle(vehicle.model, vehicle.coords, vehicle.heading, function(veh) 
                ESX.CreateVehicleKey(veh)
                --SetVehicleNumberPlateText(veh, vehicle.plate)
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
            end)
        end
    end
    SetUpMarker()
end)

local sleep2 = 1000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep2)
        for k,v in pairs(Config.DMVSchool) do 
            DrawMarker(Config.MarkerSettings.type, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, Config.MarkerSettings.size, Config.MarkerSettings.color, 100, Config.MarkerSettings.bump, true, 2, Config.MarkerSettings.rotate, false, false, false)
            local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(PlayerPedId()), true)
            if distance < 5.5 then
                sleep2 = 0
                ESX.ShowHelpNotification(Config.Lang[Config.Language]["open_dmv"])
                if IsControlJustReleased(0, 38) then
                    OpenDMV()
                end
            else
                sleep2 = 1000
                Citizen.Wait(700)
            end
        end
    end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.DMVSchool[1].x, Config.DMVSchool[1].y, Config.DMVSchool[1].z)

	SetBlipSprite (blip, 545)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Amoozeshgah Ranandegi")
	EndTextCommandSetBlipName(blip)
end)
