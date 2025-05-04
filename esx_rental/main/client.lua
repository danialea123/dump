---@diagnostic disable: lowercase-global, undefined-field, need-check-nil, undefined-global
local Location, Car, Stock, Framework, Price, Payment = nil, nil, true, nil, 0, ''
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    Callback = ESX.TriggerServerCallback

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
    local iu = {
		`a_m_y_business_02`,
	}

	exports.diamond_target:AddTargetModel(iu, {
        options = {
            {
                icon = "fas fa-dumpster",
                label = "🚗 اجاره ماشین",
                action = function(_)
                    ESX.TriggerServerCallback("esx_rental:CheckForRents", function(dat)
                        if dat then 
                            ESX.Alert("Shoma Yek Mashin Az Ghabl Ejare Kardid, Ta Payan Etmam Rent Sabr Konid", "info")
                        else
                            SendNUIMessage({ type = "CARS", cars = Config.Vehicles })
                            SetDisplay(true)
                        end
                    end)
                end,
            },
        },
        job = {"all"},
        distance = 2.0
    })
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(650)
        if IsPauseMenuActive() and not pauseActive and not Stock then
            pauseActive = true
            SendNUIMessage({
                type = 'PAUSE',
                args = false
            })
        end
        if not IsPauseMenuActive() and pauseActive and not Stock then
            pauseActive = false
            SendNUIMessage({
                type = 'PAUSE',
                args = "start"
            })
        end
    end
end)

local Peds = {
    vector4(-1013.22,-2699.47,13.99,148.62),
    vector4(255.16,-766.91,30.8,159.25),
    vector4(1852.28,2582.69,45.67,269.26),
    vector4(-82.79,94.12,72.62,64.52),
    vector4(1720.65,3593.43,35.23,209.53),
    vector4(2133.65,4823.44,41.28,188.65),
    vector4(-234.86,6198.06,31.94,137.77),
}

