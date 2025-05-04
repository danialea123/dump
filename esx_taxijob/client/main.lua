---@diagnostic disable: undefined-field, undefined-global, cast-local-type, lowercase-global, missing-parameter, param-type-mismatch, need-check-nil, inject-field
local HasAlreadyEnteredMarker, IsDead, JobStarted, CurrentActionData, firstOne, OutOfVehicle, MissionLocation, TaxiPed = false, false, false, false, false, false, {}, nil
local LastZone, CurrentAction, CurrentActionMsg, BlipsDelivery, LevelLocation
local TimeLeave = 60
local LastDamage = 1000
local taxivehicle = {}
local TaxiKey = {}
local TaximanCondition = false
local startCoords = {}
local tripState = false
local lastPassenger = 0

SR = nil
ESX = nil

Citizen.CreateThread(function()
	while SR == nil do
		TriggerEvent('esx:getSharedObject', function(obj) SR = obj end)
		Citizen.Wait(0)
	end

	while SR.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX = SR
	SR.PlayerData = SR.GetPlayerData()
	PlayerData = SR.GetPlayerData()
end)

function SetVehicleMaxMods(vehicle, plate)
	local props = {
		modEngine       = 10,
		modBrakes       = 10,
		color1       	= 89,
		windowTint		= 1,
		plate           = plate,
		color2       	= 4,
		modTransmission = 10,
		modSuspension   = 10,
		modArmor        = 10,
		modTurbo        = true,
	}

	SR.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

