---@diagnostic disable: undefined-field, missing-parameter
SR = nil
ESX = nil
local holdingCam, holdingMic, holdingBmic = false, false, false
local camModel, camanimDict, camanimName, micModel, micanimDict, micanimName, bmicModel, bmicanimDict, bmicanimName = "prop_v_cam_01", "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", "p_ing_microphonel_01", "missheistdocksprep1hold_cellphone", "hold_cellphone", "prop_v_bmike_01", "missfra1", "mcs2_crew_idle_m_boom"
local bmic_net, mic_net, cam_net = nil, nil, nil
local CurrentAction, CurrentActionMsg, CurrentActionData
local IsDead = false
local PlayerData = {}
local WeazelKey = {}
local UI = { 
	x =  0.000,
	y = -0.001,
}

Citizen.CreateThread(function()
	while SR == nil do
		TriggerEvent('esx:getSharedObject', function(obj) SR = obj end)
		Citizen.Wait(0)
	end

	while SR.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX = SR
	PlayerData = SR.GetPlayerData()

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	LockerThread()
	WeazelThreads()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	LockerThread()
	WeazelThreads()
end)

function ActionControl()
	table.insert(WeazelKey, RegisterKey('E', false, function ()
		if CurrentAction and not IsDead then
			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'weazel' then
				if CurrentAction == 'actions_menu' then
					OpenActionsMenu()
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_vehicle' then
					local plate = SR.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle))
					TriggerServerEvent('sr_weazeljob:saveVehicle', plate, false)
					SR.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'helicopter_spawn' then
					OpenVehicleHeliMenu()
				elseif CurrentAction == 'delete_heli' then
					SR.Game.DeleteVehicle(CurrentActionData.vehicle)
				end
				CurrentAction = nil
			end
		end
	end))

	table.insert(WeazelKey, RegisterKey('F6', false, function ()
		OpenWeazelActionsMenu()
	end))
end

function OpenVehicleSpawnerMenu()
	SR.UI.Menu.CloseAll()
	SR.TriggerServerCallback("esx_society:GetVehiclesByPermission", function(Cars, AccessAll) 
		if not AccessAll then
			if Cars ~= nil then
				local elements = {}
				for i=1, #Cars, 1 do
					table.insert(elements, {
						label = SR.GetVehicleLabelFromName(Cars[i]), 
						model = Cars[i]
					})
				end
				if #elements == 0 then
					SR.Alert("~y~Shoma Be Hich Mashini Dastresi Nadarid")
				end
				SR.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = "Car Menu",
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					menu.close()
		
					SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin',
					}, function(data3, menu3)
						if not ESX.IsPlateValid(data3.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
						if data3.value == nil then
							SR.Alert('Lotfan Yek Pelak Vared Konid!')
						else
							menu3.close()
							SR.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
								SR.TriggerServerCallback('esx:callbackVehicle', function(status)
									if status then
										SR.Alert('In Pelak Ghablan Vared Shode Va Dar Hal Hazer Motalegh Be Yek Nafar Mibashad!')
									else
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading)
									end
								end, data3.value)
							end,  data.current.model)
						end
					end, function(data3, menu3)
						menu3.close()
						CurrentAction     = 'vehicle_spawner'
						CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
						CurrentActionData = {}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'vehicle_spawner'
					CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
					CurrentActionData = {}
				end)
			end
		else
			if Cars ~= nil then
				local elements = {}
				for k, v in pairs(Cars) do
					table.insert(elements, {
						label = SR.GetVehicleLabelFromName(v.model), 
						model = v.model
					})
				end
				if #elements == 0 then
					SR.Alert("~y~Shoma Be Hich Mashini Dastresi Nadarid")
				end
				SR.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = "Car Menu",
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					menu.close()
		
					SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin',
					}, function(data3, menu3)
						if not ESX.IsPlateValid(data3.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
						if data3.value == nil then
							SR.Alert('Lotfan Yek Pelak Vared Konid!')
						else
							menu3.close()
							SR.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
								SR.TriggerServerCallback('esx:callbackVehicle', function(status)
									if status then
							ESX.Alert('In Pelak Ghablan Vared Shode Va Dar Hal Hazer Motalegh Be Yek Nafar Mibashad!', "info")
									else
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading)
									end
								end, data3.value)
							end, data.current.model)
						end
					end, function(data3, menu3)
						menu3.close()
						CurrentAction     = 'vehicle_spawner'
						CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
						CurrentActionData = {}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'vehicle_spawner'
					CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
					CurrentActionData = {}
				end)
			end
		end
	end)
