---@diagnostic disable: missing-parameter, undefined-field
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_carSeller:GetVehicleInfo')
AddEventHandler('esx_carSeller:GetVehicleInfo', function(source_playername, date, description, price, source)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()
	local sellerID = source
	target = GetPlayerServerId(closestPlayer)

	if closestPlayer ~= -1 and playerDistance <= 3.0 then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			if Config.BlackList[string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))] then
				local vehProps = ESX.Game.GetVehicleProperties(vehicle)
				ESX.TriggerServerCallback('esx_advancedgarage:IsOwnerOfVehicle', function(newaccess, isGang)
					if newaccess then
						if not isGang then
							ESX.TriggerServerCallback("esx_carSeller:GetTargetName", function(targetName, money)
								if tonumber(money) >= tonumber(price) then 
									SetNuiFocus(true, true)
									SendNUIMessage({
										action = 'openContractSeller',
										plate = ESX.Math.Trim(vehProps.plate),
										model = ESX.GetVehicleLabelFromHash(vehProps.model) or ESX.GetVehicleLabelFromName(vehProps.model) or GetDisplayNameFromVehicleModel(vehProps.model),
										source_playername = source_playername,
										sourceID = sellerID,
										target_playername = targetName,
										targetID = target,
										date = date,
										description = description,
										price = price,
										carName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)),
									})
								else
									ESX.Alert("Shakhs Mored Nazar Pool Kafi Baraye Kharid In Mashin Nadarad", "error")
									ClearPedTasks(PlayerPedId())
								end
							end, target)
						else
							ESX.Alert("Shoma Nemitavanid Mashin Gang Ra Montaghel Konid", "error")
						end
					else
						ESX.Alert("Shoma Saheb In Mashin Nistid", "error")
						ClearPedTasks(PlayerPedId())
					end
				end, ESX.Math.Trim(vehProps.plate))
			else
				ESX.Alert("Faghat Mashin Haye IC Gholname Mishavand", "error")
			end
		else
			ClearPedTasks(PlayerPedId())
			ESX.Alert("Hich Mashini Nazdik Shoma Nist", "error")
		end
	else
		ClearPedTasks(PlayerPedId())
		ESX.Alert("Hich Shakhsi Nazdik Shoma Nist", "error")
	end
end)

RegisterNetEvent('esx_carSeller:OpenContractInfo')
AddEventHandler('esx_carSeller:OpenContractInfo', function()
	if IsPedInAnyVehicle(PlayerPedId()) then return ESX.Alert("Shoma Nemitavanid Dakhel Mashin Contract Ra Baaz Konid", "info") end
	if exports.esx_credits:isNewPlayer() then return ESX.Alert("NewPlayer Ha Nemitavanand Mashin Gholname Konand", "info") end
	if ESX.GetPlayerData().Level < 3 then return ESX.Alert("Baraye Estefade Az Gholname Bayad Level 3 Bashid", "info") end
	TriggerEvent("esx_inventoryhud:closeInventory")
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openContractInfo'
	})
end)

RegisterNetEvent('esx_carSeller:OpenContractOnBuyer')
AddEventHandler('esx_carSeller:OpenContractOnBuyer', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openContractOnBuyer',
		plate = data.plate,
		model = data.vehicleModel,
		source_playername = data.sourceName,
		sourceID = data.sourceID,
		target_playername = data.targetName,
		targetID = data.targetID,
		date = data.date,
		description = data.description,
		price = data.price,
		carName = data.carName,
	})
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "submitContractInfo" then
		TriggerServerEvent("esx_carSeller:SendVehicleInfo", data.vehicle_description, data.vehicle_price)
		SetNuiFocus(false, false)
	elseif data.action == "signContract1" then
		if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(data.targetID)))) < 3.0 then
			TriggerServerEvent("esx_carSeller:SendContractToBuyer", data)
		else
			ESX.Alert("Shakhs Mored Nazar Az Shoma Door Ast", "error")
		end
		ClearPedTasks(PlayerPedId())
		SetNuiFocus(false, false)
	elseif data.action == "signContract2" then
		TriggerServerEvent("esx_advancedgarage:transferVehicle", data)
		ClearPedTasks(PlayerPedId())
		SetNuiFocus(false, false)
	elseif data.action == "close" then
		ClearPedTasks(PlayerPedId())
		SetNuiFocus(false, false)
	else
		ESX.Alert("Etelaat Vared Shode Sahih Nist", "error")
	end
end)

RegisterNetEvent('esx_carSeller:startContractAnimation')
AddEventHandler('esx_carSeller:startContractAnimation', function(player)
	loadAnimDict('anim@amb@nightclub@peds@')
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

exports("getContractCars", function()
	return Config.BlackList
end)