RegisterNetEvent('sr_taxijob:AccessToStartJob')
AddEventHandler('sr_taxijob:AccessToStartJob', function()
	if not SR.Game.IsSpawnPointClear(Config.Zones['Taxi'].StartTaxiJob.SpawnPoint.coords, 5.0) then
		SR.ShowNotification(_U('spawnpoint_blocked'))
		return
	end

	local RandomPed = GetHashKey(Config.TaxiJobPeds[math.random(#Config.TaxiJobPeds)])

	RequestModel(RandomPed)
	while not HasModelLoaded(RandomPed) do
		Wait(500)
	end

	MissionLocation = Config.JobLocations[math.random(#Config.JobLocations)]
	LevelLocation = 'start_loc'
	TaxiPed = CreatePed(2, RandomPed, MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z, MissionLocation[LevelLocation].heading, false, false)
	SR.Game.SpawnVehicle('taxi', Config.Zones['Taxi'].StartTaxiJob.SpawnPoint.coords, Config.Zones['Taxi'].StartTaxiJob.SpawnPoint.heading, function(vehicle)
		local playerPed = PlayerPedId()
		SetPedIntoVehicle(playerPed, vehicle, -1)
		SetVehicleMaxMods(vehicle, "TAXI"..GetPlayerServerId(PlayerId()))
		table.insert(taxivehicle, vehicle)
		ESX.CreateVehicleKey(vehicle)
		TriggerServerEvent('savedVehicles', 'taxi', VehToNet(vehicle))
		BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
		SetBlipRoute(BlipsDelivery, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('blip_delivery'))
		EndTextCommandSetBlipName(BlipsDelivery)
		local PedToEndLocation = #(vector2(MissionLocation['start_loc'].coords.x, MissionLocation['start_loc'].coords.y) - vector2(MissionLocation['end_loc'].coords.x, MissionLocation['end_loc'].coords.y))
		local TimerStp = math.floor(PedToEndLocation*Config.TimeGenerator)
		SetEntityAsMissionEntity(TaxiPed)
		SetBlockingOfNonTemporaryEvents(TaxiPed, true)
		Wait(2000)
    	FreezeEntityPosition(TaxiPed, true)
		SetEntityInvincible(TaxiPed, true)
		exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
		exports['mythic_progbar']:Progress({
			name = "waiting_for_taxi",
			duration = TimerStp,
			label = _U('your_time'),
			useWhileDead = true,
			canCancel = true,
			controlDisables = {},
		}, function(cancelled)
			if cancelled then
				if LevelLocation == 'end_loc' then
					FreezeEntityPosition(TaxiPed, false)
					FreezeEntityPosition(taxivehicle[1], true)
					TaskLeaveVehicle(TaxiPed, taxivehicle[1], 0)
					Wait(4000)
					DeleteEntity(TaxiPed)
					FreezeEntityPosition(taxivehicle[1], false)
				end

				if DoesBlipExist(BlipsDelivery) then
					RemoveBlip(BlipsDelivery)
				end

				if JobStarted then
					TriggerServerEvent('sr_taxijob:successAiJob', 'Canceled')
				end

				JobStarted = false
				firstOne = false
				OutOfVehicle = false
				MissionLocation = {}
				LevelLocation = nil
				TaxiPed = nil
				LastDamage = 1000
				TimeLeave = 60
				if DoesEntityExist(taxivehicle[1]) then
					SR.Game.DeleteVehicle(taxivehicle[1])
				end
				taxivehicle = {}
			end
		end)
		JobStarted = true
	end)
end)

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and LevelLocation == 'back_to_station' then
		local c1 = vector2(Config.Zones['Taxi'].StartTaxiJob.SpawnPoint.coords.x, Config.Zones['Taxi'].StartTaxiJob.SpawnPoint.coords.y)
		local c2 = vector2(MissionLocation['start_loc'].coords.x, MissionLocation['start_loc'].coords.y)
		local c3 = vector2(MissionLocation['end_loc'].coords.x, MissionLocation['end_loc'].coords.y)
		local StationToPed = #(c1 - c2)
		local PedToEndLocation = #(c2 - c3)
		local EndToStation = #(c3 - c1)
		local MoneyGived = math.floor(StationToPed+PedToEndLocation+EndToStation)*Config.EndJobMoney
		TriggerServerEvent('sr_taxijob:giveMoneyForEndingJob', math.floor(MoneyGived))
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle,  0)
		JobStarted = false
		TriggerServerEvent('sr_taxijob:successAiJob', 'Success')
		TriggerEvent('esx_Quest:point', 'NPC', nil, 1)
		TriggerEvent('esx_Quest:point', 'NPC2', nil, 1)
		TriggerEvent("mythic_progbar:client:cancel")
		SR.ShowHelpNotification(_U('your_job_has_ended'))
		SR.ShowAdvancedNotification(_U('ai_job'), _U('manager'), _U('prchs_job', tostring(math.floor(MoneyGived))), 'CHAR_TAXI', 9, false, false, 210)
		DrawSub(_U('mission_complete'), 5000)
	else
		SR.UI.Menu.CloseAll()

		SR.UI.Menu.Open('default', GetCurrentResourceName(), 'verify_cancelling', {
			title    = 'Cancel Job',
			align    = 'top-left',
			elements = {
				{label = _U('yes_cancel'), value = 'yes'},
				{label = _U('no_cancel'), value = 'no'},
			}
		}, function(data, menu)
			if data.current.value == 'yes' then
				SR.UI.Menu.CloseAll()
				TriggerEvent("mythic_progbar:client:cancel")
				SR.ShowHelpNotification(_U('your_job_canceled'))
			elseif data.current.value == 'no' then
				SR.UI.Menu.CloseAll()
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

function OpenCloakroom()
	SR.UI.Menu.CloseAll()
	local elem = {
		{ label = _U('wear_citizen'), value = 'wear_citizen' },
		{ label = _U('wear_work'),    value = 'wear_work'},
		{ label = "Custom Clothe",  value = 'custom'},
	}
	if ESX.GetPlayerData().job.ext == 'dispatch' then
		table.insert(elem, {label = 'Lebas Dispatch', value = 'dispatch'})
	elseif ESX.GetPlayerData().job.ext == 'heli' then
		table.insert(elem, {label = 'Lebas Heli', value = 'heli'})
	end
	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom',
	{
		title    = _U('cloakroom_menu'),
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			TriggerServerEvent('duty', SR.PlayerData.job.name, false)
		elseif data.current.value == 'wear_work' then
			SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
			TriggerServerEvent('duty', SR.PlayerData.job.name, true)
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
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end)
end

function SpawnVehicle(vehicle, plate, coords, heading)
	if not coords then return end
	local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
	if not DoesEntityExist(shokol) then
		TriggerServerEvent('esx_taxijob:saveVehicle', plate, true)
		SR.Game.SpawnVehicle(vehicle.model, {
			x = coords.x,
			y = coords.y,
			z = coords.z + 1
		}, heading, function(callback_vehicle)
			SetVehicleNumberPlateText(callback_vehicle, plate)
			SR.Game.SetVehicleProperties(callback_vehicle, vehicle)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			ESX.CreateVehicleKey(callback_vehicle)
			SetVehicleColours(callback_vehicle, 88, 0)
			TriggerServerEvent('savedVehicles', 'taxi', VehToNet(callback_vehicle))
			Citizen.Wait(2000)
			local targetBlip = AddBlipForEntity(callback_vehicle)
			SetBlipSprite(targetBlip, 225)
			exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
		end)
	else
		SR.ShowNotification('Mahale Spawn mashin ro Khali konid')
	end
end

function OpenVehicleSpawnerMenu()
	SR.UI.Menu.CloseAll()

	local elements = {}

	SR.TriggerServerCallback("esx_society:GetVehiclesByPermission", function(Cars, AccessAll) 
		if not AccessAll then
			if Cars ~= nil then
				local elements = {}
				for i=1, #Cars, 1 do
					table.insert(elements, {
						label = ESX.GetVehicleLabelFromName(Cars[i]), 
						model = Cars[i]
					})
				end
				if #elements == 0 then
					ESX.Alert("~y~Shoma Be Hich Mashini Dastresi Nadarid")
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('vehicle_menu'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					menu.close()
		
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin',
					}, function(data3, menu3)
						if not ESX.IsPlateValid(data3.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
						if data3.value == nil then
							ESX.Alert('Lotfan Yek Pelak Vared Konid!')
						else
							menu3.close()
							ESX.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
								ESX.TriggerServerCallback('esx:callbackVehicle', function(status)
									if status then
							ESX.Alert('In Pelak Ghablan Vared Shode Va Dar Hal Hazer Motalegh Be Yek Nafar Mibashad!', "info")
									else
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), CurrentActionData.Pos, CurrentActionData.Heading)
										TriggerServerEvent('DiscordBot:ToDiscord', 'impound'..PlayerData.job.name, 'Spawn Vehicle', PlayerData.name.." ("..GetPlayerName(PlayerId())..") Spawn Kard Mashin "..data.current.label.." Ba Pelake "..ESX.Math.Trim(data3.value), 'user', GetPlayerServerId(PlayerId()), true, false)
									end
								end, data3.value)
							end, data.current.model)
						end
					end,function(data3, menu3)
						menu3.close()
						CurrentAction     = 'vehicle_spawner'
						CurrentActionMsg  = _U('spawner_prompt')
						CurrentActionData = {}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'vehicle_spawner'
					CurrentActionMsg  = _U('spawner_prompt')
					CurrentActionData = {}
				end)
			end
		else
			if Cars ~= nil then
				local elements = {}
				for k, v in pairs(Cars) do
					table.insert(elements, {
						label = ESX.GetVehicleLabelFromName(v.model), 
						model = v.model
					})
				end
				if #elements == 0 then
					ESX.Alert("~y~Shoma Be Hich Mashini Dastresi Nadarid")
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('vehicle_menu'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					menu.close()
		
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin',
					}, function(data3, menu3)
						if not ESX.IsPlateValid(data3.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
						if data3.value == nil then
							ESX.Alert('Lotfan Yek Pelak Vared Konid!')
						else
							menu3.close()
							ESX.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
								ESX.TriggerServerCallback('esx:callbackVehicle', function(status)
									if status then
							ESX.Alert('In Pelak Ghablan Vared Shode Va Dar Hal Hazer Motalegh Be Yek Nafar Mibashad!', "info")
									else
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), CurrentActionData.Pos, CurrentActionData.Heading)
										TriggerServerEvent('DiscordBot:ToDiscord', 'impound'..PlayerData.job.name, 'Spawn Vehicle', PlayerData.name.." ("..GetPlayerName(PlayerId())..") Spawn Kard Mashin "..data.current.label.." Ba Pelake "..ESX.Math.Trim(data3.value), 'user', GetPlayerServerId(PlayerId()), true, false)
									end
								end, data3.value)
							end, data.current.model)
						end
					end,function(data3, menu3)
						menu3.close()
						CurrentAction     = 'vehicle_spawner'
						CurrentActionMsg  = _U('spawner_prompt')
						CurrentActionData = {}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'vehicle_spawner'
					CurrentActionMsg  = _U('spawner_prompt')
					CurrentActionData = {}
				end)
			end
		end
	end, SR.PlayerData.job.name, SR.PlayerData.job.grade)
