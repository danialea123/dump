ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local toggle = false

AddEventHandler("onKeyUP", function(key)
    if key == "f10" then
        toggle = not toggle
        if toggle then
            OpenHud()
        end
    end
end)

function OpenHud()
    Citizen.CreateThread(function()
        while toggle do 
            ESX.TriggerServerCallback("esx:GetScoreBoardData", function(data) 
                SetNuiFocus(true, true)
                SendNUIMessage({ 
                    Dtoggle = toggle,
                    action = "updatePlayer",
                    player_count = data.Players
                })
                SendNUIMessage({ 
                    action = "updatePlayerInfo",
                    data = {
                        SteamName = GetPlayerName(PlayerId()),
                        job = firstToUpper(PlayerData.job.name),
                        level = PlayerData.Level,
                        Hex = PlayerData.identifier,
                    }
                })
                SendNUIMessage({ 
                    action = "updateJob",
                    data = {
                        job = data.jobs,
                        rob = data.robs,
                    }
                })
            end)
            Citizen.Wait(60000)
        end
    end)
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

RegisterNUICallback("close", function()
    toggle = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback("Copy", function(data)
    local copy = data.CThis
    exports.esx_shoprobbery:SetClipboard(copy)
    ESX.Alert("Copy Shod", "check")
end)