ESX = nil
isInShopMenu = false
local spawnedVehicles = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function OpenBoatShop(shop)
	isInShopMenu = true

	local playerPed = PlayerPedId()
	local elements  = {}

	for k,v in ipairs(Config.Vehicles) do
		table.insert(elements, {
			label = ('%s - <span style="color:green;">$%s</span>'):format(v.label, ESX.Math.GroupDigits(v.price)),
			name  = v.label,
			model = v.model,
			price = v.price,
			props = v.props or nil
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_shop', {
		title    = _U('boat_shop'),
		align    = 'top-left',
		elements = elements
	}, function (data, menu)
		local gangname = nil
		ESX.TriggerServerCallback('esx_boat:GetGang', function(newgangname)
			gangname = newgangname
		end)
		while gangname == nil do
			Wait(100)
		end
		local elements = {}
		if gangname == 'nogang' then
			elements = {
				{label = _U('confirm_no'), value = 'no'},
				{label = _U('confirm_yes'), value = 'yes'}
			}
		else
			elements = {
				{label = 'Kharide in Mashin baraye Khodet', value = 'yes'},
				{label = 'Kharide in Mashin baraye Gang', value = 'gang'},
			}
		end
 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_shop_confirm', {
			title    = data.current.name .. ' for ' .. ESX.Math.GroupDigits(data.current.price) .. ' ?',
			align    = 'top-left',
			elements = elements
		}, function (data2, menu2)
			if data2.current.value == 'yes' then
				local plate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local props = ESX.Game.GetVehicleProperties(vehicle)
				props.plate = plate

				ESX.TriggerServerCallback('esx_boat:buyBoat', function(bought)
					if bought then
						ESX.Alert(_U('boat_shop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						DeleteSpawnedVehicles()
						isInShopMenu = false
						ESX.UI.Menu.CloseAll()

						CurrentAction    = 'boat_shop'
						CurrentActionMsg = _U('boat_shop_open')

						FreezeEntityPosition(playerPed, false)
						ESX.SetEntityCoords(playerPed, shop.Outside.x, shop.Outside.y, shop.Outside.z)
					else
						ESX.Alert(_U('boat_shop_nomoney'))
						menu2.close()
					end
				end, props)
			elseif data2.current.value == 'no' then
				menu2.close()
			elseif data2.current.value == 'gang' then
				local plate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local props = ESX.Game.GetVehicleProperties(vehicle)
				props.plate = plate
				TriggerServerEvent('esx_boat:buyBoatGang', props, gangname)
				DeleteSpawnedVehicles()
				isInShopMenu = false
				ESX.UI.Menu.CloseAll()

				CurrentAction    = 'boat_shop'
				CurrentActionMsg = _U('boat_shop_open')

				FreezeEntityPosition(playerPed, false)
				ESX.SetEntityCoords(playerPed, shop.Outside.x, shop.Outside.y, shop.Outside.z)
			end
		end, function (data2, menu2)
			menu2.close()
		end)
	end, function (data, menu)
		menu.close()
		isInShopMenu = false
		DeleteSpawnedVehicles()

		CurrentAction    = 'boat_shop'
		CurrentActionMsg = _U('boat_shop_open')

		FreezeEntityPosition(playerPed, false)
		ESX.SetEntityCoords(playerPed, shop.Outside.x, shop.Outside.y, shop.Outside.z)
	end, function (data, menu)
		DeleteSpawnedVehicles()

		ESX.Game.SpawnLocalVehicle(data.current.model, shop.Inside, shop.Inside.w, function (vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)

			if data.current.props then
				ESX.Game.SetVehicleProperties(vehicle, data.current.props)
			end
		end)
	end)

	-- spawn first vehicle
	DeleteSpawnedVehicles()

	ESX.Game.SpawnLocalVehicle(Config.Vehicles[1].model, shop.Inside, shop.Inside.w, function (vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)

		if Config.Vehicles[1].props then
			ESX.Game.SetVehicleProperties(vehicle, Config.Vehicles[1].props)
		end
	end)
end

