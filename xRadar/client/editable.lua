---@diagnostic disable: missing-parameter, undefined-global
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local Jobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
}

RegisterKey("F5", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local class = GetVehicleClass(vehicle)
    if vehicle and class == 18 and ESX then
        if Jobs[ESX.GetPlayerData().job.name] then
            ToggleRadar()
        end
    end
end)

RegisterKey("F4", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local class = GetVehicleClass(vehicle)
    if vehicle and class == 18 and ESX then
        if Jobs[ESX.GetPlayerData().job.name] then
            OpenTablet()
        end
    end
end)

function ToggleRadar()
    --if isPolVeh then
        isRadarOpen = not isRadarOpen
        nuiMessage("TOGGLE_RADAR", isRadarOpen)
        AddKeys()
        ForceUpdateNui()
        UpdateRadarTime()
        RadarLoop()
    --end
end

function AddKeys()
    local locales = Locales.Default
    if selectedLanguage == 'en' then
        locales = Locales.English
    end
    if selectedLanguage == 'tr' then
        locales = Locales.Turkish
    end
    if selectedLanguage == 'de' then
        locales = Locales.Deutsch
    end
    if selectedLanguage == 'es' then
        locales = Locales.Spanisch
    end
    if selectedLanguage == 'pr' then
        locales = Locales.Portugiesisch 
    end
    if selectedLanguage == 'in' then
        locales = Locales.Hindi
    end

    ClearKeys()
    AddKey(Config.Radar.fastActionsKey.primary.label, Config.Radar.fastActionsKey.secondary.label, locales["FAST_ACCESS"])
    AddKey(Config.Radar.fastActionsKey.primary.label, Config.Radar.fastActionsKey.cursorKey.label, locales["OPEN_CURSOR"])
    AddKey(Config.Tablet.openKey.primary.label, Config.Tablet.openKey.secondary.label, locales["OPEN_TABLET"])
end

RegisterNUICallback("selectLanguage", function(data, cb)
    selectedLanguage = data.language
    AddKeys()
    nuiMessage("GET_LANGUAGE_VALUE", json.encode({
        DefaultLocales = Locales.Default,
        EnglishLocales = Locales.English,
        TurkishLocales = Locales.Turkish,
        DeutschLocales = Locales.Deutsch,
        EspanolLocales = Locales.Spanisch,
        PortugalLocales = Locales.Portugiesisch,
        HindiLocales = Locales.Hindi

    }))
end)


RegisterNUICallback("addBoloPlate", function(data, cb)
    if #data.plate > 0 then
        if  SearchBoloPlate(data.plate) then
            return
        end
        table.insert(boloPlates, data.plate)
    end
end)

RegisterNUICallback("clearBoloPlate", function(data, cb)
    for _,v in pairs(boloPlates) do
        if v == data.plate then
            table.remove(boloPlates, _)
        end
    end
end)

function SearchBoloPlate(plate)
    for _,v in pairs(boloPlates) do
        if v:lower() == plate:lower() then
            return true
        end
    end
    return false
end

function OpenTablet()
    if isRadarOpen then
        TriggerServerEvent('codem:radar:getProfile')
        SetNuiFocus(true, true)
        nuiMessage("TOGGLE_TABLET", true)
        nuiMessage("GET_RADAR_DATA", punishData)
        nuiMessage("SET_REAR_SCANNED_VEHICLES", rearScannedVehicles)
        nuiMessage("SET_FRONT_SCANNED_VEHICLES", frontScannedVehicles)

        ForceUpdateNui()
      
    end
end

RegisterNUICallback("closeTablet", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)