end

function DeleteJobVehicle()
	local plate = SR.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle))
	TriggerServerEvent('esx_taxijob:saveVehicle', plate, nil)
	SR.Game.DeleteVehicle(CurrentActionData.vehicle)
end

function OpenTaxiActionsMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('take_stock'), value = 'get_stock'},
		{label = _U('boss_actions'), value = 'boss_actions'}
	}

	if Config.EnablePlayerManagement and SR.PlayerData.job ~= nil and SR.PlayerData.job.grade >= 10 then
		table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})
	end

	SR.UI.Menu.CloseAll()

	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions', {
		title    = 'Taxi',
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
			local options = { withdraw = true }
			--if SR.PlayerData.job ~= nil and SR.PlayerData.job.grade == 10 then
				--options['withdraw'] = false
				--options['employees'] = true
				--options['grades'] = false
			--end
			TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
				menu.close()
			end, options)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function numWithCommas(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
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

function OpenMobileTaxiActionsMenu()
	SR.UI.Menu.CloseAll()
	local elem = {
		{label = "Requests",   value = 'requests'},
		{label = "Dispatch Queue",   value = 'queue'},
		{label = _U('billing'),   value = 'billing'},
	}
	if tripState then
		table.insert(elem, {label = "Payane Safar", value = "meter"})
	else
		table.insert(elem, {label = "Shorou`e Safar", value = "meter"})
	end
	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', 
	{
		title    = 'Taxi',
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()
		if data.current.value == 'requests' then
			openTaxiRequest()
		end
		if data.current.value == 'queue' then
			ExecuteCommand("txduty")
		end
		if data.current.value == "meter" then
			startMeter()
		end
		if data.current.value == 'billing' then
			ChooseFromNearbyPlayers(2, function(target)
				local text = '* Ghabz minevise *'
				TriggerServerEvent('3dme:shareDisplay', text, false)

				SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = _U('invoice_amount')
				}, function(data2, menu2)
					local amount = tonumber(data2.value)
					if amount == nil then
						SR.ShowNotification(_U('amount_invalid'))
					else
						menu2.close()
						TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Taxi Fine***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..SR.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), '', 'Taxi', amount)
						TriggerServerEvent('sr:taxijob:sendToSociety')
						SR.ShowNotification(_U('billing_sent'))
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyStockMenu()
	SR.TriggerServerCallback('sr_taxijob:getStockItems', function(inventory)
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
			title    = _U('buy_stock_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			SR.TriggerServerCallback('sr_taxijob:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('sr_taxijob:addStockItems', data.current.value)
					OpenBuyStockMenu()
				else
					SR.ShowNotification(_U('not_enough_money'))
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
				title    = 'Taxi Stock',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				local itemName = data.current.value

				SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = _U('quantity')
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						SR.ShowNotification(_U('quantity_invalid'))
					else
						menu2.close()
						menu.close()

						TriggerServerEvent('sr_taxijob:getStockItem', itemName, count)
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
	SR.TriggerServerCallback('sr_taxijob:getPlayerInventory', function(inventory)

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
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					SR.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					TriggerServerEvent('sr_taxijob:putStockItems', itemName, count)
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

function ActionControl()
	table.insert(TaxiKey, RegisterKey('E', false, function ()
		if CurrentAction and not IsDead then
			if not JobStarted then
				if CurrentAction == 'taxi_actions_menu' then
					OpenTaxiActionsMenu()
				elseif CurrentAction == 'cloakroom' then
					OpenCloakroom()
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_vehicle' then
					DeleteJobVehicle()
				elseif CurrentAction == 'starttaxijob' then
					TriggerServerEvent('sr_taxijob:checkTimer')
				elseif CurrentAction == 'DelHeli' then
					if IsPedInAnyVehicle(PlayerPedId()) then
						SR.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
					end
				elseif CurrentAction == 'TaxiHeli' then
					if ESX.GetPlayerData().job.ext == 'heli' then
						if not IsPedInAnyVehicle(PlayerPedId()) then
							SR.Game.SpawnVehicle('taxiheli', GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
								ESX.CreateVehicleKey(vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
							end)
						end
					else
						ESX.Alert("Shoma Division Heli Nistid", "info")
					end
				elseif CurrentAction == 'dutyjob' then
					TriggerServerEvent('duty', SR.PlayerData.job.name)
					if SR.PlayerData.job.grade > 0 then
						SR.ShowNotification(_U('off_duty'))
						Citizen.Wait(1000)
					else
						SR.ShowNotification(_U('on_duty'))
						Citizen.Wait(1000)
					end
				end
			end
			if CurrentAction == 'stoptaxijob' then
				if JobStarted then
					StopTaxiJob()
				end
			end
			CurrentAction = nil
		end
	end))
end

function f6Action()
	table.insert(TaxiKey, RegisterKey('F6', false, function ()
		OpenMobileTaxiActionsMenu()
	end))
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	SR.PlayerData = xPlayer
	if SR.PlayerData.job.name == 'taxi' then
		if SR.PlayerData.job.grade > 0 then
			TaximanCondition = true
			TaxiThreads()
			f6Action()
		end
		ActionControl()
		LockerThread()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if SR.PlayerData.job.name ~= 'taxi' then
		if job.name == 'taxi' then
			LockerThread()
		end
	elseif job.name ~= 'taxi' then
		exports.sr_main:RemoveByTag('taxi-locker')
	end

	SR.PlayerData.job = job
	for index,key in pairs(TaxiKey) do
		TaxiKey[index] = UnregisterKey(key)
	end
	exports.sr_main:RemoveByTag('taxi')
	TaximanCondition = false
	Wait(100)
	if SR.PlayerData.job.name == 'taxi' then
		if SR.PlayerData.job.grade > 0 then
			TaximanCondition = true
			TaxiThreads()
			f6Action()
		end
		ActionControl()
	else
		TaximanCondition = false
	end
	PlayerData.job = job
end)

AddEventHandler('sr_taxijob:hasEnteredMarker', function(zone, part)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = Config.Zones[part]["VehicleSpawnPoint"]
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}

	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	elseif zone == 'StartTaxiJob' then
		CurrentAction     = 'starttaxijob'
		CurrentActionMsg  = _U('start_taxi_job')
		CurrentActionData = {}
	elseif zone == 'StopTaxiJob' then
		CurrentAction     = 'stoptaxijob'
		CurrentActionMsg  = _U('stop_taxi_job')
		CurrentActionData = {}
	elseif zone == 'DutyJob' then
		CurrentAction     = 'dutyjob'
		CurrentActionMsg  = _U('duty_job')
		CurrentActionData = {}
	elseif zone == 'TaxiHeli' then
		CurrentAction     = 'TaxiHeli'
		CurrentActionMsg  = 'TaxiHeli'
		CurrentActionData = {}
	elseif zone == 'DelHeli' then
		CurrentAction     = 'DelHeli'
		CurrentActionMsg  = 'DelHeli'
		CurrentActionData = {}
	end
	if CurrentActionMsg then
		Hint:Create(CurrentActionMsg)
	end
end)

AddEventHandler('sr_taxijob:hasExitedMarker', function(zone)
	SR.UI.Menu.CloseAll()
	Hint:Delete()
	CurrentAction = nil
end)

-- Create Blips
CreateThread(function()
	for k,v in ipairs(Config.Blip) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite (blip, 198)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('blip_taxi'))
		EndTextCommandSetBlipName(blip)
	end
end)

function LockerThread()
	for k, v in pairs(Config.Zones) do
		local v2 = v.Cloakroom
		local Interact
		local Point = RegisterPoint(vector3(v2.Pos.x, v2.Pos.y, v2.Pos.z), Config.DrawDistance, true)
		Point.set('Tag', 'taxi-locker')
		Point.set('InArea', function ()
			DrawMarker(v2.Type, v2.Pos.x, v2.Pos.y, v2.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, false, 2, v2.Rotate, nil, nil, false)
		end)
		Point.set('InAreaOnce', function ()
			Interact = RegisterPoint(vector3(v2.Pos.x, v2.Pos.y, v2.Pos.z), v2.Size.x, true)
			Interact.set('Tag', 'taxi-locker')
			Interact.set('InAreaOnce', function ()
				TriggerEvent('sr_taxijob:hasEnteredMarker', 'Cloakroom')
			end, function ()
				TriggerEvent('sr_taxijob:hasExitedMarker', 'Cloakroom')
			end)
		end, function ()
			if Interact then
				Interact.remove()
			end
		end)
	end
end

function TaxiThreads()
	Citizen.CreateThread(function()
		for k,v in pairs(Config.Zones) do
			for k2,v2 in pairs(v) do
				if v2.Type ~= -1 and k2 ~= 'Cloakroom' then
					local DCheker = RegisterPoint(v2.Pos, Config.DrawDistance, true)
					local ICheker = RegisterPoint(v2.Pos, v2.Size.x, true)
					DCheker.set('Tag', 'taxi')
					ICheker.set('Tag', 'taxi')
					DCheker.set('InArea', function()
						DrawMarker(v2.Type, v2.Pos.x, v2.Pos.y, v2.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, false, 2, v2.Rotate, nil, nil, false)
					end)
					ICheker.set('InAreaOnce', function()
						TriggerEvent('sr_taxijob:hasEnteredMarker', k2, k)
					end, function()
						TriggerEvent('sr_taxijob:hasExitedMarker', k2)
					end)
				end
			end
		end
	end)

	-- AI Job Marker
	Citizen.CreateThread(function()
		while TaximanCondition do
			Citizen.Wait(1)
			if MissionLocation and not firstOne then
				if MissionLocation[LevelLocation] and MissionLocation[LevelLocation].coords then
					local coords = GetEntityCoords(PlayerPedId())
					local distance = #(coords - MissionLocation[LevelLocation].coords)

					if IsPedInAnyVehicle(PlayerPedId(), true) then
						local dVeh = #(GetEntityCoords(taxivehicle[1]) - MissionLocation[LevelLocation].coords)
						if dVeh < 5 and LevelLocation == 'start_loc' then
							if AreAnyVehicleSeatsFree(taxivehicle[1]) then
								SR.ShowHelpNotification(_U('waiting_for_ped'), false, true, 3000)
								FreezeEntityPosition(TaxiPed, false)
								FreezeEntityPosition(taxivehicle[1], true)
								TaskEnterVehicle(TaxiPed, taxivehicle[1], 5000, 0, 1.0, 1, 0)
								Wait(5000)
								FreezeEntityPosition(taxivehicle[1], false)
								FreezeEntityPosition(TaxiPed, true)
								LevelLocation = 'end_loc'
								DrawSub(_U('goto_endloc'), 5000)
								RemoveBlip(BlipsDelivery)
								BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
								SetBlipRoute(BlipsDelivery, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(_U('blip_delivery'))
								EndTextCommandSetBlipName(BlipsDelivery)
							else
								SR.ShowHelpNotification(_U('no_have_seat'))
							end
						elseif dVeh < 5 and LevelLocation == 'end_loc' then
							if IsPedInAnyVehicle(TaxiPed, true) then
								SR.ShowHelpNotification(_U('waiting_for_getout'))
								FreezeEntityPosition(TaxiPed, false)
								FreezeEntityPosition(taxivehicle[1], true)
								TaskLeaveVehicle(TaxiPed, taxivehicle[1], 0)
								Wait(4000)
								DeleteEntity(TaxiPed)
								FreezeEntityPosition(taxivehicle[1], false)
								TaxiPed = {}
								LevelLocation = 'back_to_station'
								DrawSub(_U('goto_station'), 5000)
								RemoveBlip(BlipsDelivery)
								BlipsDelivery = AddBlipForCoord(Config.Zones['Taxi'].StopTaxiJob.Pos.x, Config.Zones['Taxi'].StopTaxiJob.Pos.y, Config.Zones['Taxi'].StopTaxiJob.Pos.z)
								SetBlipRoute(BlipsDelivery, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(_U('blip_delivery'))
								EndTextCommandSetBlipName(BlipsDelivery)
							end
						end
					end

					if MissionLocation[LevelLocation] and MissionLocation[LevelLocation].coords and distance then
						if distance <= 50 then
							DrawMarker(1, MissionLocation[LevelLocation].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 204, 204, 0, 100, false, false, 2, true, nil, nil, false)
						end
					end
				end
			end
		end
	end)

	-- AI Job Damage Manager
	Citizen.CreateThread(function()
		while TaximanCondition do
			Citizen.Wait(5000)
			if JobStarted and IsPedInAnyVehicle(PlayerPedId(), true) then
				local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				local plate = GetVehicleNumberPlateText(currentVehicle)
				if plate:gsub(" ", "") ~= "TAXI"..GetPlayerServerId(PlayerId()) then
					RemoveBlip(BlipsDelivery)
					LevelLocation = 'start_loc'
					local coords = GetEntityCoords(TaxiPed)
					MissionLocation[LevelLocation].coords = coords
					BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
					SetBlipRoute(BlipsDelivery, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('blip_delivery'))
					EndTextCommandSetBlipName(BlipsDelivery)
					SR.ShowHelpNotification(_U('back_to_ped'))
				end
			end
		end
	end)

	-- Check Ped In Vehicle
	Citizen.CreateThread(function()
		while TaximanCondition do
			Citizen.Wait(1000)
			if JobStarted and not firstOne and LevelLocation == 'end_loc' then
				if IsPedInAnyVehicle(TaxiPed, true) then
					local currentVehicle = GetVehiclePedIsUsing(TaxiPed)
					local plate = GetVehicleNumberPlateText(currentVehicle)
					if plate:gsub(" ", "") ~= "TAXI"..GetPlayerServerId(PlayerId()) then
						RemoveBlip(BlipsDelivery)
						LevelLocation = 'start_loc'
						local coords = GetEntityCoords(TaxiPed)
						MissionLocation[LevelLocation].coords = coords
						print(MissionLocation[LevelLocation].coords, coords)
						BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
						SetBlipRoute(BlipsDelivery, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(_U('blip_delivery'))
						EndTextCommandSetBlipName(BlipsDelivery)
						SR.ShowHelpNotification(_U('back_to_ped'))
					end
				end
			end
		end
	end)

	-- Check Taxi AI Job
	Citizen.CreateThread(function()
		while TaximanCondition do
			Citizen.Wait(1)
			if JobStarted then
				local IsInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)

				if IsInVehicle then
					local vehicle = GetVehiclePedIsUsing(PlayerPedId())
					if vehicle ~= taxivehicle[1] then
						OutOfVehicle = true
					else
						if firstOne then
							TimeLeave = 60
							firstOne = false
							OutOfVehicle = false
							DrawSub(_U('start_again_job'), 5000)
							if LevelLocation ~= 'back_to_station' then
								BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
								SetBlipRoute(BlipsDelivery, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(_U('blip_delivery'))
								EndTextCommandSetBlipName(BlipsDelivery)
							else
								BlipsDelivery = AddBlipForCoord(Config.Zones['Taxi'].StopTaxiJob.Pos.x, Config.Zones['Taxi'].StopTaxiJob.Pos.y, Config.Zones['Taxi'].StopTaxiJob.Pos.z)
								SetBlipRoute(BlipsDelivery, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(_U('blip_delivery'))
								EndTextCommandSetBlipName(BlipsDelivery)
							end
						end
					end
				else
					OutOfVehicle = true
				end
			end

			if TimeLeave <= 0 or (IsDead and firstOne) then
				TriggerEvent("mythic_progbar:client:cancel")
				SR.ShowHelpNotification(_U('your_job_canceled'))
			end

			if OutOfVehicle then
				Citizen.Wait(1000)
				TimeLeave = TimeLeave-1
				SR.ShowHelpNotification(_U('time_to_canceled', TimeLeave), false, true, 1000)
				if BlipsDelivery ~= nil then
					RemoveBlip(BlipsDelivery)
					firstOne = true
					BlipsDelivery = nil
				end
			end
		end
	end)
end

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

Shared = {}
Shared.taxi = {}
Shared.taxi.tripPrice = 5250
Shared.taxi.tripPriceMethod2 = 7500
Shared.taxi.tripStartPrice = 5000

function startMeter()
    if tripState then
        TriggerServerEvent('taxi:endTrip')
    else
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local maxSeat = GetVehicleMaxNumberOfPassengers(vehicle)
            local passengersList = {}
            for i=maxSeat - 1, 0, -1 do
                local ped = GetPedInVehicleSeat(vehicle, i)
                if ped ~= 0 then
                    local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
                    if serverId ~= ESX.src then
                        table.insert(passengersList, {label = serverId, value = serverId})
                    end
                end
            end
            if #passengersList > 0 then
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kodum',
                {
                    title 	 = 'Safar be nam kodam fard sabt shavad?',
                    align    = 'top-left',
                    elements = passengersList
                }, function(data, menu)
                    menu.close()
                    if not ESX.isVehicleDriver() then return ESX.Alert('Shoma ranande mashin nisid!','error') end
                    TriggerServerEvent('taxi:startTrip', data.current.value)
                    lastPassenger = data.current.value
                end, function(data, menu)
                    menu.close()
                end)
            else
                ESX.Alert('Kasi baraye shorue safar dar mashin nist!','error')
			end
        else
            ESX.Alert('Shoma bayad savar mashin bashid!', 'error')
        end
    end
end

RegisterNetEvent('taxi:startTrip', function(travelCoords, taxi, startPrice)
    if not tripState then
        tripState = true
        startCoords = travelCoords
		SendNUIMessage({
			type = "showUI",
			display = true
		})
        CreateThread(function()
            while tripState do
                Wait(1000)
                local coords =  GetEntityCoords(PlayerPedId())
                local distance = CalculateTravelDistanceBetweenPoints(startCoords.x, startCoords.y, startCoords.z, coords.x, coords.y, coords.z) * 0.621
                local price = ESX.Math.Round((distance / 1000) * Shared.taxi.tripPrice + (not startPrice and Shared.taxi.tripStartPrice or 0))
                if distance > 10000 then
                    distance = (ESX.GetDistance(startCoords, coords) * 0.621)
                    price = ESX.Math.Round((distance / 1000) * Shared.taxi.tripPriceMethod2 + (not startPrice and Shared.taxi.tripStartPrice or 0))
                end
				SendNUIMessage({
                    type = "updateDriver",
                    driver = false
                })

				SendNUIMessage({
					type = "updateFare",
					fare = ESX.Math.Round(Shared.taxi.tripPrice),
					extras = price - ESX.Math.Round(Shared.taxi.tripPrice),
					total = price
				})

                if taxi then
                    TriggerServerEvent('taxi:updateTripPrice', price, distance)
                    if not ESX.Game.DoesPlayerExist(lastPassenger) or ESX.GetDistance(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(lastPassenger))), coords) > 100 then
                        TriggerServerEvent('taxi:endTrip')
                    end
                end
            end
			SendNUIMessage({
				type = "showUI",
				display = false
			})
        end)
    end
end)

RegisterNetEvent('taxi:stopTrip', function()
    tripState = false
    startCoords = {}
    Wait(2000)
	SendNUIMessage({
		type = "showUI",
		display = false
	})
end)

RegisterNetEvent('taxi:fine', function(target, price)
    TriggerServerEvent('esx_billing:sendBill', target , '', 'Taxi', price, true)
end)

function getTaxiTripState()
    return tripState
end

local carblip                 = 0
local drawInD                 = false

local function openRequst(id)
    ESX.TriggerServerCallback('taxi:getlist', function(data)
        ems = data
        elements = {}
        emoji = "❌"
        if ems[id].accept then
            emoji = "✔️"
        end
        table.insert(elements,{label = "Id : ".. ems[id].source,value = "no"})
        table.insert(elements,{label = "Accept status : ".. emoji,value = "no"})
        if ems[id].accept then
            table.insert(elements,{label = "Accepted by : ".. ems[id].acceptername,value = "no"})
        else
            table.insert(elements,{label = "Accept",value = "accept"})
        end
        if ems[id].acceptersource == GetPlayerServerId(PlayerId()) then
            table.insert(elements,{label = "Decline",value = "decline"})
            table.insert(elements,{label = "Finish",value = "finish"})
        end
        table.insert(elements,{label = "Pin location",value = "pin"})
		table.insert(elements,{label = "Phone Number: "..ems[id].number,value = "call"})
        local source = ems[id].source
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list2', 
		{
            title    = 'Request list',
            align    = 'top-left',
            elements = elements
        }, function(data2, menu2)
            if data2.current.value == "accept" then
				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
				ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
                TriggerServerEvent('taxi:accept',id, mugshotStr)
                openRequst(id)
				Citizen.Wait(1000)
				ESX.TriggerServerCallback('getplayercoords', function(coords)
                    if coords ~= nil then
                        SetNewWaypoint(coords.x,coords.y)
                        SetNewWaypoint(coords.x,coords.y)
						ESX.Alert("Location Request Mark Shod", "info")
                    end
                end,source)
            elseif data2.current.value == "decline" then
                TriggerServerEvent('taxi:decline',id)
				ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
                openRequst(id)
            elseif data2.current.value == "finish" then
                TriggerServerEvent('taxi:finish',id)
                menu2.close()
            elseif data2.current.value == "pin" then
                ESX.TriggerServerCallback('getplayercoords', function(coords)
                    if coords ~= nil then
                        SetNewWaypoint(coords.x,coords.y)
                        SetNewWaypoint(coords.x,coords.y)
						ESX.Alert("Location Request Mark Shod", "info")
                    end
                end,source)
            elseif data2.current.value == "call" then
                --TriggerEvent('gcphone:autoCall',ems[id].number)
                --exports['sunset_phone']:Call({number = ems[id].number,name = ems[id].number})
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end)
end

function openTaxiRequest()
	ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('taxi:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            local elements = {}
            for k , v in pairs(ems) do
                if v.show and v.job == "all" or v.job == PlayerData.job.name then
                    emoji = "❌"
                    if v.accept then
                        emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
                    end
                    table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .." | Distance : ".. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)),value = k})
                end
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', 
			{
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data2, menu)
                menu.close()
                local id = tonumber(data2.current.value)
                openRequst(id)
            end, function(data2, menu)
                menu.close()
            end)
        end
    end)