local Pos = {
    [1] = {
        {x = -1010.71, y = -2696.58, z = 13.00, h = 81.69, model = 'faggio', price = false, job = 'none'},
        {x = -1010.06, y = -2694.96, z = 13.00, h = 84.48, model = 'faggio', price = false, job = 'none'},
        {x = -1009.44, y = -2693.55, z = 13.00, h = 76.99, model = 'faggio2', price = false, job = 'none'},
        {x = -1008.89, y = -2692.15, z = 13.00, h = 80.65, model = 'faggio2', price = false, job = 'none'},
        {x = -1007.13, y = -2688.77, z = 13.00, h = 79.70, model = 'faggio3', price = false, job = 'none'},
        {x = -1005.89, y = -2687.23, z = 13.00, h = 81.82, model = 'faggio3', price = false, job = 'none'},
        {x = -1004.96, y = -2685.47, z = 13.00, h = 84.86, model = 'tribike', price = false, job = 'none'},
        {x = -1004.33, y = -2684.0, z = 13.00, h = 76.25, model = 'tribike2', price = false, job = 'none'},
        {x = -1003.42, y = -2682.40, z = 13.00, h = 73.50, model = 'tribike3', price = false, job = 'none'},
        {x = -1020.50, y = -2690.93, z = 13.00, h = 223.85, model = 'faggio', price = false, job = 'none'},
        {x = -1019.57, y = -2689.42, z = 13.00, h = 225.41, model = 'faggio', price = false, job = 'none'},
        {x = -1018.65, y = -2687.41, z = 13.00, h = 225.44, model = 'faggio2', price = false, job = 'none'},
        {x = -1017.69, y = -2685.72, z = 13.00, h = 222.39, model = 'faggio2', price = false, job = 'none'},
        {x = -1016.08, y = -2682.52, z = 13.00, h = 227.78, model = 'faggio3', price = false, job = 'none'},
        {x = -1015.16, y = -2681.00, z = 13.00, h = 222.00, model = 'faggio3', price = false, job = 'none'},
        {x = -1014.21, y = -2679.60, z = 13.00, h = 226.37, model = 'tribike', price = false, job = 'none'},
        {x = -1013.51, y = -2678.31, z = 13.00, h = 231.22, model = 'tribike2', price = false, job = 'none'},
        {x = -1012.58, y = -2677.08, z = 13.00, h = 226.39, model = 'tribike3', price = false, job = 'none'},
    },
    [2] = {
        {x = 261.23, y = -762.59, z = 30.75, h = 345.42, model = 'virgo3', price = 1000, job = 'none'},
        {x = 257.9, y = -761.17, z = 30.75, h = 341.16, model = 'dilettante', price = 1400, job = 'none'},
        {x = 254.5, y = -760.1, z = 30.75, h = 342.79, model = 'dominator', price = 2000, job = 'none'},
        {x = 251.54, y = -758.79, z = 29.75, h = 341.8, model = 'neon', price = 3000, job = 'none'},
        {x = 248.06, y = -757.66, z = 30.75, h = 341.79, model = 'dominator3', price = 3000, job = 'none'},

        {x = 268.33, y = -750.9, z = 30.75, h = 158.39, model = 'faggio3', price = 500, job = 'none'},
        {x = 265.02, y = -750.0, z = 30.75, h = 157.55, model = 'bati', price = 1000, job = 'none'},
        {x = 261.76, y = -748.75, z = 30.75, h = 159.26, model = 'bf400', price = 1200, job = 'none'},
        {x = 258.5, y = -747.75, z = 30.75, h = 163.0, model = 'faggio', price = 500, job = 'none'},
        {x = 255.29, y = -746.43, z = 30.75, h = 162.11, model = 'bmx', price = 200, job = 'none'},
        {x = 251.99, y = -745.11, z = 30.75, h = 161.16, model = 'scorcher', price = 400, job = 'none'},
        {x = 248.7, y = -743.71, z = 30.75, h = 158.08, model = 'tribike2', price = 400, job = 'none'},
        {x = 245.18, y = -742.83, z = 30.75, h = 158.24, model = 'tribike', price = 350, job = 'none'},
    },
    [3] = {
        {x = 1855.03, y = 2578.71, z = 45.67, h = 270.61, model = 'kanjo', price = 1000, job = 'none'},
        {x = 1855.04, y = 2575.18, z = 45.67, h = 270.61, model = 'virgo3', price = 1000, job = 'none'}, 
        {x = 1855.01, y = 2571.27, z = 45.67, h = 270.61, model = 'faggio3', price = 500, job = 'none'}, 
        {x = 1854.95, y = 2567.69, z = 45.67, h = 270.21, model = 'bf400', price = 1000, job = 'none'}, 
    },
    [4] = {
        {x = -88.69, y = 93.84, z = 72.36, h = 151.57, model = 'kanjo', price = 1000, job = 'none'},
        {x = -92.02, y = 94.89, z = 72.33, h = 151.87, model = 'virgo3', price = 1000, job = 'none'}, 
        {x = -95.02, y = 96.73, z = 72.38, h = 156.05, model = 'dilettante', price = 1400, job = 'none'},
        {x = -98.37, y = 98.35, z = 72.43 , h = 151.65, model = 'dominator', price = 2000, job = 'none'},
    },
    [5] = {
        {x = 1717.27, y = 3593.81, z = 35.29, h = 115.33, model = 'yosemite3', price = 1000, job = 'none'},
        {x = 1715.07 , y = 3597.58, z = 35.24, h = 118.92, model = 'buffalo2', price = 2000, job = 'none'},
        {x = 1713.59, y = 3600.29, z = 35.17, h = 118.64, model = 'blazer', price = 1100, job = 'none'},
        {x = 1711.53, y = 3603.47, z = 35.17 , h = 122.86, model = 'bf400', price = 1000, job = 'none'},
    },
    [6] = {
        {x = 2129.45, y = 4821.9, z = 41.32, h = 218.35, model = 'monster', price = 4000, job = 'none'},
        {x = 2122.47 , y = 4818.69, z = 41.32, h = 208.59, model = 'marshall', price = 3500, job = 'none'}, 
        {x = 2116.69, y = 4815.89, z = 41.29, h = 200.46, model = 'TrophyTruck2', price = 3000, job = 'none'},
    },
    [7] = {
        {x = -238.48, y = 6196.10, z = 30.48, h = 134.24, model = 'voodoo2', price = 1000, job = 'none'},
        {x = -240.77, y = 6199.06, z = 30.48, h = 134.24, model = 'glendale', price = 1000, job = 'none'},
        {x = -235.99, y = 6193.85, z = 30.48, h = 134.24, model = 'impaler', price = 1000, job = 'none'},
        {x = -243.37, y = 6201.38, z = 30.48, h = 134.24, model = 'tampa', price = 1000, job = 'none'},
        {x = -245.52, y = 6203.73, z = 30.48, h = 134.24, model = 'surge', price = 1000, job = 'none'},
        {x = -247.97, y = 6206.30, z = 30.48, h = 134.24, model = 'dominator3', price = 1000, job = 'none'},
    },
}

