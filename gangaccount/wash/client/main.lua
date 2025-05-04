---@diagnostic disable: undefined-field
ESX              = nil
local PlayerData = {}
local Day = false
local Night = false
local lastTrigger = nil
local Peds = {}
local isMenuOpen = false
local Near = false
local Temp = {}
local lastLocations = {}
local Locations = {
    vector3(2336.334, 3046.22, 48.13477),
    vector3(1803.468, 3913.873, 37.04761),
    vector3(1710.198, 4728.422, 42.13623),
    vector3(119.4857, 6626.439, 31.94214),
    vector3(-3191.011, 1297.675, 19.052),
    vector3(201.6264, 2442.04, 60.45203),
    vector3(1106.2,2652.59,38.14),
    vector3(2931.297, 4486.088, 48.05054),
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end

    PlayerData = ESX.GetPlayerData()

    SetDisplay(false)

    Citizen.Wait(10000)
    if PlayerData.Level >= 0 then
        firstFunction()
    end
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    ESX.PlayerData.black_money = money
    PlayerData.black_money = money
end)

RegisterNetEvent('esx:playerLevelChanged')
AddEventHandler('esx:playerLevelChanged', function(lvl)
    if GetInvokingResource() then return end
    --[[lastLocations = {}
    Near = false
    lastTrigger = nil
    if isMenuOpen then
        SetDisplay(false)
    end
    if #Peds > 0 then
        for k, v in pairs(Peds) do
            DeleteEntity(v)
            table.remove(Peds, k)
        end
    end]]
    ESX.PlayerData.Level = lvl
    PlayerData.Level = lvl
    --[[if PlayerData.Level >= 0 then
        firstFunction()
    end]]
end)

-- koobs system ke migan ine haji HR_KoobsSystem

function firstFunction()
    Citizen.CreateThread(function()
        while true do
            Day = true --GetClockHours() >= 7 and GetClockHours() <= 18
            Night = false --GetClockHours() >= 0 and GetClockHours() <= 5
            PauseWashing = false --GetClockHours() >= 19 and GetClockHours() <= 23
            Citizen.Wait(2000)
            if PauseWashing then
                lastLocations = {}
                Near = false
                lastTrigger = nil
                if isMenuOpen then
                    SetDisplay(false)
                end
                if #Peds > 0 then
                    for k, v in pairs(Peds) do
                        DeleteEntity(v)
                        table.remove(Peds, k)
                    end
                end
            end
            if Day and not Night and not PauseWashing then
                if not lastTrigger or lastTrigger == "Night" then
                    lastTrigger = "Day"
                    RunScript(GetClockHours() >= 7 and GetClockHours() <= 18)
                end
            end
            if Night and not Day and not PauseWashing then
                if not lastTrigger or lastTrigger == "Day" then
                    lastTrigger = "Night"
                    RunScript(GetClockHours() >= 0 and GetClockHours() <= 5)
                end
            end
            Citizen.Wait(30000)
        end
    end)
end

function RunScript(condition)
    local Counter
    Temp = Locations
    if Day then
        Counter = 8
    else
        Counter = 8
    end
    for i = 1, Counter do
        local random = math.random(#Temp)
        table.insert(lastLocations, Temp[random])
        table.insert(Peds, Create(Temp[random]))
        table.remove(Temp, random)
    end
    DistanceThread(condition)
end

function DistanceThread(condition)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1500)
            local Sleep = true
            for k, v in pairs(lastLocations) do 
                if #(GetEntityCoords(PlayerPedId()) - v) <= 1.0 then
                    Sleep = false
                    Near = true
                end
            end
            if Sleep then Near = false end
        end
    end)
end

AddEventHandler("onKeyDown", function(key)
    if key == "e" and Near then 
        SetDisplay(true)
    end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    isMenuOpen = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        currentblackMoney = ESX.Math.GroupDigits(PlayerData.black_money),
        currentWashCost = Day == true and ESX.Math.GroupDigits(math.floor(PlayerData.black_money*0.60)) or ESX.Math.GroupDigits(math.floor(PlayerData.black_money*0.70)),
    })
end

_RequestModel = function(hash, cb)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(500)
        RequestModel(hash)
    end
    cb()
end

function Create(coord)
    local entity
    _RequestModel(349680864, function()
        entity = CreatePed(4, 349680864, coord.x, coord.y, coord.z -1, 300.0, false, true, true)
        SetEntityAsMissionEntity(entity)
        SetBlockingOfNonTemporaryEvents(entity, true)
        FreezeEntityPosition(entity, true)
        SetEntityInvincible(entity, true)
        TaskStartScenarioInPlace(entity, "WORLD_HUMAN_SMOKING", 0, true);
        SetModelAsNoLongerNeeded(349680864)
    end)
    while entity == nil do
        Citizen.Wait(10)
    end
    return entity
end

RegisterNUICallback("success", function(data) 
    Citizen.Wait(math.random(1000, 3500))
    SetDisplay(false) 
    ESX.TriggerServerCallback("esx_washmoney:getMoney", function(money)
        ESX.Alert("Shoma "..ESX.Math.GroupDigits(math.floor(money)).." Pool Tamiz Daryaft Kardid", "check")
    end, lastTrigger)
end)

RegisterNUICallback("checklimit", function(data, cb)
    if PlayerData.black_money >= 100000 then
        --if PlayerData.black_money <= 500000 then
            --[[ESX.TriggerServerCallback("esx_washmoney:Limit", function(washed) 
                if washed + PlayerData.black_money <= 500000 then
                    if lastTrigger then]]
                        cb(true)
                    --[[else
                        SetDisplay(false)
                    end
                elseif math.floor(500000 - washed) <= 0 then
                    ESX.Alert("Shoma Be 500k Dar 1 Saat Limit Shodid, Lotfan 1 Saat Baad Emtehan Konid", "info")
                else
                    ESX.Alert("Shoma Ta 1 Saat Digar Faghat "..ESX.Math.GroupDigits(math.floor(500000 - washed)).." Pool Kasif Mitavanid Beshoorid", "info")
                end
            end)]]
        --[[else
            ESX.Alert("Bishtarin Pool Kasif Baraye Wash Kardan 500K Dar 1 Saat Ast", "error")
        end]]
    else
        ESX.Alert("Hadeaghal Pool Kasif Baraye Wash Kardan 100K Ast", "error")
    end
end)