end

RegisterNetEvent('taxi:openAdmin',function()
    ESX.TriggerServerCallback('taxi:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            elements = {}
            for k , v in pairs(ems) do
                emoji = "❌"
                if v.accept then
                    emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
                end
                table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .." | Distance : ".. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)) ,value = k})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', 
			{
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data2, menu)
                menu.close()
                local id = tonumber(data2.current.value)
                openRequst(id)
            end, function(data2, menu)
                menu.close()
            end)
        end
    end)
end)

RegisterNetEvent('taxi:addtaxiblip',function(id,coords,mug,name)
    local id = id
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
    Wait(2000)
	carblip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(carblip, 198)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,5)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Taxi officer')
	EndTextCommandSetBlipName(carblip)
    while carblip ~= 0 do
        Wait(1000)
        ESX.TriggerServerCallback('getplayercoords', function(coords)
            if coords ~= nil then
                SetBlipCoords(carblip, coords.x, coords.y, coords.z)
            else
                RemoveBlip(carblip)
                carblip = 0
            end
        end,id)
		ESX.ShowAdvancedNotification(name, '~g~Dar rah ast~s~', '/taxi to open request menu', 'CHAR_TAXI', 7)
    end
end)

RegisterNetEvent('taxi:deleteblip',function()
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
end)

