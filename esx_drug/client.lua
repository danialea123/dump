---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-field, undefined-global
local PlayerData = {}
ESX = nil

local Point = vector3(-681.69,347.75,83.09)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(900)
	end
	PlayerData = ESX.GetPlayerData()
	if PlayerData.job.ext and PlayerData.job.ext == "drs" and PlayerData.job.name == "ambulance" then
		Point = vector3(-681.69,347.75,83.09)
		Cartel()
	end
	if PlayerData.job.ext and PlayerData.job.ext == "drs" and PlayerData.job.name == "medic" then
		Point = vector3(1761.8,3652.78,34.85)
		Cartel()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	if PlayerData.job.ext and PlayerData.job.ext == "drs" and PlayerData.job.name == "ambulance" then
		Point = vector3(-681.69,347.75,83.09)
		Cartel()
	end
	if PlayerData.job.ext and PlayerData.job.ext == "drs" and PlayerData.job.name == "medic" then
		Point = vector3(1761.8,3652.78,34.85)
		Cartel()
	end
end)

local CanPressKey = false

function Cartel()
	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(2)
			local Sleep = true
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Point, true) < 2 then
				Sleep = false
				DrawMarker(Config.Marker.type, Point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255,0,0, 100, false, false, 2,false, nil, false)
				ESX.ShowHelpNotification("~INPUT_CONTEXT~ To Open Menu")
				CanPressKey = true
			end
			if Sleep then CanPressKey = false Citizen.Wait(710) end
		end
	end)
end

AddEventHandler("onKeyDown", function(key)
	if key == "e" then
		if CanPressKey then
			if PlayerData.job.ext and PlayerData.job.ext == "drs" then
				SetNuiFocus( true, true )
				SendNUIMessage({
					ativa = true
				})
			end
		end
	end
end)

RegisterNUICallback('1', function(data, cb)
	TriggerServerEvent("item_cearft_ao","desomorphine")
	SetNuiFocus( false, false )
			SendNUIMessage({
				ativa = false
			})
  	cb('ok')
end)

RegisterNUICallback('2', function(data, cb)
	TriggerServerEvent("item_cearft_ao", "modafinil")
	SetNuiFocus( false, false )
	SendNUIMessage({
		ativa = false
	})
  	cb('ok')
end)

RegisterNUICallback('3', function(data, cb)
	TriggerServerEvent("item_cearft_ao","Ibuprofen")
	SetNuiFocus( false, false )
	SendNUIMessage({
		ativa = false
	})
  	cb('ok')
end)

RegisterNUICallback('4', function(data, cb)
	TriggerServerEvent("item_cearft_ao","proplus")
	SetNuiFocus( false, false )
	SendNUIMessage({
		ativa = false
	})
  	cb('ok')
end)

RegisterNUICallback('5', function(data, cb)
	TriggerServerEvent("item_cearft_ao", "wellbutrin")
	SendNUIMessage({
		ativa = false
	})
  	cb('ok')
end)

RegisterNUICallback('6', function(data, cb)
	TriggerServerEvent("item_cearft_ao","sianor")
	SetNuiFocus( false, false )
	SendNUIMessage({
		ativa = false
	})
  	cb('ok')
end)

RegisterNUICallback('7', function(data, cb)
	TriggerServerEvent("item_cearft_ao","adr")
	SetNuiFocus( false, false )
	SendNUIMessage({
		ativa = false
	})
  	cb('ok')
end)

RegisterNUICallback('fechar', function(data, cb)
	SetNuiFocus( false )
	SendNUIMessage({
	ativa = false
	})
  	cb('ok')
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

RegisterNetEvent("Emote:mecano")
AddEventHandler("Emote:mecano",function()
	ExecuteCommand("e mechanic")
	exports.essentialmode:DisableControl(true)
	TriggerEvent("Emote:SetBan", true)
    TriggerEvent("dpclothingAbuse", true)
	SetTimeout(20000, function()
		exports.essentialmode:DisableControl(false)
		TriggerEvent("Emote:SetBan", false)
		TriggerEvent("dpclothingAbuse", false)
	end)
end)

--[[RegisterNetEvent('alavi:monitorefect')
AddEventHandler('alavi:monitorefect', function()
	DoScreenFadeOut(1000)
    Wait(1000)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedIsDrunk(GetPlayerPed(-1), true)
    DoScreenFadeIn(1000)
    Wait(60000)
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(GetPlayerPed(-1), false)
end)]]

RegisterNetEvent('alavi:healitem')
AddEventHandler('alavi:healitem', function(status)
	local ped = PlayerPedId()
	ESX.TriggerServerCallback("esx_drugs:ExistenceMedicine", function(canUse)
		if canUse then
			if status == 'heal' then
				local intime = true
				ESX.Alert("Shoma Az Wellbutrin Estefade Kardid", "info")
				Citizen.CreateThread(function()
					while intime == true do 
						Citizen.Wait(1000)
						if GetEntityMaxHealth(ped) > GetEntityHealth(ped) then
							ESX.SetEntityHealth(ped,GetEntityHealth(ped)+1)
						end 
					end 
				end)
				SetTimeout(40000,function()
					intime = false
					ESX.Alert("Asar Wellbutrin Az Beyn Raft", "info")
				end)
			elseif status == 'heal50' then 
				ESX.SetEntityHealth(ped, GetEntityHealth(ped)+50)
			elseif status == 'die' then 
				ESX.SetEntityHealth(ped,0)
				Citizen.Wait(5000)
				ESX.SetEntityHealth(ped,0)
				Citizen.Wait(5000)
				ESX.SetEntityHealth(ped,0)
				Citizen.Wait(5000)
				ESX.SetEntityHealth(ped,0)
			end
		end
	end)
end)