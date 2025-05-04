---@diagnostic disable: param-type-mismatch, lowercase-global, missing-parameter, undefined-global, undefined-field
local Key
local isUsingPed = false
local last = nil
local PedClothes = nil 
local pedGender
local Org = {
    ["mp_m_freemode_01"] = true,
    ["mp_f_freemode_01"] = true,
}

RegisterNetEvent("esx:ActivatePedSelection")
AddEventHandler("esx:ActivatePedSelection", function(data)
    Key = UnregisterKey(Key)
    Key = RegisterKey("HOME", false, function()
        if isNearAnyClothShop() or PlayerData.identifier == "steam:11000011c6992f0" then
            if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "forces" then
                ESX.Alert("Shoma Baraye Taghir Ped Bayad Off-Duty Bashid", "error")
            else  
                OpenMenu(data)
            end
        else
            ESX.Alert("Shoma Nazdik Hich Lebas Forushi Nistid", "error")
        end
    end)
end)

--[[RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function()
    if isUsingPed then
        InstallModel("mp_m_freemode_01", function(val)
            if val then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    if skin == nil then
                        TriggerEvent('skinchanger:loadSkin', {sex = 0})
                    else
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end
                end)
            end
        end)
    end
end)]]

AddEventHandler("PlayerLoadedToGround", function()
    if GetHashKey('mp_m_freemode_01') == GetEntityModel(PlayerPedId()) then
        pedGender = 'mp_m_freemode_01'
    end
    if GetHashKey('mp_f_freemode_01') == GetEntityModel(PlayerPedId()) then
        pedGender = 'mp_f_freemode_01'
    end
    Citizen.Wait(5000)
    ESX.TriggerServerCallback("esx_ped:GetCacheData", function(response)
        if response then
            InstallModel(response, function(val)
                if val then
                    if PedClothes == nil then
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            PedClothes = skin
                            if skin == nil then
                                TriggerEvent('skinchanger:loadSkin', {sex = 0})
                            else
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end
                        end)
                    else
                        TriggerEvent('skinchanger:loadSkin', PedClothes)
                    end
                end
            end)
        end
    end)
end)

function OpenMenu(data)
    ESX.UI.Menu.CloseAll()
    local Elements = {
        {label = "Original Ped", value = pedGender}
    }
    for k, v in pairs(data) do
        table.insert(Elements, {label = k.." | Expires: "..math.floor(((v - exports.sr_main:GetTimeStampp())/86400)).." Days ❗(0 Days Yani Kamtar Az 1 Rooz)❗", value = k})
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ped_ask_question', {
		title = "Entekhab Ped",
		align = 'center',
		elements = Elements
	}, function(data, menu)
        if not isNearAnyClothShop() and PlayerData.identifier ~= "steam:11000011c6992f0" then return menu.close() end
        if last == data.current.value then return menu.close() end
        last = data.current.value
        InstallModel(data.current.value, function(val)
            menu.close()
            if val then
                if PedClothes == nil then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        PedClothes = skin
                        if skin == nil then
                            TriggerEvent('skinchanger:loadSkin', {sex = 0})
                        else
                            TriggerEvent('skinchanger:loadSkin', skin)
                        end
                    end)
                else
                    TriggerEvent('skinchanger:loadSkin', PedClothes)
                end
            end
        end)
	end, function(data,menu)
		menu.close()
	end)
end

function isNearAnyClothShop()
    for k, v in pairs(Config.Shops) do
        for _, Pos in pairs(v.Pos) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Pos, true) < 10.0 then
                return true
            end
        end
    end
    return false
end

function InstallModel(data, cb)
    if GetHashKey('mp_m_freemode_01') == GetEntityModel(PlayerPedId()) then
        pedGender = 'mp_m_freemode_01'
    end
    if GetHashKey('mp_f_freemode_01') == GetEntityModel(PlayerPedId()) then
        pedGender = 'mp_f_freemode_01'
    end
    exports.esx_manager:setException(true)
    local model = GetHashKey(data)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    for i = 0, 13 do
        ClearPedProp(PlayerPedId(), i)
    end
    for i = 0, 12 do
        SetPedComponentVariation(PlayerPedId(), i, 0, 0, 2)
    end
    TriggerEvent("skinchanger:resetCompVals", function()
        SetPlayerModel(PlayerId(), model)
    end)
    for i = 0, 13 do
        ClearPedProp(PlayerPedId(), i)
    end
    for i = 0, 12 do
        SetPedComponentVariation(PlayerPedId(), i, 0, 0, 2)
    end
    TriggerEvent("skinchanger:resetCompVals", function()
    
    end)
    Citizen.Wait(2000)
    TriggerEvent('esx:restoreLoadout')
    exports.esx_manager:ModelUpdated()
    exports.esx_manager:setException(false)
    TriggerServerEvent("esx_ped:savePedStats", Org[data] and false or data)
    cb(Org[data])
end