end

function OpenVehicleHeliMenu()
	SR.UI.Menu.CloseAll()
	local elements = {}
	if PlayerData.job ~= nil and PlayerData.job.grade >= 3 then
		table.insert(elements, {label = 'Heli - 1', value = 'newsheli'})
		table.insert(elements, {label = 'Heli - 2', value = 'newsheli2'})
	end
	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_spawn', {
		title    = "Garage Mashin",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		SpawnVehicleHeli(data.current.value)
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'helicopter_spawn'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
		CurrentActionData = {}
	end)
end

function GetAvailableVehicleSpawnPoint(spawnPoint)
	local found, foundSpawnPoint = false, nil

	if SR.Game.IsSpawnPointClear(spawnPoint.Pos, 2) then
		found, foundSpawnPoint = true, spawnPoint
	end

	if found then
		return true, foundSpawnPoint
	else
		return false
	end
end

function SpawnVehicle(vehicle, plate, coords, heading)
	local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
	if not DoesEntityExist(shokol) then
		TriggerServerEvent('sr_weazeljob:saveVehicle', plate, true)
		SR.Game.SpawnVehicle(vehicle.model, {
			x = coords.x,
			y = coords.y,
			z = coords.z + 1
		}, heading, function(callback_vehicle)
			SetVehicleNumberPlateText(callback_vehicle, plate)
			SR.Game.SetVehicleProperties(callback_vehicle, vehicle)
			ESX.CreateVehicleKey(callback_vehicle)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			TriggerServerEvent('savedVehicles', 'weazel', VehToNet(callback_vehicle))
			Wait(2000)
			local targetBlip = AddBlipForEntity(callback_vehicle)
			SetBlipSprite(targetBlip, 225)
			exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
		end)
	else
		SR.ShowNotification('Mahale Spawn mashin ro Khali konid')
	end
end

function SpawnVehicleHeli(model)
	Wait(math.random(0, 500))
	local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(Config.Zones.HelicopterSpawnPoint)
	if foundSpawn then
		SR.Game.SpawnVehicle(model, spawnPoint.Pos, spawnPoint.Heading, function(callback_vehicle)
			local props = {
				modEngine       = 10,
				modBrakes       = 10,
				windowTint		= 1,
				modTransmission = 10,
				modSuspension   = 10,
				modArmor        = 10,
				modTurbo        = true,
			}
			SetVehRadioStation(callback_vehicle, "OFF")
			SR.Game.SetVehicleProperties(callback_vehicle, props)
			ESX.CreateVehicleKey(callback_vehicle)
			Citizen.Wait(2000)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			TriggerServerEvent('savedVehicles', 'weazel', VehToNet(callback_vehicle))
			exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
		end)
	else
		SR.ShowNotification("Makan ~y~Spawn Heli~s~ ~r~Por~s~ Ast!")
	end
end

function OpenBuyStockMenu()
	SR.TriggerServerCallback('esx_weazelnews:getStockItems', function(inventory)
		local elements = {}
		for i=1, #Config.AuthorizedItems, 1 do
			local item = Config.AuthorizedItems[i]
			local count  = 0
			for i2=1, #inventory, 1 do
				if inventory[i2].name == item.name then
					count = inventory[i2].count
					break
				end
			end
			table.insert(elements, {label = 'x' .. count .. ' ' .. item.label .. ' $' .. item.price, value = item.name, price = item.price})
		end

		SR.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_stock', {
			title    = 'Buy Stock Items',
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			SR.TriggerServerCallback('esx_weazelnews:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_weazelnews:addStockItems', data.current.value)
					OpenBuyStockMenu()
				else
					SR.ShowNotification('Pool ~r~Kafi~s~ Nadarid!')
				end
			end, data.current.price)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_society:GetSocietyInventory', function(items)
		ESX.TriggerServerCallback('esx_society:GetItemsByPermission', function(access, all)
			local elements = {}
			if all then
				for i=1, #items, 1 do
					if items[i].name ~= nil and items[i].label ~= nil and items[i].count > 0 then
						table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. (items[i].label or "Unknown"), value = items[i].name})
					end
				end
			else
				for i=1, #items, 1 do
					for k, v in pairs(access) do
						if items[i].name == v and items[i].count > 0 then
							table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. (items[i].label or "Unknown"), value = items[i].name})
						end
					end
				end
			end

			SR.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    = 'Weazel News Stock',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				local itemName = data.current.value
				SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = 'Tedad'
				}, function(data2, menu2)
					local count = tonumber(data2.value)
					if count == nil then
						SR.ShowNotification('Meghdar ~r~Eshtebah~s~ Ast!')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_weazelnews:getStockItem', itemName, count)
						Citizen.Wait(1000)
						OpenGetStocksMenu()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
			end)
		end)
	end)