RegisterCommand('taxi',function()
	ESX.TriggerServerCallback('taxi:getMeRequest',function(id,v)
		if id == nil then
			ESX.ShowNotification('Shoma hich darkhast taxi ersal nakardid')
		else
			elements = {}
			emoji = "❌"
			if v.accept then
				emoji = "✔️"
			end
			table.insert(elements,{label = "Request id : ".. id .. " | Accept : ".. emoji, value = ''})
			if v.accept then
				table.insert(elements,{label = "Accepted by : ".. v.acceptername,value = "no"})
				table.insert(elements,{label = "Phone Number: "..v.accepternumber,value = "call"})
			else
				table.insert(elements,{label = "Cancel request",value = "cancel"})
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
				title    = 'Request list',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if data.current.value == "call" then
					--TriggerEvent('gcphone:autoCall',v.accepternumber)
					--exports['sunset_phone']:Call({number = v.accepternumber,name = v.accepternumber})
				elseif data.current.value == "cancel" then
					ESX.TriggerServerCallback('taxi:remove',function(data)
						menu.close()
					end)
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end)
end, false)

RegisterNetEvent('taxi:acceptq',function(id)
	local id = id
	local clicked = false
	ESX.UI.Menu.CloseAll()
    local elements = {
        {label = 'Bale', value = true},
        {label = 'Kheyr', value = false},
    }
	ExecuteCommand('f Darkhast ' .. id .. ' baraye man ersal shod')
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'a' .. id,
    {
		title 	 = 'Darkhast jadid!',
		align    = 'center',
		question = 'Aya mayel be ghabul kardan darkhast hastid?',
		elements = elements
    }, function(data, menu)
		clicked = true
        menu.close()
		if data.current.value then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
			TriggerServerEvent('taxi:accept',id,mugshotStr)
			ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
		else
			ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
			TriggerServerEvent("taxi:reject", id)
		end
    end)

    Citizen.SetTimeout(10000,function()
        if not clicked then
            ESX.UI.Menu.Close('question',GetCurrentResourceName(), 'a' .. id)
            ExecuteCommand('f Darkhast ' .. id .. ' be dalil AFK reject shod!')
			TriggerServerEvent("taxi:reject", id)
        end
    end)
end)

RegisterNetEvent('taxi:acceptKarde',function()
    if not drawInD then
        drawInD = true
        reqid = 0
        Citizen.CreateThread(function()
            while drawInD do
                Citizen.Wait(0)
                ESX.ShowMissionText('~y~Request in progress('.. reqid ..')')
            end
        end)
        Citizen.CreateThread(function()
            while drawInD do
                local bedeBezanim = false
                ESX.TriggerServerCallback('taxi:getlist', function(data)
                    ems = data
                    for k , v in pairs(ems) do
                        if v.acceptersource and v.acceptersource == GetPlayerServerId(PlayerId()) then
                            bedeBezanim = true
                            reqid = v.source
                        end
                    end
                    if not bedeBezanim then
                        drawInD = false
                    end
                end)
                Citizen.Wait(10000)
            end
        end)
    end
end)

function CountTable(object)
    local count = 0
    for k,v in pairs(object) do
        count = count + 1
    end
    return count
end