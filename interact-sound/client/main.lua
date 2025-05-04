local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local standardVolumeOutput = 1.0;

RegisterNetEvent('InteractSound_CL:PlayOnOne')
AddEventHandler('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('InteractSound_CL:PlayOnAll')
AddEventHandler('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
    if ESX == nil then return end
    if ESX.Game.DoesPlayerExistInArea(playerNetId) then
        local lCoords = GetEntityCoords(PlayerPedId())
        local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
        local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
        if(distIs <= maxDistance) then
            SendNUIMessage({
                transactionType     = 'playSound',
                transactionFile     = soundFile,
                transactionVolume   = soundVolume
            })
        end
    end
end)