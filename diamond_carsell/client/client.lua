---@diagnostic disable: lowercase-global, need-check-nil, redundant-return-value, undefined-field
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    Core = ESX
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    SendReactMessage("SetPlayerJob", job.name)
end)

testdrivetext = ""
ontestdrive = false
onpreview = false
dislay = false
camera = false
local pedSpawned = false
local ShopPed = {}

cars = {
}

function contains(tbl, value)
	if type(value) ~= 'table' then
		for _, v in pairs(tbl) do
			if v == value then return true end
		end
	else
		local matched_values = 0
		local values = 0
		for _, v1 in pairs(value) do
			values += 1

			for _, v2 in pairs(tbl) do
				if v1 == v2 then matched_values += 1 end
			end
		end
		if matched_values == values then return true end
	end

	return false
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' was stopped.')
    deletePeds()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' has been started.')
    createBlips()
    createPeds()
end)

RegisterNetEvent('esx:playerLoaded', function()
    createBlips()
    createPeds()
end)

RegisterNUICallback("HasPerm", function(data,cb)
    cb(true)
end)

function ClientCallback(name, data)
    local incomingData = false
    local status = 'UNKOWN'
    local counter = 0
    while ESX == nil do
		Citizen.Wait(1000)
	end

    ESX.TriggerServerCallback(name, function(payload)
        status = 'SUCCESS'
        incomingData = payload
    end, data)

    CreateThread(function()
        while incomingData == 'UNKOWN' do
            Citizen.Wait(1000)
            if counter == 4 then
                status = 'FAILED'
                incomingData = false
                break
            end
            counter = counter + 1
        end
    end)

    while status == 'UNKOWN' do
        Citizen.Wait(0)
    end
    return incomingData
end

function openGallery()
    dislay = not dislay
    cars = {}
    local result =  ClientCallback('savana-carsell:GetVehicles')
    cars = result
    Wait(300)
    SetNuiFocus(dislay, dislay)
    SendReactMessage("SetLang", Config.lang)
    SendReactMessage("SetCars", cars)
    SendReactMessage("SetDisplay", dislay)
    local category = {}
    category[#category + 1] = "all" 
    for k,v in pairs(Config.Class) do
        table.insert(category, v)
    end

    local pData = nil

    if Config.Framework == "oldqb" or Config.Framework == "newqb" then
        pData = Core.Functions.GetPlayerData()
    else
        pData = Core.GetPlayerData()
    end

    if Config.useJob then
        local canOpen = contains(Config.JobName, pData.job.name)
        SendReactMessage("SetPlayerJob", canOpen)
    else
        SendReactMessage("SetPlayerJob", true)
    end
    SendReactMessage("setVehicleCatagories", category)
end

function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end


RegisterNUICallback("CreateAd", function(data) 
    if data.car == nil then
        return
    end

    --[[for _,car in pairs(Config.BlacklistCar) do
        if GetHashKey(car) == data.car.model then
            SendReactMessage("notif", Config.lang.blacklistcar)
            return true
        end
    end]]

    if data.price and tonumber(data.price) >= 24000000 then
        SendReactMessage("notif", "Gheymat Mashin Az 24 Million Nemitavand Bishtar Bashad")
        ESX.Alert("Gheymat Mashin Az 24 Million Nemitavand Bishtar Bashad", "info")
        return
    end

    if data.image == "" then
        data.image = "https://cdn.discordapp.com/attachments/583959415397548063/1144595432308219904/resim-yok.png"
    else
        local extension = string.sub(data.image, -4)
        local validexts = Config.ValidExtensions
        if not validexts[extension] then
            SendReactMessage("notif", Config.lang.notvalidphoto)
            data.image = "https://cdn.discordapp.com/attachments/583959415397548063/1144595432308219904/resim-yok.png"
        end
    end

    local properties = ClientCallback('savana-carsell:GetVehicleProps', data.car.plate)
    local result = ClientCallback('savana-carsell:GetOsTime', data)
    local motor = nil
    if properties["engineHealth"] then
        motor = math.floor(properties["engineHealth"]/10)
    else
        motor = 100
    end
    data["engine"] = motor
    data["dayLeft"] = result + 259200
    data["seat"] = GetVehicleModelNumberOfSeats(data.car.model)
    data["plate"] = properties["plate"]
    data['category'] = KategoriGetir(data.car.model)

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local vehicles = Core.Functions.GetVehicles()
        for k,v in pairs(vehicles) do
            if data.car.plate == GetVehicleNumberPlateText(v) then
                SendReactMessage("notif", Config.lang.notadd)
                return
            end
        end
    end

    TriggerServerEvent('savana-carsell:SellVehicle', properties, data)
end)
RegisterNetEvent('savana-carsell:client:eksi1', function()
    if dislay then
        local car =  ClientCallback('savana-carsell:GetVehicles')
        SendReactMessage("SetCars", car)
    end
end)

function KategoriGetir(model)
    local class = GetVehicleClassFromName(model)
    if Config.Class[class] then
        return Config.Class[class]
    else
        return "Unkown"
    end
end

RegisterNUICallback("Close", function(data) 
    SendReactMessage("SetDisplay", false)
    SetNuiFocus(false, false)
    dislay = false
end)

RegisterNUICallback("BuyVehicle", function(veh) 
    TriggerServerEvent('savana-carsell:BuyVehicle', veh.car.plate)
end)

RegisterNUICallback("TestDrive", function(veh) 
    local result =  ClientCallback('savana-carsell:GetVehicleProperties', veh.plate) 
    if result then
        testdrive(veh.car.model, result)
    else
        testdrive(veh.car.model, false)
    end
end)

function CloseMenu()
    SendReactMessage("SetDisplay", false)
    SetNuiFocus(false, false)
    dislay = false
end

local sleepaq = 2000
CreateThread(function()
    while true do
        if ontestdrive then
            sleepaq = 1
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.3)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(testdrivetext)
            DrawText(0.5, 0.05)
        else
            sleepaq = 2000
        end
        Wait(sleepaq)
    end
end)

