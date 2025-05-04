ESX = nil
PlayerData = nil
siktir = false

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end
	while ESX.GetPlayerData().gang == nil do 
		Citizen.Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

AddEventHandler("siktirFromCapture", function()
	siktir = true
end)

RegisterNetEvent('esx_killFeed')
AddEventHandler('esx_killFeed',function(killername,killedname,wname,head)
	SendNUIMessage({
		type = 'addKill',
		killer = killername,
		weapon = wname,
		killed = killedname,
		headshot = true
	})
end)

RegisterNetEvent('esx_killFeed:Capture')
AddEventHandler('esx_killFeed:Capture',function(killername,killedname,wname,head)
	if PlayerData and PlayerData.gang and PlayerData.gang.name ~= "nogang" and not siktir then
		SendNUIMessage({
			type = 'addKill',
			killer = killername,
			weapon = wname,
			killed = killedname,
			headshot = true
		})
	end
end)

--[[local Dog

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local Sleep = true
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(90.07912, -1955.248, 20.85498), true) < 30.0 then
			Sleep = false
			RequestModel(GetHashKey("a_c_panther"))
			while not HasModelLoaded(GetHashKey("a_c_panther")) do
				Citizen.Wait(10)
			end
			local _, groundZ = GetGroundZFor_3dCoord(90.07912, -1955.248, 20.85498, false)
			Dog = CreatePed(4, "a_c_panther", 90.07912, -1955.248, groundZ, false, false)
			SetEntityAsMissionEntity(Dog, true, true)
			SetEntityHeading(Dog, 315.66)
			SetBlockingOfNonTemporaryEvents(Dog, true)
			SetEntityInvincible(Dog, true)
			ClearPedTasks(Dog)
			RequestAnimDict("creatures@rottweiler@amb@world_dog_sitting@base")
			while not HasAnimDictLoaded("creatures@rottweiler@amb@world_dog_sitting@base") do
				Citizen.Wait(500)
			end
			TaskPlayAnim(Dog, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 8.0, -4.0, -1, 1, 0.0)
			TaskSetBlockingOfNonTemporaryEvents(Dog, true)
			FreezeEntityPosition(Dog, true)
			break
		end
		if Sleep then Citizen.Wait(710) end
	end
end)]]