end

function OpenPutStocksMenu()
	SR.TriggerServerCallback('esx_weazelnews:getPlayerInventory', function(inventory)
		local elements = {}
		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		SR.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Inventory',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Tedad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil then
					SR.ShowNotification('Meghdar ~r~Eshtebah~s~ Ast!')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_weazelnews:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenActionsMenu()
	local elements = {
		{label = 'Put Stock', value = 'put_stock'},
		{label = 'Get Stock', value = 'get_stock'},
		{label = 'Boss Action', value = 'boss_actions'}
	}

	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'Buy Item', value = 'buy_items'})
	end

	SR.UI.Menu.CloseAll()

	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'weazel_actions', {
		title    = 'Weazel',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'buy_items' then
			OpenBuyStockMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'weazel', function(data, menu)
				menu.close()
			end, { withdraw = true })
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'actions_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Menu~s~'
		CurrentActionData = {}
	end)
end

function OpenCloakroom()
	SR.UI.Menu.CloseAll()
	local elem = {
		{label = 'Lebas Shahrvandi', value = 'wear_citizen'},
		{label = 'Lebas Kar',    value = 'wear_work'},
		{ label = "Custom Clothe",  value = 'custom'},
	}
	if ESX.GetPlayerData().job.ext == 'dispatch' then
		table.insert(elem, {label = 'Lebas Dispatch', value = 'dispatch'})
	elseif ESX.GetPlayerData().job.ext == 'heli' then
		table.insert(elem, {label = 'Lebas Heli', value = 'heli'})
	end
	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'weazel_cloakroom', {
		title    = 'Komod Lebas',
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			TriggerServerEvent('duty', PlayerData.job.name, false)
		elseif data.current.value == 'wear_work' then
			SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
			TriggerServerEvent('duty', PlayerData.job.name, true)
		elseif data.current.value == 'dispatch' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleDispatchClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'heli' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleHeliClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'custom' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleCustomClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		end
		TriggerEvent('sr_weazelnews:hasExitedMarker', nil)
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Komod Lebas~s~'
		CurrentActionData = {}
	end)
end

AddEventHandler('sr_weazelnews:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye ~r~Impound Mashin~s~'
			CurrentActionData = {vehicle = vehicle}
		else
			CurrentActionMsg  = nil
		end
	elseif zone == 'HelicopterSpawn' then
		CurrentAction     = 'helicopter_spawn'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Garage~s~'
		CurrentActionData = {}
	elseif zone == 'HelicopterDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_heli'
			CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye ~r~Impound Heli~s~'
			CurrentActionData = {vehicle = vehicle}
		else
			CurrentActionMsg  = nil
		end
	elseif zone == 'Actions' then
		CurrentAction     = 'actions_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Menu~s~'
		CurrentActionData = {}
	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan ~y~Komod Lebas~s~'
		CurrentActionData = {}
	end
	if CurrentActionMsg then
		Hint:Create(CurrentActionMsg)
	end
end)

AddEventHandler('sr_weazelnews:hasExitedMarker', function(zone)
	SR.UI.Menu.CloseAll()
	Hint:Delete()
	CurrentAction = nil
end)