Data = {}
RegisterNUICallback("GetPlayerCars", function(data,cb)
    Data = {}
    local result = ClientCallback('savana-carsell:GetPlayerVehicles', data)
    if result then
        for k,v in pairs(result) do
            if Config.ManuelCarNames[v.model] then
                result[k].label = Config.ManuelCarNames[v.model]
            else
                result[k].label = GetDisplayNameFromVehicleModel(v.model)
            end
            table.insert(Data, v)
        end
        Wait(300)
        cb(Data)
    else
        cb({})
    end
end)

RegisterNUICallback("SetCarFavorite", function(data)
    TriggerServerEvent('savana-carsell:SetCarFavorite', data.car.plate)
    Wait(100)
    setCarsFunc()
end)

RegisterNUICallback("GetPlayerListedCars", function(data_, cb)
    data = {}
    datak = {}
    local para = 0
    local result = ClientCallback('savana-carsell:GetPlayerListedVehicles', data_)
    if result then
        for k,v in pairs(result) do
            table.insert(data, v)
        end
        cb(data)
        local result2 = ClientCallback('savana-carsell:GetPlayerMoney', data_)
        if result2 then
            table.insert(datak, result2)
            SendReactMessage("setPlayerMoney", datak)
        end
    end
end)

RegisterNUICallback("DeleteCar", function(data, cb)
    --[[local data = data
    local cb = cb
    TriggerServerEvent('savana-carsell:deleteCarlist', data)
    Citizen.Wait(2500)
    local datak = {}
    local result = ClientCallback('savana-carsell:GetPlayerListedVehicles', data)
    if result then
        for k,v in pairs(result) do
            table.insert(datak, v)
        end
        setCarsFunc()
        cb(datak)
    end]]
end)

RegisterNUICallback("WithdrawMoney", function(data, cb)
    local datak = {}
    local result = ClientCallback('savana-carsell:GetPlayerMoney')
    if result then
        table.insert(datak, result)
        TriggerServerEvent('savana-carsell:withdrawMoney', datak)
        Wait(50)
        SendReactMessage("setPlayerMoney", 0)
    end
end)

function setCarsFunc()
    cars = {}
    local result = ClientCallback('savana-carsell:GetVehicles')
    if result then
        cars = result
    end
    Wait(300)
    SendReactMessage("SetCars", cars)
end

RegisterNUICallback("ViewVehicle", function(data)
    local result = ClientCallback('savana-carsell:GetVehicleProperties', data.plate)
    if result then
        PreviewVehicle(data.car.model, result)
    else
        PreviewVehicle(data.car.model, false)
    end
end)

