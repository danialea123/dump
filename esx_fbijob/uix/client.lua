local Organs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
    ["artesh"] = true,
    ["cia"] = true
}
local data = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
    if PlayerData.job.ext then
        if PlayerData.job.ext == "drs" and PlayerData.job.name == "ambulance" then
            PlayerData.job.label = PlayerData.job.label.." | DarooSaz"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "swat" then
            PlayerData.job.label = PlayerData.job.label.." | S.W.A.T"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "riot" then
            PlayerData.job.label = PlayerData.job.label.." | Riot"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "tre" then
            PlayerData.job.label = PlayerData.job.label.." | Traffic Enforcment"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "police" then
            PlayerData.job.label = PlayerData.job.label
        end
    end
end)

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    PlayerData.job = job
    if PlayerData.job.ext then
        if PlayerData.job.ext == "drs" and PlayerData.job.name == "ambulance" then
            PlayerData.job.label = PlayerData.job.label.." | DarooSaz"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "swat" then
            PlayerData.job.label = PlayerData.job.label.." | S.W.A.T"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "riot" then
            PlayerData.job.label = PlayerData.job.label.." | Riot"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "tre" then
            PlayerData.job.label = PlayerData.job.label.." | Traffic Enforcment"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "police" then
            PlayerData.job.label = PlayerData.job.label
        end
    end
    ShowData()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
    PlayerData.gang = gang
    ShowData()
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    ESX.PlayerData.money = money
    PlayerData.money = money
    ShowData()
end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(money)
    ESX.PlayerData.bank = money
    PlayerData.bank = money
    ShowData()
end)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    PlayerData.name = name
    ShowData()
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    ESX.PlayerData.black_money = money
    PlayerData.black_money = money
    ShowData()
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
    ShowData()
end)

AddEventHandler("onKeyUP",function(b)
    if b == "j" then
        SendNUIMessage({action = "playerinfo"})
    end
end)

function ShowData()
    SendNUIMessage(
        {
            action = "playerdata",
            playername = PlayerData.name:gsub("_", " "),
            money = MakeDigit(PlayerData.money),
            playerid = GetPlayerServerId(PlayerId()),
            job = PlayerData.job.label .. " | " .. PlayerData.job.grade_label,
            gang = PlayerData.gang.name .. " | " .. PlayerData.gang.grade_label,
            coin = MakeDigit2(PlayerData.Coin),
        }
    )
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if ESX and PlayerData and PlayerData.name and PlayerData.money and PlayerData.job and PlayerData.gang and PlayerData.Coin then
            SendNUIMessage(
                {
                    action = "playerdata",
                    playername = PlayerData.name:gsub("_", " "),
                    money = MakeDigit(PlayerData.money),
                    playerid = GetPlayerServerId(PlayerId()),
                    job = PlayerData.job.label .. " | " .. PlayerData.job.grade_label,
                    gang = PlayerData.gang.name .. " | " .. PlayerData.gang.grade_label,
                    coin = MakeDigit2(PlayerData.Coin),
                }
            )
        end
    end
end)

function time()
    hour = GetClockHours()
    minute = GetClockMinutes()
    if hour <= 9 then
        hour = "0" .. hour
    end
    if minute <= 9 then
        minute = "0" .. minute
    end
    return hour .. ":" .. minute
end

function MakeDigit(j)
    local k, l, m = string.match(j, "^([^%d]*%d)(%d*)(.-)$")
    return "$" .. k .. l:reverse():gsub("(%d%d%d)", "%1" .. ","):reverse() .. m
end

function MakeDigit2(j)
    local k, l, m = string.match(j, "^([^%d]*%d)(%d*)(.-)$")
    return k .. l:reverse():gsub("(%d%d%d)", "%1" .. ","):reverse() .. m
end

CreateThread(function()
    while true do
        Citizen.Wait(10000)
        SendNUIMessage({action = "time", clock = time(), name = GetPlayerName(source)})
    end
end)