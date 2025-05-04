local PlayerData = {}
local ESX = nil

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    Citizen.Wait(800)

    PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(Player)
    PlayerData = Player
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(Job)
    PlayerData.job = Job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

local Timer = 0
--[[RegisterKey("H", false, function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        if PlayerData.gang.name ~= 'nogang' then
            if GetGameTimer() - Timer > 5000 then
                Timer = GetGameTimer()  
                Leaderboard()
            end
        end
    end
end)]]

function Leaderboard()

    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	
	SendNUIMessage({
		message		 = "show"
	})

    ESX.TriggerServerCallback('lab-TopCriminals:getData', function(cb)
        local count = 0
        for k,v in pairs(cb) do
            SendNUIMessage({
                message		 = "add",
                label = v.label:gsub("^%l", string.upper),
                score = v.score,
                type = ESX.Math.GroupDigits(v.type)
            })
            count = count + 1
            if count >= 10 then
                break
            end
        end
    end)

	SetTimecycleModifier('hud_def_blur')
	
	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
    ESX.SetTimeout(7000, function()
        SetNuiFocus(false, false)
        SendNUIMessage({message = "hide"})
        SetTimecycleModifier('default')
	end)
end

exports("Leaderboard", Leaderboard)

function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({message = "hide"})
  SetTimecycleModifier('default')
end

RegisterNUICallback('quit', function(data, cb)
  closeGui()
  cb('ok')
end)