function PreviewVehicle(name, properties)
    local eskicoords = GetEntityCoords(PlayerPedId())
    --ESX.SetEntityCoords(PlayerPedId(),  Config.Preview.coords)
    SetNuiFocus(false, false)
    TriggerServerEvent('test-gir')
    SendReactMessage("setShowkeybinds", true)
    Wait(300)
    ESX.Game.SpawnLocalVehicle(name, Config.Preview.coords, Config.Preview.CamCoords.w, function(vehicle)
        FreezeEntityPosition(vehicle, true)
        onpreview = true
        --SetEntityAlpha(PlayerPedId(), 0)
        FreezeEntityPosition(PlayerPedId(), true)
        if properties then
            Core.Game.SetVehicleProperties(vehicle, properties)
            DoScreenFadeOut(500)
            Wait(1000)
            if not DoesCamExist(camera) then
                camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            end
            SetCamActive(camera, true)
            SetCamRot(camera,vector3(-10.0,0.0, -30.999), true)
            SetCamFov(camera,70.0)
            SetCamCoord(camera, Config.Preview.CamCoords.x, Config.Preview.CamCoords.y, Config.Preview.CamCoords.z)
            PointCamAtCoord(camera, Config.Preview.coords.x, Config.Preview.coords.y, Config.Preview.coords.z)
            RenderScriptCams(true, false, 2500.0, true, true)
            DoScreenFadeIn(1000)
            local heading = Config.Preview.coords.w
            while true do
                DisableControlAction(0, 32)
                DisableControlAction(0, 31)
                if IsControlPressed(0, 34) then
                    heading = heading + 0.01
                    heading = heading - 1
                    if heading < 1 then
                        heading = 358
                    elseif heading > 359 then
                        heading = 1
                    end
                    SetEntityHeading(vehicle, heading)
                end
                if IsControlPressed(0, 35) then
                    heading = heading + 0.01
                    heading = heading + 1
                    if heading < 2 then
                        heading = 358
                    elseif heading > 359 then
                        heading = 1
                    end
                    SetEntityHeading(vehicle, heading)
                end
                if IsControlJustPressed(0, 177) then
                    FreezeEntityPosition(PlayerPedId(), false)
                    SetEntityAlpha(PlayerPedId(), 1000)
                    onpreview = false
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteVehicle(vehicle)
                    -- SetEntityCoords(PlayerPedId(), eskicoords)
                    notify(Config.lang.carinspectover, true)
                    Wait(1000)
                    TriggerServerEvent('test-cik')
                    CloseCam()
                    break
                end
                Wait(0)
            end
        end
    end)
end

function CloseCam()
    DoScreenFadeOut(500)
    Wait(500)
    SendReactMessage("setShowkeybinds", false)
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    SetNuiFocus(true, true)
    DoScreenFadeIn(500)
    camera = nil
end

RegisterNetEvent('savana-carsell:client:notify', function(text)
    SendReactMessage("notif", text)
end)

function createPeds()
    if pedSpawned then return end

    for k, v in pairs(Config.TargetLocations) do
        local current = type(v["ped"]) == "number" and v["ped"] or joaat(v["ped"])

        RequestModel(current)
        while not HasModelLoaded(current) do
            Wait(0)
        end

        ShopPed[k] = CreatePed(0, current, v["coords"].x, v["coords"].y, v["coords"].z-1, v["coords"].w, false, false)
        TaskStartScenarioInPlace(ShopPed[k], v["scenario"], 0, true)
        FreezeEntityPosition(ShopPed[k], true)
        SetEntityInvincible(ShopPed[k], true)
        SetBlockingOfNonTemporaryEvents(ShopPed[k], true)

        exports['diamond_target']:AddTargetEntity(ShopPed[k], {
            options = {
                {
                    label = v["targetLabel"],
                    icon = v["targetIcon"],
                    action = function()
                        openGallery()
                    end,
                }
            },
            distance = 2.0
        })
    end

    pedSpawned = true
end

function deletePeds()
    if not pedSpawned then return end

    for _, v in pairs(ShopPed) do
        DeletePed(v)
    end
    pedSpawned = false
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function createBlips()
    if pedSpawned then return end
    for store in pairs(Config.TargetLocations) do
        if Config.TargetLocations[store]["showblip"] then
            local StoreBlip = AddBlipForCoord(Config.TargetLocations[store]["coords"]["x"], Config.TargetLocations[store]["coords"]["y"], Config.TargetLocations[store]["coords"]["z"])
            SetBlipSprite(StoreBlip, Config.TargetLocations[store]["blipsprite"])
            SetBlipScale(StoreBlip, 0.6)
            SetBlipDisplay(StoreBlip, 4)
            SetBlipColour(StoreBlip, Config.TargetLocations[store]["blipcolor"])
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.TargetLocations[store]["label"])
            EndTextCommandSetBlipName(StoreBlip)
        end
    end
end
