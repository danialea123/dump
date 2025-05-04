Config = {}

Config.Framework = "ESX" -- QBCore or ESX or OLDQBCore -- NewESX

Config.MarkerName = "[E] RENT"

Config.SellVehicles = {
    vector3(229.041763, -802.536255, 30.543579)
}

Config.Locations = {
    { 
        coords = vector3(235.081314, -817.780212, 29.223389),
        hash = "a_m_o_soucent_01",
        heading = 340.157471,
        marker = "Rent",
        BuyCarSpawnPositions = {
            [1] = vector4(206.2538, -801.118, 31.001, 249.448822),
            [2] = vector4(207.1145, -798.583, 30.987, 249.448822),
            [3] = vector4(208.1531, -796.111, 30.965, 249.448822),
            [4] = vector4(208.9542, -793.656, 30.947, 249.448822),
            [5] = vector4(209.9097, -791.195, 30.925, 249.448822)
        },
        
    }, 
}

Config.GetVehFuel = function(Veh)
    return exports["LegacyFuel"]:GetFuel(Veh)
end

function GetFramework()
    local Get = nil
    if Config.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Config.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Config.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Config.Framework == "OldQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end

Config.Vehicles = {
    {
        label = 'Surge',
        description = 'Sedan',
        price = 200,
        model = 'surge',
        size = '100',
    },
    {
        label = 'Dominator 3',
        description = 'Sport Car',
        price = 250,
        model = 'dominator3',
        size = '100',
    },
    {
        label = 'Kanjo',
        description = 'Sports Sedan',
        price = 210,
        model = 'kanjo',
        size = '115',
    },
    {
        label = 'Yosemite 3',
        description = 'Sedan',
        price = 310,
        model = 'yosemite3',
        size = '100',
    },
    {
        label = 'Faggio3',
        description = 'Bike',
        price = 215,
        model = 'faggio3',
        size = '105',
    },
    {
        label = 'Faggio',
        description = 'Bike',
        price = 150,
        model = 'faggio',
        size = '100',
    },
    {
        label = 'Faggio 2',
        description = 'Bike',
        price = 160,
        model = 'faggio2',
        size = '100',
    },
    {
        label = 'Virgo3',
        description = 'Sport',
        price = 200,
        model = 'virgo3',
        size = '100',
    },
    {
        label = 'Glendale',
        description = 'Sport',
        price = 220,
        model = 'glendale',
        size = '115',
    },
    {
        label = 'Dilettante',
        description = 'Sport',
        price = 270,
        model = 'dilettante',
        size = '100',
    },
    {
        label = 'Dominator',
        description = 'Off-Road',
        price = 170,
        model = 'dominator',
        size = '105',
    },
    {
        label = 'BF400',
        description = 'Bike',
        price = 350,
        model = 'bf400',
        size = '100',
    },
}