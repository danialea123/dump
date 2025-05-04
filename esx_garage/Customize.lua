--[[
    -- ! ImpoundVehicle
    TriggerEvent('ImpoundVehicle')
]]

Customize = {}

Customize.Framework = "QBCore" -- QBCore - ESX - NewESX - OldQBCore



Customize.Carkeys = function(Plate)
    TriggerEvent('vehiclekeys:client:SetOwner', Plate)
end

Customize.GetVehFuel = function(Veh)
    return exports["LegacyFuel"]:GetFuel(Veh)-- exports["LegacyFuel"]:GetFuel(Veh)
end
Customize.SetVehFuel = function(Veh, Fuel)
    return exports["LegacyFuel"]:SetFuel(Veh) --exports['LegacyFuel']:SetFuel(Veh, data.Table.fuel)
end

Customize.PriceType = 'cash' -- cash - bank
Customize.GaragesPrice = 0
Customize.ImpoundGaragesPrice = 600
Customize.JobGaragesPrice = 1

Customize.Garages = {
    {
        Blips = {
            Position = vector3(213.56, -809.54, 31.01),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(213.56, -809.54, 31.01), Heading = 340.67 },
        Type = 'car', --car, air, sea
        UIName = 'Test Pilbox Hill',
        Camera = {
            vehSpawn = vector4(236.95, -783.71, 30.63, 179.64),
            location = { posX = 233.37, posY = -789.9, posZ = 30.6, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(212.39, -797.34, 30.88),
        VehSpawnPos = vector4(209.64, -791.39, 30.5, 248.63),
    },
    {
        Blips = {
            Position = vector3(463.75, -982.43, 43.69),
            Label = "Air",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(463.75, -982.43, 43.69), Heading = 89.74 },
        Type = 'air', --car, air, sea
        UIName = 'Test Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-75.3122, -818.490, 326.17, 201.5),
            location = { posX = -58.0, posY = -828.5, posZ = 335.17, rotX = -25.0, rotY = 0.0, rotZ = 73.2, fov = 40.0 },
        },
        VehPutPos = vector3(449.76, -981.27, 43.69),
        VehSpawnPos = vector4(449.85, -981.23, 43.69, 93.23),
    },
    {
        Blips = {
            Position = vector3(-869.43, -1491.55, 5.17),
            Label = "Sea",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-869.43, -1491.55, 5.17), Heading = 112.87 },
        Type = 'sea', --car, air, sea
        UIName = 'Test Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-855.5, -1484.77, -0.47, 111.13),
            location = { posX = -868.0, posY = -1495.0, posZ = 6.31, rotX = -25.0, rotY = 0.0, rotZ = -40.0, fov = 40.0 },
        },
        VehPutPos = vector3(-858.29, -1475.77, 0.5),
        VehSpawnPos = vector4(-799.54, -1502.98, -0.08, 114.38),
    }
}


Customize.JobGarages = {
    {
        Blips = {
            Position = vector3(221.83, -813.3, 30.57),
            Label = "Police Garage",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 3,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(221.83, -813.3, 30.57), Heading = 344.2 },
        Type = 'car', --car, air, sea
        UIName = 'Test Police',
        Camera = {
            vehSpawn = vector4(236.95, -783.71, 30.63, 179.64),
            location = { posX = 233.37, posY = -789.9, posZ = 30.6, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(227.87, -809.05, 30.52),
        VehSpawnPos = vector4(238.17, -807.41, 30.33, 252.64),
        PlayerJob = 'police',
        Vehicles = { 'police3' },
    },
}

Customize.ImpoundGarages = {
    {
        Blips = {
            Position = vector3(409.43, -1623.11, 29.29),
            Label = "Impound Garages",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 1,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(409.43, -1623.11, 29.29), Heading = 233.95 },
        Type = 'car', --car, air, sea
        UIName = 'Test Police',
        Camera = {
            vehSpawn = vector4(402.04, -1632.39, 28.9, 159.52), -- vector4(402.56, -1644.22, 31.76, 27.55)
            location = { posX = 402.56, posY = -1644.22, posZ = 31.76, rotX = -10.0, rotY = 0.0, rotZ = 22.0, fov = 50.0 },
        },
        VehSpawnPos = vector4(419.88, -1629.18, 28.9, 140.26),
    },
}

function GetFramework()
    local Get = nil
    if Customize.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Customize.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Customize.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Customize.Framework == "OldQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end