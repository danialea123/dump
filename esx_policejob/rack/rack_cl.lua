local isRackOpen = false
local authorizedJobs = {
    ["police"] = true,
    ["forces"] = true,
    ["sheriff"] = true,
}

RegisterNUICallback("sendRequest", function(data)
    if isRackOpen then
        TriggerServerEvent("policerack:equipItem", data.item, data.plate)
    end
end)

RegisterNUICallback("closeRack", function()
    closeRack(false)
end)

RegisterNetEvent("rack:requestOpenRack")
AddEventHandler("rack:requestOpenRack", function(data)
    if not isRackOpen then
        isRackOpen = true
        local protectedRack = {}

        for weapon, data in pairs(data.inventory) do
            protectedRack[weapon] = data
        end

        data.inventory = protectedRack

        if not data.job then
            data.job = PlayerData.job.name
        end
        
        SendNUIMessage({type = "open", data = data})
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        exports.essentialmode:DisableControl(true)
        disableActions(IsPedOnFoot(PlayerPedId()))
    end
end)

RegisterNetEvent("rack:updateItemCount")
AddEventHandler("rack:updateItemCount", function(data)
    if isRackOpen then
        SendNUIMessage({type = "update", data = data})
    end
end)

RegisterCommand("rack", function(source, args)
    if authorizedJobs[PlayerData.job.name] then
        if isRackOpen then return ESX.Alert("Rack Dar Hale Hazer Baaz Ast", "error") end
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped)

        if not DoesEntityExist(vehicle) then vehicle = ESX.Game.GetVehicleInDirection(4) end

        if DoesEntityExist(vehicle) then
            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
            TriggerServerEvent("rack:requestOpenRack", plate)
        else
            ESX.Alert("Hich Mashini Nazdik Shoma Nist, Ya Mashin Mored Nazar Be Organ Shoma Taalogh Nadarad", "error")
        end
    else
        ESX.Alert("Shoma Dastresi Baraye Estefade Az In Dastoor Nadarid", "error")
    end
end)

RegisterCommand("closerack", function(source, args)
    closeRack(true)
end)

function closeRack(sendNui)
    if isRackOpen then
       if sendNui then SendNUIMessage({type = "close"}) end
        TriggerServerEvent("rack:rackClosed")
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        exports.essentialmode:DisableControl(false)
        isRackOpen = false
    end
end

function disableActions(OnFoot)
	Citizen.CreateThread(function()
		while isRackOpen do
            Citizen.Wait(5)
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true) -- N
            EnableControlAction(0, 244, true) -- M
            if not OnFoot then
				EnableControlAction(0, 32, true) -- W
				EnableControlAction(0, 34, true) -- A
				EnableControlAction(0, 31, true) -- S
                EnableControlAction(0, 30, true) -- D
                EnableControlAction(0, 59, true) -- Enable steering in vehicle
                EnableControlAction(0, 71, true) -- Enable driving forward in vehicle
                EnableControlAction(0, 72, true) -- Enable reversing in vehicle
			end
		end
	end)
end