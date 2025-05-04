---@diagnostic disable: undefined-global, undefined-field, param-type-mismatch, missing-parameter, inject-field
ESX        = nil
PlayerData = nil
local Time = 0
local Near = false
local Data = nil
local Data2 = nil

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(1000)
    end
    PlayerData = ESX.GetPlayerData()
    if Config.Zones[PlayerData.job.name] ~= nil then
        Loop = true
        Data = Config.Zones[PlayerData.job.name]
        Install()
    end
    if Config.Zones[PlayerData.job.name.."2"] then
        Loop = true
        Data2 = Config.Zones[PlayerData.job.name.."2"]
        Install2()
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    Loop = false
    if Config.Zones[PlayerData.job.name] then
        SetTimeout(3000, function()
            Loop = true
            Data = Config.Zones[PlayerData.job.name]
            Install()
            if Config.Zones[PlayerData.job.name.."2"] then
                Loop = true
                Data2 = Config.Zones[PlayerData.job.name.."2"]
                Install2()
            end
        end)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

AddEventHandler("onKeyUP", function(key)
    if key == "e" then
        if Config.Zones[PlayerData.job.name] == nil then return end
        if Near then
            if GetGameTimer() - Time > 2000 then
                if string.find(ESX.GetPlayerData().job.name, "off") then
                    ExecuteCommand("f Man ^2On-Duty ^0Shodam")
                else
                    ExecuteCommand("f Man ^1Off-Duty ^0Shodam")
                end
                Time = GetGameTimer()
                TriggerServerEvent("esx_duty:SetDutyStatus")
            else
                ESX.Alert("Lotfan Spam Nakonid", 'error')
            end
        end
    end
end)

function Install()
    CreateThread(function ()
        while Loop do
            Wait(3)
            local Sleep = true 
            if Data and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Data.Pos.x, Data.Pos.y, Data.Pos.z, true) < Config.DrawDistance then
                DrawMarker(Data.Type, Data.Pos.x, Data.Pos.y, Data.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Data.Size.x, Data.Size.y, Data.Size.z, Data.Color.r, Data.Color.g, Data.Color.b, 100, false, true, 2, false, false, false, false)
                Sleep = false
                Near = true
            end
            if Sleep then Near = false Wait(710) end
        end
    end)
end

function Install2()
    CreateThread(function ()
        while Loop do
            Wait(3)
            local Sleep = true 
            if Data2 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Data2.Pos.x, Data2.Pos.y, Data2.Pos.z, true) < Config.DrawDistance then
                DrawMarker(Data2.Type, Data2.Pos.x, Data2.Pos.y, Data2.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Data2.Size.x, Data2.Size.y, Data2.Size.z, Data2.Color.r, Data2.Color.g, Data2.Color.b, 100, false, true, 2, false, false, false, false)
                Sleep = false
                Near = true
            end
            if Sleep then Near = false Wait(710) end
        end
    end)
end

AddEventHandler('PlayerLoadedToGround', function ()
	while PlayerData == nil or PlayerData.job == nil do Wait(500) end
	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "benny" or PlayerData.job.name == "forces" or PlayerData.job.name == "weazel" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "taxi" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "medic" then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
			end
		end)
	end
end)