function OpenBoatGarage(garage)
	ESX.TriggerServerCallback('esx_boat:getGarage', function (ownedBoats)
		if #ownedBoats == 0 then
			ESX.Alert(_U('garage_noboats'), "error")
		else
			-- get all available boats
			local elements = {}
			for i=1, #ownedBoats, 1 do
				ownedBoats[i] = json.decode(ownedBoats[i])
				local imp = ownedBoats[i].imp
				table.insert(elements, {
					label = getVehicleLabelFromHash(ownedBoats[i].model).." "..(imp == true and "[✔️]" or "[❌]"),
					vehicleProps = ownedBoats[i],
					imp = ownedBoats[i].imp,
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_garage', {
				title    = _U('garage'),
				align    = 'top-left',
				elements = elements
			}, function (data, menu)
				-- make sure the spawn point isn't blocked
				local playerPed = PlayerPedId()
				local vehicleProps = data.current.vehicleProps
				if vehicleProps.imp then 
					if ESX.Game.IsSpawnPointClear(garage.SpawnPoint, 4.0) then
						TriggerServerEvent('esx_boat:takeOutVehicle', vehicleProps.plate)
						ESX.Alert(_U('garage_taken'), "check")

						ESX.Game.SpawnVehicle(vehicleProps.model, garage.SpawnPoint, garage.SpawnPoint.w, function(vehicle)
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							exports.LegacyFuel:SetFuel(vehicle, 100.0)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							ESX.CreateVehicleKey(vehicle)
							Citizen.CreateThread(function()
								while DoesEntityExist(vehicle) do
									Citizen.Wait(30000)
									exports.LegacyFuel:SetFuel(vehicle, math.random(60, 100) + 0.0)
								end
							end)
						end)

						menu.close()
					else
						ESX.Alert(_U('garage_blocked'), "error")
					end
				else
					menu.close()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_imp', {
						title    = "Dar Avordan In Gahyegh Az Impound",
						align    = 'top-left',
						elements = {
							{label = "Kheyr", value = false},
							{label = "Pardakht Mablagh 30,000$", value = true}
						},
					}, function (data, menu)
						if data.current.value then
							if ESX.GetPlayerData().money >= 30000 then 
								ESX.TriggerServerCallback('esx_boat:storeVehicle', function (rowsChanged)
									if rowsChanged > 0 then
										ESX.Alert("Mashin Az Impound Kharej Shod", "check")
										menu.close()
										OpenBoatGarage(garage)
									end
								end, vehicleProps.plate)
							else
								ESX.Alert("Shoma Pool Kafi Nadarid", "error")
							end
						end
					end, function(data, menu)
						menu.close()
						OpenBoatGarage(garage)
					end)
				end
			end, function (data, menu)
				menu.close()

				CurrentAction     = 'garage_out'
				CurrentActionMsg  = _U('garage_open')
			end)
		end
	end)
end

function OpenLicenceMenu(shop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_license', {
		title    = _U('license_menu'),
		align    = 'top-left',
		elements = {
			{label = _U('license_buy_no'), value = 'no'},
			{label = _U('license_buy_yes', ESX.Math.GroupDigits(Config.LicensePrice)), value = 'yes'}
	}}, function (data, menu)
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_boat:buyBoatLicense', function (boughtLicense)
				if boughtLicense then
					ESX.Alert(_U('license_bought', ESX.Math.GroupDigits(Config.LicensePrice)))
					menu.close()

					OpenBoatShop(shop) -- parse current shop
				else
					ESX.Alert(_U('license_nomoney'))
				end
			end)
		else
			CurrentAction    = 'boat_shop'
			CurrentActionMsg = _U('boat_shop_open')
			menu.close()
		end
	end, function (data, menu)
		CurrentAction    = 'boat_shop'
		CurrentActionMsg = _U('boat_shop_open')
		menu.close()
	end)
end

function StoreBoatInGarage(vehicle, teleportCoords)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

	ESX.TriggerServerCallback('esx_boat:storeVehicle', function (rowsChanged)
		if rowsChanged > 0 then
			ESX.Game.DeleteVehicle(vehicle)
			ESX.Alert(_U('garage_stored'), "check")
			local playerPed = PlayerPedId()

			ESX.Game.Teleport(playerPed, teleportCoords, function()
				SetEntityHeading(playerPed, teleportCoords.w)
			end)
		else
			ESX.Alert(_U('garage_notowner'), "error")
		end
	end, vehicleProps.plate)
end

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function getVehicleLabelFromHash(hash)
	local model = string.lower(GetDisplayNameFromVehicleModel(hash))

	for i=1, #Config.Vehicles, 1 do
		if Config.Vehicles[i].model == model then
			return Config.Vehicles[i].label
		end
	end

	return 'Unknown model [' .. model .. ']'
end