-- Create blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Blip.coords)

	SetBlipSprite(blip, Config.Blip.sprite)
	SetBlipDisplay(blip, Config.Blip.display)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, Config.Blip.color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Weazel News')
	EndTextCommandSetBlipName(blip)
end)

function LockerThread()
	exports.sr_main:RemoveByTag('weazel-locker')
	Wait(100)

	local v2 = Config.Zones.Cloakroom
	local Point = RegisterPoint(vector3(v2.Pos.x, v2.Pos.y, v2.Pos.z), Config.DrawDistance, true)
	local Interact = RegisterPoint(vector3(v2.Pos.x, v2.Pos.y, v2.Pos.z), v2.Size.x, true)
	Point.set('Tag', 'weazel-locker')
	Interact.set('Tag', 'weazel-locker')
	Point.set('InArea', function ()
		DrawMarker(v2.Type, v2.Pos.x, v2.Pos.y, v2.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, false, 2, v2.Rotate, nil, nil, false)
	end)
	Interact.set('InAreaOnce', function()
		TriggerEvent('sr_weazelnews:hasEnteredMarker', 'Cloakroom')
	end, function()
		TriggerEvent('sr_weazelnews:hasExitedMarker', nil)
	end)
end

function WeazelThreads()
	exports.sr_main:RemoveByTag('WeazelJob')
	
	for index, key in pairs(WeazelKey) do
		WeazelKey[index] = UnregisterKey(key)
	end

	Hint:Delete()
	
	Wait(100)

	if PlayerData.job.name == 'weazel' then
		table.insert(WeazelKey, RegisterKey('E', false, function()
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z), true) <= 1.0 then
				OpenCloakroom()
			end
		end))
		if not (PlayerData.job.grade > 0) then
			return
		end
	else
		return
	end

	ActionControl()

	for k,v in pairs(Config.Zones) do
		if v.Type ~= -1 and k ~= 'Cloakroom' then
			local DCheker = RegisterPoint(v.Pos, Config.DrawDistance, true)
			local ICheker = RegisterPoint(v.Pos, v.Size.x, true)
			DCheker.set('Tag', 'WeazelJob')
			ICheker.set('Tag', 'WeazelJob')
			DCheker.set('InArea', function()
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
			end)
			ICheker.set('InAreaOnce', function()
				TriggerEvent('sr_weazelnews:hasEnteredMarker', k)
			end, function()
				TriggerEvent('sr_weazelnews:hasExitedMarker', k)
			end)
		end
	end
end

