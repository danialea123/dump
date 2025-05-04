---@diagnostic disable: undefined-field, cast-local-type, lowercase-global, undefined-global, missing-parameter
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.GetPlayerData().job do
        Citizen.Wait(500)
    end

    playTime = GetGameTimer() + (NCHub.NeededPlayTime * 60000)
	PlayerData = ESX.GetPlayerData()
    Wait(1000)
    SendNUIMessage({
        type = 'translate', 
        translate = NCHub.Language,
    })		
    while true do
        Citizen.Wait(5000)
        local checkTime = tonumber(getNeededPlayTime())
        if checkTime <= 0 then
            playTime = GetGameTimer() + (NCHub.NeededPlayTime * 60000)
            TriggerServerEvent('esx_timeplay:addCoin', NCHub.RewardCoin)
        end
    end
end)

RegisterCommand(NCHub.OpenCommand, function()
	openMenu()
end)

local openMenuSpamProtect = 0
function openMenu()
    if openMenuSpamProtect < GetGameTimer() then 
        openMenuSpamProtect = GetGameTimer() + 1500
        ESX.TriggerServerCallback("esx_timeplay:getPlayerDetails", function(result)
            local steamID = GetPlayerPP(GetPlayerServerId(PlayerId()))
            local checkTime = tonumber(getNeededPlayTime()*60)
            local remainingTime = disp_time(checkTime)
            local firstname = string.gsub(ESX.GetPlayerData().name, "_", " ")
            local lastname = ""
            SetNuiFocus(true,true)
            SendNUIMessage({
                type = 'openui', 
                coin = result.Coin,
                categories = NCHub.Categories,
                items = NCHub.Items,
                steamid = steamID,
                firstname = firstname,
                lastname = lastname,
                remaining = remainingTime,
                coinReward = NCHub.RewardCoin,
                coinList = NCHub.CoinList,
                topPlayers = result.topPlayers,
            })	
        end)
    end
end

function GetPlayerPP(id)
    local callback = promise:new()
    ESX.TriggerServerCallback("esx:GetProfilePic", function(pp) 
        callback:resolve(pp)
    end, id)
    return Citizen.Await(callback)
end

function disp_time(time)
    local days = math.floor(time/86400)
    local remaining = time % 86400
    local hours = math.floor(remaining/3600)
    remaining = remaining % 3600
    local minutes = math.floor(remaining/60)
    remaining = remaining % 60
    local seconds = remaining
    if (hours < 10) then
        hours = "0" .. tostring(hours)
    end
    if (minutes < 10) then
        minutes = "0" .. tostring(minutes)
    end
    if (seconds < 10) then
        seconds = "0" .. tostring(seconds)
    end
    if hours ~= "00" then 
        answer = hours..'h '..minutes..'m'
    else
        answer = minutes..'m'

    end
    return answer
end

getNeededPlayTime = function()
    return math.round((playTime - GetGameTimer()) / 60000, 2)
end

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local buyItemSpamProtect = 0
RegisterNUICallback('buyItem', function(data, cb)
    if buyItemSpamProtect < GetGameTimer() then 
        buyItemSpamProtect = GetGameTimer() + 1500
        ESX.TriggerServerCallback("esx_timeplay:buyItem", function(result)
            cb(result)
        end, data)
    end
end)

RegisterNUICallback('closeMenu', function(data, cb)
	SetNuiFocus(false, false)
end)