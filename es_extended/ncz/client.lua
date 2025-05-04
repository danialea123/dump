---@diagnostic disable: lowercase-global, undefined-global, param-type-mismatch
--local ESX = nil
local playerid = PlayerId()
local ncz = nil
local area = nil

function StartInNCZ()
	if area ~= nil then
		Citizen.CreateThread(function()
			while area ~= nil do
				if exclude and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_STUNGUN") then
					EnableAllControlActions(0)
				else
					DisablePlayerFiring(PlayerPedId(), true)
					DisableControlAction(0,24,true) -- disable attack
					--[[DisableControlAction(0,47,false) -- disable weapon]]
					DisableControlAction(0,58,true) -- disable weapon
					DisableControlAction(0,263,true) -- disable melee
					DisableControlAction(0,264,true) -- disable melee
					DisableControlAction(0,257,true) -- disable melee
					DisableControlAction(0,140,true) -- disable melee
					DisableControlAction(0,141,true) -- disable melee
					DisableControlAction(0,142,true) -- disable melee
					DisableControlAction(0,143,true) -- disable melee
					DisableControlAction(0, 45, true)
					DisableControlAction(0, 69, true) -- Melee Attack 1
					DisableControlAction(0, 70, true)
					DisableControlAction(0, 92, true)
				end
				Citizen.Wait(1)
			end
		end)
	end
end

function StartNCZ()
	if ncz ~= true then
		ncz = true
		Citizen.CreateThread(function()
			while ncz do
				local ped = GetPlayerPed(-1)
				local coords = GetEntityCoords(ped)
				if area == nil then
					for k, v in pairs(Config.Zones) do
						if GetDistanceBetweenCoords(coords, v.coords, false) < v.distance then
							area = k
							StartInNCZ()
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							TriggerEvent('5G-Hud:INZone')
							break
						end
					end
				elseif GetDistanceBetweenCoords(coords, Config.Zones[area].coords, false) >= Config.Zones[area].distance then
					area = nil
					TriggerEvent('5G-Hud:OUTZone')
				end
				Citizen.Wait(1000)
			end
		end)
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
	while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
		ESX.PlayerData = ESX.GetPlayerData()
		Citizen.Wait(100)
	end
	if Config.Jobs[ESX.PlayerData.job.name] then
		ncz = false
	else
		StartNCZ()
	end
	PlayerData = ESX.GetPlayerData()
	exclude = PlayerData.job.ext == "security"
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, oldjob)
	PlayerData.job = job
	exclude = PlayerData.job.ext == "security"
	if Config.Jobs[job.name] and not Config.Jobs[oldjob.name] then
		ncz = false
		area = nil
	elseif not Config.Jobs[job.name] and Config.Jobs[oldjob.name] and ncz == false then
		StartNCZ()
	end
end)

AddEventHandler("ncz:release", function(state)
	if state then
		ncz = false
		area = nil
	else
		if Config.Jobs[PlayerData.job.name] then
			ncz = false
		else
			StartNCZ()
		end
		exclude = PlayerData.job.ext == "security"
	end
end)

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
	ncz = false
	area = nil
	if Bucket == 0 or Bucket == 100 then
		exclude = PlayerData.job.ext == "security"
		if Config.Jobs[PlayerData.job.name] then
			ncz = false
		else
			StartNCZ()
		end
	else
		ncz = false
		area = nil
	end
end)