local OnSleep = false
function ChooseFromNearbyPlayers(distance, cb)
	if OnSleep then
		SR.ShowNotification('Dar har ~r~10 Saniye~s~ faghat 1 bar mitavanid in amaliat ra anjam bedid.')
		return
	end

	OnSleep = true
	SetTimeout(10000, function()
		OnSleep = false
	end)

	local players, nearbyPlayer = SR.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), distance + 0.0)
	local foundPlayers = false
	local elements = {}

	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			foundPlayers = true
			table.insert(elements, {source_id = GetPlayerServerId(players[i]), value = players[i]})
		end
	end

	if not foundPlayers then
	  	SR.ShowNotification('Hich fardi dar nazdiki shoma ~r~yaft~s~ nashod!')
		OnSleep = false
		return
	end

	SR.TriggerServerCallback('Diamond:getClosestPlayersName', function(PlayersElem)
		SR.UI.Menu.Open('default', GetCurrentResourceName(), 'send_bill_to_nearby_player', {
			title    = 'Lotfan fard mored nazar ro entekhab konid:',
			align    = 'top-left',
			elements = PlayersElem
		}, function(data, menu)
			SR.UI.Menu.Open('default', GetCurrentResourceName(), 'send_bill_confirm', {
				title    = 'Aya motmaenid ke mikhahid ' .. data.current.label .. ' ro entekhab konid?',
				align    = 'top-left',
				elements = {
					{label = 'Kheyr',  value = 'no'},
					{label = 'Bale', value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value == 'yes' then
					local target = data.current.value
					menu.close()
					local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(target)))
					if dist <= (distance + 0.0) then
						cb(target)
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data2, menu2)
			menu2.close()
		end)
	end, elements, 'label')
end

function OpenWeazelActionsMenu()
	SR.UI.Menu.CloseAll()

	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_weazel_actions', {
	  title    = 'Weazel Action',
	  align    = 'top-left',
	  elements = {
		  {label = 'Soorat hesab', value = 'billing'},
	  }
	 }, function(data, menu)
		if IsBusy then return end
		if data.current.value == 'billing' then
			menu.close()
			ChooseFromNearbyPlayers(2, function(target)
				local text = '* Ghabz minevise *'
				ExecuteCommand("me "..text)

				SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Enter Price'
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil or amount < 0 or amount > 100000 then
						SR.ShowNotification('Meqdar eshtebah ast')
					end

					menu2.close()
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Weazel Fine***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..SR.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_weazel', 'Weazel', amount)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent("Cam:ToggleCam")
AddEventHandler("Cam:ToggleCam", function()
    if not holdingCam then
        RequestModel(GetHashKey(camModel))
        while not HasModelLoaded(GetHashKey(camModel)) do
            Wait(100)
        end
		TriggerEvent("toggleHUD", true)
		TriggerEvent("sr_chat:toggleChat", false)
		TriggerEvent("timePlay", false)
		TriggerEvent("dpclothingAbuse", true)
		TriggerEvent("Emote:SetBan", true)
		exports.essentialmode:DisableControl(true)
        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local camspawned = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, true, 1, 1)
        Wait(1000)
        local netid = ObjToNet(camspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(camspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0)
        TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		TriggerEvent('toggleID', false)
		TriggerEvent('sr:changeHUDState', false)
        cam_net = netid
        holdingCam = true
		SR.ShowHelpNotification("To Enter News Cam Press ~INPUT_PICKUP~ \nTo Enter Movie Cam Press ~INPUT_INTERACTION_MENU~")
		TriggerCamThread()
    else
		TriggerEvent("toggleHUD", false)
		TriggerEvent("sr_chat:toggleChat", true)
		TriggerEvent("timePlay", true)
		TriggerEvent("dpclothingAbuse", false)
		TriggerEvent("Emote:SetBan", false)
		exports.essentialmode:DisableControl(false)
		holdingCam = false
		Wait(100)
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
		TriggerEvent('toggleID', true)
		TriggerEvent('sr:changeHUDState', true)
        DetachEntity(NetToObj(cam_net), 1, 1)
        DeleteEntity(NetToObj(cam_net))
        cam_net = nil
    end
end)

local fov_max, fov_min = 70.0, 5.0
local zoomspeed, speed_lr, speed_ud = 10.0, 8.0, 8.0
local fov = (fov_max+fov_min)*0.5
local camera = false
function TriggerCamThread()
	CreateThread(function()
		SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)

		while not HasAnimDictLoaded(camanimDict) do
			RequestAnimDict(camanimDict)
			Wait(100)
		end

		while holdingCam and not IsDead do
			Wait(1)

			if not IsEntityPlayingAnim(PlayerPedId(), camanimDict, camanimName, 3) then
				TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
				TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end

			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 37, true)
		end
	end)

	CreateThread(function()
		while holdingCam and not IsDead do
			Wait(1)
			if IsControlJustReleased(1, 244) then
				movcamera = true

				SetTimecycleModifier("default")
				SetTimecycleModifierStrength(0.3)

				local scaleform = RequestScaleformMovie("security_camera")
				while not HasScaleformMovieLoaded(scaleform) do
					Wait(10)
				end

				local lPed = GetPlayerPed(-1)
				local vehicle = GetVehiclePedIsIn(lPed)
				local cam1 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
				AttachCamToEntity(cam1, lPed, 0.0, 0.5, 0.55, true)
				SetCamRot(cam1, 2.0,1.0,GetEntityHeading(lPed))
				SetCamFov(cam1, fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform, "security_camera")
				PopScaleformMovieFunctionVoid()

				while movcamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
					if IsControlJustPressed(0, 177) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						movcamera = false
					end

					SetEntityRotation(lPed, 0, 0, new_z,2, true)

					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam1, zoomvalue)

					HandleZoom(cam1)
					HideHUDThisFrame()

					DrawRect((UI.x + 0.0) + 1.0/2, (UI.y + 0.0) + 0.15/2, 1.0, 0.15, 0, 0, 0, 255)
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					DrawRect((UI.x + 0.0) + 1.0/2, (UI.y + 0.85) + 0.16/2, 1.0, 0.16, 0, 0, 0, 255)

					local camHeading = GetGameplayCamRelativeHeading()
					local camPitch = GetGameplayCamRelativePitch()
					if camPitch < -70.0 then
						camPitch = -70.0
					elseif camPitch > 42.0 then
						camPitch = 42.0
					end
					camPitch = (camPitch + 70.0) / 112.0

					if camHeading < -180.0 then
						camHeading = -180.0
					elseif camHeading > 180.0 then
						camHeading = 180.0
					end
					camHeading = (camHeading + 180.0) / 360.0

					SetTaskMoveNetworkSignalFloat(GetPlayerPed(-1), "Pitch", camPitch)
					SetTaskMoveNetworkSignalFloat(GetPlayerPed(-1), "Heading", camHeading * -1.0 + 1.0)

					Wait(0)
				end

				movcamera = false
				ClearTimecycleModifier()
				fov = (fov_max+fov_min)*0.5
				RenderScriptCams(false, false, 0, 1, 0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam1, false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end
	end)

	CreateThread(function()
		while holdingCam and not IsDead do
			Wait(1)
			if IsControlJustReleased(1, 38) then
				newscamera = true

				SetTimecycleModifier("default")
				SetTimecycleModifierStrength(0.3)

				local scaleform = RequestScaleformMovie("security_camera")
				local scaleform2 = RequestScaleformMovie("breaking_news")

				while not HasScaleformMovieLoaded(scaleform) do
					Wait(10)
				end
				while not HasScaleformMovieLoaded(scaleform2) do
					Wait(10)
				end

				local lPed = GetPlayerPed(-1)
				local vehicle = GetVehiclePedIsIn(lPed)
				local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
				AttachCamToEntity(cam2, lPed, 0.0, 0.5, 0.55, true)
				SetCamRot(cam2, 2.0,1.0,GetEntityHeading(lPed))
				SetCamFov(cam2, fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
				PushScaleformMovieFunction(scaleform2, "breaking_news")
				PopScaleformMovieFunctionVoid()

				while newscamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
					if IsControlJustPressed(1, 177) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						newscamera = false
					end

					SetEntityRotation(lPed, 0, 0, new_z,2, true)

					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam2, zoomvalue)

					HandleZoom(cam2)
					HideHUDThisFrame()

					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
					Breaking("Diamond NEWS")

					local camHeading = GetGameplayCamRelativeHeading()
					local camPitch = GetGameplayCamRelativePitch()
					if camPitch < -70.0 then
						camPitch = -70.0
					elseif camPitch > 42.0 then
						camPitch = 42.0
					end
					camPitch = (camPitch + 70.0) / 112.0

					if camHeading < -180.0 then
						camHeading = -180.0
					elseif camHeading > 180.0 then
						camHeading = 180.0
					end
					camHeading = (camHeading + 180.0) / 360.0

					SetTaskMoveNetworkSignalFloat(GetPlayerPed(-1), "Pitch", camPitch)
					SetTaskMoveNetworkSignalFloat(GetPlayerPed(-1), "Heading", camHeading * -1.0 + 1.0)

					Wait(0)
				end

				newscamera = false
				ClearTimecycleModifier()
				fov = (fov_max+fov_min)*0.5
				RenderScriptCams(false, false, 0, 1, 0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam2, false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end
	end)
end

RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
	camera = not camera
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = GetPlayerPed(-1)
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end

RegisterNetEvent("Mic:ToggleMic")
AddEventHandler("Mic:ToggleMic", function()
    if not holdingMic then
        RequestModel(GetHashKey(micModel))
        while not HasModelLoaded(GetHashKey(micModel)) do
            Wait(100)
        end

		while not HasAnimDictLoaded(micanimDict) do
			RequestAnimDict(micanimDict)
			Wait(100)
		end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local micspawned = CreateObject(GetHashKey(micModel), plyCoords.x, plyCoords.y, plyCoords.z, true, 1, 1)
        Wait(1000)
        local netid = ObjToNet(micspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(micspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0)
        TaskPlayAnim(GetPlayerPed(PlayerId()), micanimDict, micanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        mic_net = netid
        holdingMic = true
    else
		holdingMic = false
		Wait(100)
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(mic_net), 1, 1)
        DeleteEntity(NetToObj(mic_net))
        mic_net = nil
    end
end)

RegisterNetEvent("Mic:ToggleBMic")
AddEventHandler("Mic:ToggleBMic", function()
    if not holdingBmic then
        RequestModel(GetHashKey(bmicModel))
        while not HasModelLoaded(GetHashKey(bmicModel)) do
            Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local bmicspawned = CreateObject(GetHashKey(bmicModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
        Wait(1000)
        local netid = ObjToNet(bmicspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(bmicspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        bmic_net = netid
        holdingBmic = true
		TriggerMicThread()
    else
		holdingBmic = false
		Wait(100)
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(bmic_net), 1, 1)
        DeleteEntity(NetToObj(bmic_net))
        bmic_net = nil
    end
end)

function TriggerMicThread()
	CreateThread(function()
		while holdingBmic and not IsDead do
			Wait(1)

			while not HasAnimDictLoaded(bmicanimDict) do
				RequestAnimDict(bmicanimDict)
				Wait(100)
			end

			if not IsEntityPlayingAnim(PlayerPedId(), bmicanimDict, bmicanimName, 3) then
				TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
				TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end

			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0,25, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0,37, true)
			SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)

			if (IsPedInAnyVehicle(GetPlayerPed(-1), -1) and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) or IsPedCuffed(GetPlayerPed(-1)) or holdingMic then
				ClearPedSecondaryTask(GetPlayerPed(-1))
				DetachEntity(NetToObj(bmic_net), 1, 1)
				DeleteEntity(NetToObj(bmic_net))
				bmic_net = nil
				holdingBmic = false
			end
		end
	end)
end

function Breaking(text)
	SetTextColour(255, 255, 255, 255)
	SetTextFont(8)
	SetTextScale(1.2, 1.2)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.2, 0.85)
end

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

RegisterCommand('rockstar', function()
	if PlayerData.job.name == "weazel" then
		TriggerEvent('weazel:editor')
	else
		SR.Alert("Shoma Weazel News Nistid", "error")
	end
end)
  
RegisterNetEvent('weazel:editor', function()
	TriggerEvent('nh-context:sendMenu', {
		{
			id = 1,
			header = "Recording Menu ♕",
			txt = ""
		},
	{
			id = 2,
			header = "Start Record",
			txt = "Select",
			params = {
				event = "notw:rec",
				args = {
					number = 1,
					id = 2
				}
			}
		},
		{
			id = 3,
			header = "Stop and Save",
			txt = "Select",
			params = {
				event = "notw:stop",
				args = {
					number = 1,
					id = 3
				}
			}
		},
		{
			id = 4,
			header = "Stop and Delete",
			txt = "Select",
			params = {
				event = "notw:delete",
				args = {
					number = 1,
					id = 4
				}
			}
		},
		{
			id = 5,
			header = "Open Rockstar Editor",
			txt = "Select",
			params = {
				event = "notw:rock",
				args = {
					number = 1,
					id = 5
				}
			}
		},
		{
		  id = 6,
		  header = "◀",
		  txt = "",
		  params = {
			  event = "",
			  args = {
				  number = 1,
				  id = 6
			  }
		  }
	  },
	})
end)
  
AddEventHandler('notw:rec', function()
	if PlayerData.job.name == "weazel" then
		StartRecording(1)
	end
end)

AddEventHandler('notw:stop', function()
	if PlayerData.job.name == "weazel" then
		StopRecordingAndSaveClip()
	end
end)

AddEventHandler('notw:delete', function()
	if PlayerData.job.name == "weazel" then
		StopRecordingAndDiscardClip()
	end
end)

AddEventHandler('notw:rock', function()
	if PlayerData.job.name == "weazel" then
		NetworkSessionLeaveSinglePlayer()
		ActivateRockstarEditor()  
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		if holdingBmic or holdingCam then
			TriggerEvent('esx_Quest:point', 'Camera', nil, 1)
		end
	end
end)