local spawn = {}

Citizen.CreateThread(function()
    for k, v in pairs(Pos) do
        spawn[k] = {}
    end
    for k, v in pairs(Pos) do
        for a, b in pairs(v) do
            table.insert(spawn[k], vector4(b.x, b.y, b.z, b.h))
        end
    end
end)

CreateThread(function()
	for k,v in pairs(Peds) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, 225)
		SetBlipScale  (blip, 0.6)
		SetBlipColour (blip, 84)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Rental")
		EndTextCommandSetBlipName(blip)
        local model = `a_m_y_business_02`
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        local entity = CreatePed(5, model, v.x, v.y, v.z - 1, v.w, false, false)
        FreezeEntityPosition(entity, true)
        SetBlockingOfNonTemporaryEvents(entity, true)
        SetPedArmour(entity, 1000000)
        SetEntityHealth(entity, 1000000)
        SetEntityInvincible(entity, true)
        loadAnimDict("amb@world_human_cop_idles@male@idle_b") 
        TaskPlayAnim(entity, "amb@world_human_cop_idles@male@idle_b", "idle_e", 8.0, 1.0, -1, 17, 0, 0, 0, 0)
	end
end)

RegisterNUICallback("exit", function()
    SetDisplay(false)
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1700, true, false)
    SetFocusEntity(PlayerPedId())
    DisplayRadarAndHud(true)
end)

local CanOpenUI = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local Pause = true
        local coord = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Peds) do
            local dist = #(coord - vector3(v.x,v.y,v.z))
            if dist <= 3.0 then
                CanOpenUI = true
                Pause = false
                GlobalID = k
            end
        end
        if Pause then 
            Citizen.Wait(700)
            if CanOpenUI then
                CanOpenUI = false
                SendNUIMessage({ type = "CLOSE"})
            end
        end
    end
end)

RegisterNUICallback("features", function(data, cb)
    local model = GetHashKey(data.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    cb({
        maxSpeed = GetVehicleModelMaxSpeed(model) * 0.5,
        acceleration = GetVehicleModelAcceleration(model) * 100,
        brake = GetVehicleModelMaxBraking(model) * 75,
        fuel = 80
    })
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)

    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DisplayRadarAndHud(state)
    DisplayRadar(state)
    DisplayHud(state)
end

RegisterNUICallback("delete", function()
    SendNUIMessage({ type = "STOP" })
    DeleteVehicle(Car)
    Stock = true
end)

RegisterNUICallback("start", function(data, cb)
    Price = data.price
    Payment = data.type
    if data.time == 0 then return end
    Callback("isPrice", function(result)
        cb(result)
        if result then 
            Rent(data.time, data.model, data.price)
        else
            ESX.Alert("Pool Kafi Nadarid", "info")
        end
	end, data.price, data.type)
end)

function Rent(time, vehicle, price)
    SpawnRentVehicle(vehicle, price, time)
end

function SpawnRentVehicle(vehicle, price, time)
    local found, coords = GetAvailableVehicleSpawnPoint()
    if found then
        ESX.Game.SpawnVehicle(vehicle, vector3(coords.x, coords.y, coords.z), coords.w, function(veh)
            ESX.CreateVehicleKey(veh)
            SetVehicleDirtLevel(veh, 0.0)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            Citizen.Wait(100)
            TriggerServerEvent("esx_rental:AddTimerVehicle", VehToNet(veh), price, time)
        end)
    end
end

function GetAvailableVehicleSpawnPoint()
    local spawnPoints = spawn[GlobalID]
    local found, foundSpawnPoint = false, nil
    for i=1, #spawnPoints, 1 do
        if ESX.Game.IsSpawnPointClear(vector3(spawnPoints[i].x,spawnPoints[i].y, spawnPoints[i].z), 3.5) then
            found, foundSpawnPoint = true, spawnPoints[i]
            break
        end
    end

    if found then
        return true, foundSpawnPoint
    else
        return false
    end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local time
local ptime

RegisterNetEvent("esx_rental:StartTimer", function(sec)
    ptime = sec
    time = sec
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                break
            end
        end
    end)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            Draw('Rental Timer : '..time, 255, 0, 0, 0.01, 0.42)
            if time == 0 then
                break
            end
        end
    end)
end)

RegisterNetEvent("esx_rental:UpdateTimer", function(sec)
    time = ptime - sec
end)

function Draw(text,r,g,b,x,y)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.50, 0.50)
	SetTextColour( r,g,b, 255 )
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end