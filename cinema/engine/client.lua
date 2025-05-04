---@diagnostic disable: param-type-mismatch
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

EngineSounds = {
    ["Maserati"] = 'bgw16',
    ["Bmw"] = 'bmws55',
    ["Dodge"] = 'c6v8sound',
    ["Lamborghini v12"] = 'diablov12',
    ["Wolksvagen"] = 'ea825',
    ["Ferrari v8"] = 'f40v8',
    ["Ford v10"] = 'gtaspanov10',
    ["Laferrari"] = 'lfasound',
    ["Benz"] = 'mercm177',
    ["Nissan gtr"] = 'nisgtr35',
    ["Porsche"] = 'porschema2',
    ["Ford v8"] = 'predatorv8',
    ["Benz shasi"] = 'rotary7',
    ["Supra"] = 'toysupmk4',
    ["Dodge viper"] = 'viperv10',
    ["Benz v6"] = 'w211',
    ['Back To Normal'] = 'normal'
}

local DisplayLabels = {}
local Spam = false

for k, v in pairs(EngineSounds) do
    DisplayLabels[#DisplayLabels + 1] = k
end

local Index = 1
lib.registerMenu({
    id = 'engine_sound_menu',
    title = 'Engine Sound Menu',
    position = "center",
    onSideScroll = function(selected, scrollIndex, args)
        Index = scrollIndex
    end,
    options = {
        { label = 'Change Engine Sound', icon = 'arrows-up-down-left-right', values = DisplayLabels },
    }
}, function(selected, scrollIndex, args)
    if not cache.vehicle or cache.seat ~= -1 then
        return
    end
    if Spam then return ESX.Alert("Change Kardan Sedaye Motor Har 4 Saniye Ghabel Anjam Ast", "info") end
    local set = EngineSounds[DisplayLabels[scrollIndex]]

    if EngineSounds[DisplayLabels[scrollIndex]] == "normal" then
        set = tostring(GetDisplayNameFromVehicleModel(GetEntityModel(cache.vehicle)))
    end

    TriggerServerEvent('esx_sound:ChangeEngineSound', {
        net = VehToNet(cache.vehicle),
        sound = set
    })

    SetVehicleRadioEnabled(cache.vehicle, false)
    SetVehRadioStation(cache.vehicle, 'OFF')
    Spam = true
    Citizen.SetTimeout(4000, function()
        Spam = false
    end)
end)

RegisterNetEvent("esx_sound:OpenMenu", function()
    if not cache.vehicle or cache.seat ~= -1 then
        return
    end
    lib.setMenuOptions('engine_sound_menu', { label = 'Change Engine Sound', icon = 'arrows-up-down-left-right', values = DisplayLabels, defaultIndex = Index }, 1)
    lib.showMenu('engine_sound_menu')
end)

AddStateBagChangeHandler("vehdata:sound", nil, function(bagName, key, value)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end
    ForceUseAudioGameObject(entity, value)
    Citizen.Wait(1000)
    SetVehicleRadioEnabled(cache.vehicle, false)
    SetVehRadioStation(cache.vehicle, 'OFF')
end)