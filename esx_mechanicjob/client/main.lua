---@diagnostic disable: param-type-mismatch, param-type-mismatch, undefined-field, lowercase-global, missing-parameter, undefined-global
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX = nil 
SR = nil
local PlayerData              = {}
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsDead                  = false
local IsBusy                  = false
local MecanoKey				  = nil
local MenuKey 				  = nil
local impound = {busy = false, vehicle = 0}

Citizen.CreateThread(function()
	while SR == nil do
		TriggerEvent('esx:getSharedObject', function(obj) SR = obj end)
		Citizen.Wait(0)
	end

	ESX = SR

	while ESX.GetPlayerData().job == nil do
		Wait(50)
	end

	PlayerData = ESX.GetPlayerData()
	
	--[[if PlayerData.job.name == "mechanic" and PlayerData.job.grade >= 5 then
		BuyThread()
	end]]
end)

function GetAvailableVehicleSpawnPoint(pos, index, heli)
	local spawnPoint
	if heli then
		spawnPoint = Config.Zones[pos].HeliGarage.SpawnPoints[index]
	else
		spawnPoint = Config.Zones[pos].VehicleGarage.SpawnPoints[index]
	end
	local found, foundSpawnPoint = false, nil

	if SR.Game.IsSpawnPointClear(spawnPoint.coords, spawnPoint.radius) then
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
		TriggerServerEvent('esx_mechanicjob:saveVehicle', plate, true)
		SR.Game.SpawnVehicle(vehicle.model, {
			x = coords.x,
			y = coords.y,
			z = coords.z + 1
		}, heading, function(callback_vehicle)
			if plate then
				SetVehicleNumberPlateText(callback_vehicle, plate)
			end
			SR.Game.SetVehicleProperties(callback_vehicle, vehicle)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			ESX.CreateVehicleKey(callback_vehicle)
			--TriggerServerEvent('savedVehicles', 'mecano', VehToNet(callback_vehicle))
			Citizen.Wait(2000)
			local targetBlip = AddBlipForEntity(callback_vehicle)
			SetBlipSprite(targetBlip, 225)
			exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
			TriggerServerEvent('DiscordBot:ToDiscord', ESX.GetPlayerData().job.name..'vehicle', 'Spawn Vehicle', GetPlayerName(PlayerId()).."("..ESX.GetPlayerData().name..") Plate: "..GetVehicleNumberPlateText(callback_vehicle), 'user', GetPlayerServerId(PlayerId()), true, false)
		end)
	else
	  	SR.ShowNotification('Mahale Spawn mashin ro Khali konid')
	end
end

function OpenVehicleSpawnerMenu(pos, index)
	local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(pos, index)
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
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), spawnPoint.coords, spawnPoint.heading)
									end
								end, data3.value)
							end, data.current.model)
						end
					end,function(data3, menu3)
						menu.close()
						CurrentAction     = 'mecano_garage_menu'
						CurrentActionMsg  = _U('open_garage')
						CurrentActionData = {}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'mecano_garage_menu'
					CurrentActionMsg  = _U('open_garage')
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
										SR.Alert('In Pelak Ghablan Vared Shode Va Dar Hal Hazer Motalegh Be Yek Nafar Mibashad!')
									else
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), spawnPoint.coords, spawnPoint.heading)
									end
								end, data3.value)
							end, data.current.model)
						end
					end,function(data3, menu3)
						menu.close()
						CurrentAction     = 'mecano_garage_menu'
						CurrentActionMsg  = _U('open_garage')
						CurrentActionData = {}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'mecano_garage_menu'
					CurrentActionMsg  = _U('open_garage')
					CurrentActionData = {}
				end)
			end
		end
	end, PlayerData.job.name, PlayerData.job.grade)
end

function OpenClotheMenu()
	local elements = {
		{label = _U('work_wear'), value = 'workwear'},
		{label = _U('civ_wear'), value = 'civwear'},
		{label = "Custom Clothe", value = 'custom'},
	}
	if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'Lebas Heli', value = 'heli'})
		table.insert(elements, {label = 'Lebas Dispatch', value = 'dispatch'})
	end
	if ESX.GetPlayerData().job.ext == 'heli' then
		table.insert(elements, {label = 'Lebas Heli', value = 'heli'})
	elseif ESX.GetPlayerData().job.ext == 'dispatch' then
		table.insert(elements, {label = 'Lebas Dispatch', value = 'dispatch'})
	end

  	SR.UI.Menu.CloseAll()

  	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_clothe', {
		title    = _U('clothe_menu'),
		align    = 'top-left',
		elements = elements
    }, function(data, menu)
      	if data.current.value == 'workwear' then
			menu.close()
			SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
			TriggerServerEvent('duty', PlayerData.job.name, true)
		elseif data.current.value == 'civwear' then
			menu.close()
			SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			TriggerServerEvent('duty', PlayerData.job.name, false)
		elseif data.current.value == 'dispatch' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleDispatchClothe", function(clothe)
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
		elseif data.current.value == 'heli' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleHeliClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		end
    end, function(data, menu)
		menu.close()
		CurrentAction     = 'mecano_clothe_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
    end)
end

function OpenMecanoBossActionsMenu()
	TriggerEvent('esx_society:openBossMenu', string.lower(PlayerData.job.name), function(data, menu)
		menu.close()
	end, {withdraw = true})
end

function OpenMecanoActionsMenu()
	local elements = {
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'},
		--{label = "Personal Stash", value = 'stash'},
	}
	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})
	end

  	SR.UI.Menu.CloseAll()

  	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_actions', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = elements
    }, function(data, menu)

		if data.current.value == "stash" then
            ESX.UI.Menu.CloseAll()
            TriggerEvent("esx_inventoryhud:OpenStash", PlayerData.job.name)
            return 
        end
		
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		end
		if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end
		if data.current.value == 'buy_items' then
			OpenBuyStockMenu()
		end
    end, function(data, menu)
		menu.close()
		CurrentAction     = 'mecano_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
    end)
end

function OpenMecanoHarvestMenu()
  	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('gas_can'), value = 'gaz_bottle'},
			{label = _U('repair_tools'), value = 'fix_tool'},
			{label = _U('body_work_tools'), value = 'caro_tool'}
		}

    	SR.UI.Menu.CloseAll()

    	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_harvest', {
			title    = _U('harvest'),
			align    = 'top-left',
			elements = elements
     	}, function(data, menu)
			if data.current.value == 'gaz_bottle' then
				menu.close()
				TriggerServerEvent('sr_mechanicjob:startHarvest')
			end

			if data.current.value == 'fix_tool' then
				menu.close()
				TriggerServerEvent('sr_mechanicjob:startHarvest2')
			end

			if data.current.value == 'caro_tool' then
				menu.close()
				TriggerServerEvent('sr_mechanicjob:startHarvest3')
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'mecano_harvest_menu'
			CurrentActionMsg  = _U('harvest_menu')
			CurrentActionData = {}
      	end)
  	else
    	SR.ShowNotification(_U('not_experienced_enough'))
  	end
end

function OpenMecanoCraftMenu()
  	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			--{label = _U('blowtorch'),  value = 'blow_pipe'},
			--{label = _U('repair_kit'), value = 'fix_kit'},
			--{label = _U('body_kit'),   value = 'caro_kit'}
		}

		SR.UI.Menu.CloseAll()

		SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_craft',{
			title    = _U('craft'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'blow_pipe' then
				menu.close()
				TriggerServerEvent('sr_mechanicjob:startCraft')
			end

			if data.current.value == 'fix_kit' then
				menu.close()
				TriggerServerEvent('sr_mechanicjob:startCraft2')
			end

			if data.current.value == 'caro_kit' then
				menu.close()
				TriggerServerEvent('sr_mechanicjob:startCraft3')
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'mecano_craft_menu'
			CurrentActionMsg  = _U('craft_menu')
			CurrentActionData = {}
		end)
  	else
    	SR.ShowNotification(_U('not_experienced_enough'))
  	end
end

function OpenBuyStockMenu()
	SR.TriggerServerCallback('sr_mechanicjob:getStockItems', function(inventory)
		local elements = {}

		for i=1, #Config.AuthorizedItems, 1 do
			local item = Config.AuthorizedItems[i]
			local count = 0
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
			SR.TriggerServerCallback('sr_mechanicjob:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('sr_mechanicjob:addStockItems', data.current.value)
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

local currentlyTowedVehicle = nil

local variables = {
	[GetHashKey('mcflat')] = {
		x = -1.0, 
		y = -6.9, 
		z = 0.7
	},
	[GetHashKey('mcflat1')] = {
		x = -0.35, 
		y = -0.9, 
		z = 1.45
	},
	[GetHashKey('mcflat2')] = {
		x = -0.35, 
		y = -2.9, 
		z = -0.45
	},
	[GetHashKey('mcflat3')] = {
		x = 0.0, 
		y = -1.9, 
		z = 0.75
	},
	[GetHashKey('bnflat')] = {
		x = -1.0, 
		y = -6.9, 
		z = 0.7
	},
	[GetHashKey('bflat1')] = {
		x = -0.35, 
		y = -0.9, 
		z = 1.45
	},
	[GetHashKey('bflat2')] = {
		x = -0.35, 
		y = -2.9, 
		z = -0.45
	},
	[GetHashKey('bflat3')] = {
		x = 0.0, 
		y = -1.9, 
		z = 0.75
	},
}

---@diagnostic disable-next-line: missing-parameter
RegisterCommand("towvehicle", function()
	if PlayerData.job.name == "mechanic" or PlayerData.job.name == "benny" then
		local playerped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerped, true)
		local towmodel  = GetHashKey('mcflat')
		local towmodel1 = GetHashKey('mcflat1')
		local towmodel2 = GetHashKey('mcflat2')
		local towmodel3 = GetHashKey('mcflat3')
		local towmodel4 = GetHashKey('bnflat')
		local towmodel5 = GetHashKey('bflat1')
		local towmodel6 = GetHashKey('bflat2')
		local towmodel7 = GetHashKey('bflat3')
		local isVehicleTow = IsVehicleModel(vehicle, towmodel) or IsVehicleModel(vehicle, towmodel1) or IsVehicleModel(vehicle, towmodel2) or IsVehicleModel(vehicle, towmodel3) or IsVehicleModel(vehicle, towmodel4) or IsVehicleModel(vehicle, towmodel5) or IsVehicleModel(vehicle, towmodel6) or IsVehicleModel(vehicle, towmodel7)     
		local mod = GetEntityModel(vehicle)
		if isVehicleTow then
			if IsVehicleModel(vehicle, towmodel1) then
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "Flatbed1 Dar Hale Hazer Ghabel Estefade Nist")
				return
			end
			if IsVehicleModel(vehicle, towmodel5) then
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "Flatbed1 Dar Hale Hazer Ghabel Estefade Nist")
				return
			end
			local coordA = GetEntityCoords(playerped, 1)
			local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
			local targetVehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
			if currentlyTowedVehicle == nil then
				if targetVehicle ~= 0 then
					if not IsPedInAnyVehicle(playerped, true) then
						if vehicle ~= targetVehicle then
							if not IsEntityAttached(vehicle) and not IsEntityAttached(targetVehicle) then
								NetworkRequestControlOfEntity(targetVehicle)
								AttachEntityToEntity(targetVehicle, vehicle, 20, variables[mod].x, variables[mod].y, variables[mod].z, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								currentlyTowedVehicle = targetVehicle
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "mashin be towtruck attach shod")
							else
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "mashin flatbed ya mashin mored nazar nabayad be chizi attach shode bashand")
							end
						else
							TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "lotfan nazdik mashin digar beravid")
						end
					end
				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "hish mashini baraye tow kardan shensaii nashod")
				end
			else
				AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
				DetachEntity(currentlyTowedVehicle, true, true)
				currentlyTowedVehicle = nil
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "mashin deattach shod")
			end
		end
	end
end)

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

Busy = false

function OpenMobileMecanoActionsMenu()
  	SR.UI.Menu.CloseAll()

  	SR.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mecano_actions', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = {
			{label = _U('billing'),       value = 'billing'},
			{label = _U('hijack'),        value = 'hijack_vehicle'},
			{label = _U('repair'),        value = 'fix_vehicle'},
			{label = _U('clean'),         value = 'clean_vehicle'},
			{label = _U('imp_veh'),       value = 'del_vehicle'},
			{label = "Flip Vehicle",       value = 'flip'},
			{label = "Tow Vehicle To Flatbed",       value = 'tow'},
			{label = "Requests",       value = 'requests'},
			{label = "Dispatch Queue",       value = 'queue'},

		}
	}, function(data, menu)
		if IsBusy then return end
		if data.current.value == 'billing' then
			menu.close()
			ChooseFromNearbyPlayers(2, function(target)
				local text = '* Ghabz minevise *'
				ExecuteCommand("me "..text)

				SR.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = _U('invoice_amount')
				}, function(data2, menu2)
					local amount = tonumber(data2.value)
					if amount == nil or amount < 0 or amount > 100000 then
						SR.ShowNotification(_U('amount_invalid'))
					end

					menu2.close()
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Mecano Fine***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..SR.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_'..SR.GetPlayerData().job.name, "Ghabz Mechanic", amount)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		elseif data.current.value == 'hijack_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = SR.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)
			if IsPedSittingInAnyVehicle(playerPed) then
				SR.ShowNotification(_U('inside_vehicle'))
				return
			end
			if DoesEntityExist(vehicle) then
				IsBusy = true
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)
					SetVehicleDoorsLocked(vehicle, 1)
					--SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					SR.ShowNotification(_U('vehicle_unlocked'))
					IsBusy = false
				end)
			else
				SR.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'fix_vehicle' then
			mechanicRepairVehicle()
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = SR.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)
			if IsPedSittingInAnyVehicle(playerPed) then
				SR.ShowNotification(_U('inside_vehicle'))
				return
			end
			if DoesEntityExist(vehicle) then
				IsBusy = true
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)
					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)
					TriggerEvent('esx_Quest:point','Clean',nil,1)
					TriggerServerEvent('DiscordBot:ToDiscord', PlayerData.job.name, PlayerData.name, '```\n[Type]: Clean \n [Name]: '..GetPlayerName(PlayerId())..'\n [Pelak]: '..GetVehicleNumberPlateText(vehicle)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					SR.ShowNotification(_U('vehicle_cleaned'), "check")
					IsBusy = false
				end)
			else
				SR.ShowNotification(_U('no_vehicle_nearby'), "error")
			end
      	elseif data.current.value == 'del_vehicle' then
			local ped = PlayerPedId()
			if DoesEntityExist(ped) and not IsEntityDead(ped) then

					if Busy then return end
					local vehicle = SR.Game.GetVehicleInDirection()
					local playerPed = PlayerPedId()
					if DoesEntityExist(vehicle) then
						Busy = true
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
						TriggerEvent("mythic_progbar:client:progress", {
						name = "impound_vehicle",
						duration = 40000,
						label = "Toghif kardan mashin",
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
					}, function(status)
						if not status then
			
							ClearPedTasks(playerPed)
							SR.ShowNotification(_U('vehicle_impounded'))
							SR.Game.DeleteVehicle(vehicle)
							TriggerServerEvent("esx_spawnObject:handleObject", VehToNet(vehicle))
							Busy = false
							TriggerEvent('esx_Quest:point','IMPMecano',nil,1)
						elseif status then
							ClearPedTasks(playerPed)
							Busy = false
							TriggerEvent('esx_customItems:checkVehicleStatus', false)
						end
					end)
					else
						SR.ShowNotification(_U('must_near'))
					end
			end
		elseif data.current.value == "tow" then
			ExecuteCommand("towvehicle")
		elseif data.current.value == "requests" then
			openMechanicRequest()
			menu.close()
		elseif data.current.value == "queue" then
			ExecuteCommand("mduty")
			menu.close()
		else
			TriggerEvent("aduty:flip")
      	end
  	end, function(data, menu)
   	 	menu.close()
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

			SR.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
			{
				title    = _U('mechanic_stock'),
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)

				local itemName = data.current.value

				SR.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
				{
					title = _U('quantity')
				},
				function(data2, menu2)
					local count = tonumber(data2.value)
					if count == nil then
						SR.ShowNotification(_U('invalid_quantity'))
					else
						menu2.close()
						menu.close()
						if string.find(itemName, "casino") ~= nil then return end
						TriggerServerEvent('sr_mechanicjob:getStockItem', itemName, count)
						Citizen.Wait(1000)
						OpenGetStocksMenu()
					end
				end,function(data2, menu2)
					menu2.close()
				end)
			end,function(data, menu)
				menu.close()
			end)
		end)
  	end)
end

function OpenPutStocksMenu()
	SR.TriggerServerCallback('sr_mechanicjob:getPlayerInventory', function(inventory)
		local elements = {}
		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
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
					SR.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					if string.find(itemName, "casino") ~= nil then return end
					TriggerServerEvent('sr_mechanicjob:putStockItems', itemName, count)
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

RegisterNetEvent('sr_mechanicjob:onHijack')
AddEventHandler('sr_mechanicjob:onHijack', function()
  	local playerPed = PlayerPedId()
  	local coords    = GetEntityCoords(playerPed)
  	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    	local vehicle = nil
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end
		local crochete = math.random(100)
		local alarm    = math.random(100)
		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if crochete <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					--SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					SR.ShowNotification(_U('veh_unlocked'))
				else
					SR.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
    	end
  	end
end)

RegisterNetEvent('sr_mechanicjob:onCarokit')
AddEventHandler('sr_mechanicjob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end
		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				ESX.SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				SR.ShowNotification(_U('body_repaired'))
			end)
		end
  	end
end)

RegisterNetEvent('sr_mechanicjob:onFixkit')
AddEventHandler('sr_mechanicjob:onFixkit', function()
  	local playerPed = PlayerPedId()
  	local coords    = GetEntityCoords(playerPed)
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
	  	local vehicle = nil
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end
		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				ESX.SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				SR.ShowNotification(_U('veh_repaired'))
			end)
		end
  	end
end)

RegisterNetEvent('sr_mechanicjob:FixCar')
AddEventHandler('sr_mechanicjob:FixCar', function(net)
	local vehicle = NetToVeh(net)
	if vehicle ~= 0 then
		if ESX then
			ESX.SetVehicleFixed(vehicle)
		end
		SetVehicleDeformationFixed(vehicle)
		SetVehicleUndriveable(vehicle, false)
		SetVehicleEngineOn(vehicle, true, true)
	end
end)

function ActionControl()
	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if CurrentAction == 'mecano_duty_job' then
			TriggerServerEvent('duty', PlayerData.job.name)
			if PlayerData.job.grade > 0 then
				SR.ShowNotification(_U('off_duty'))
				Citizen.Wait(1000)
			else
				SR.ShowNotification(_U('on_duty'))
				Citizen.Wait(1000)
			end
		elseif CurrentAction == 'mecano_boss_actions_menu' then
			OpenMecanoBossActionsMenu()
		elseif CurrentAction == 'mecano_actions_menu' then
			OpenMecanoActionsMenu()
		elseif CurrentAction == 'mecano_clothe_menu' then
			OpenClotheMenu()
		elseif CurrentAction == 'mecano_harvest_menu' then
			OpenMecanoHarvestMenu()
		elseif CurrentAction == 'mecano_craft_menu' then
			OpenMecanoCraftMenu()
		elseif CurrentAction == 'mecano_garage_menu' then
			OpenVehicleSpawnerMenu(CurrentActionData.pos, CurrentActionData.index)
		elseif CurrentAction == 'mecano_heli_menu' then
			if (PlayerData.job.name == 'benny' or PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'rioters') and ESX.GetPlayerData().job.ext == 'heli' then
				local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(CurrentActionData.pos, CurrentActionData.index, 'heli')
				local veh = '{"pearlescentColor":0,"modSmokeEnabled":false,"modXenon":false,"modSpoilers":-1,"neonColor":[255,0,255],"modRoof":-1,"modDoorSpeaker":-1,"modOrnaments":-1,"windowTint":-1,"modRearBumper":-1,"modShifterLeavers":-1,"modTransmission":-1,"modWindows":-1,"modFender":-1,"modSteeringWheel":-1,"modTrimA":-1,"modTrimB":-1,"modBackWheels":-1,"modFrontWheels":-1,"modFrame":-1,"modDial":-1,"wheels":0,"model":745926877,"modTrunk":-1,"dirtLevel":3.0,"modAirFilter":-1,"modPlateHolder":-1,"modFrontBumper":-1,"modHorns":-1,"modStruts":-1,"color1":41,"plateIndex":4,"health":1000,"color2":41,"modLivery":-1,"modExhaust":-1,"modEngine":-1,"modGrille":-1,"tyreSmokeColor":[255,255,255],"modHood":-1,"modArmor":-1,"neonEnabled":[false,false,false,false],"modSpeakers":-1,"modTurbo":false,"modRightFender":-1,"modSuspension":-1,"wheelColor":156,"modEngineBlock":-1,"modBrakes":-1,"modSeats":-1,"modTank":-1,"modAPlate":-1,"modAerials":-1,"modDashboard":-1,"modHydrolic":-1,"modArchCover":-1,"modSideSkirt":-1,"modVanityPlate":-1}'
				SpawnVehicle(json.decode(veh), nil, spawnPoint.coords, spawnPoint.heading)
			else
				ESX.Alert("Shoma Division Heli Nistid", "error")
			end
		elseif CurrentAction == 'delete_vehicle' then
			local plate = SR.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle))
			TriggerServerEvent('esx_mechanicjob:saveVehicle', plate, nil)
			SR.Game.DeleteVehicle(CurrentActionData.vehicle)
		end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	--MecanoKey = RegisterKey('E', false, ActionControl)
	TriggerMecanoCitizen()
	if xPlayer.job.name == 'benny' or xPlayer.job.name == 'mechanic' then
		LockerThread()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if PlayerData.job.name ~= 'benny' or PlayerData.job.name ~= 'mechanic' then
		if job.name == 'benny' or job.name == 'mechanic' then
			LockerThread()
		end
	elseif job.name ~= 'benny' or job.name ~= 'mechanic' then
		exports.sr_main:RemoveByTag('bennyJob-locker')
	end
	PlayerData.job = job
	TriggerMecanoCitizen()
	--[[if PlayerData.job.name == "mechanic" and PlayerData.job.grade >= 5 then
		BuyThread()
	end]]
end)

AddEventHandler('sr_mechanicjob:hasEnteredMarker', function(zone, pos, index)
	if zone == 'DutyJob' then
		CurrentAction     = 'mecano_duty_job'
		CurrentActionMsg  = _U('toggle_job')
		CurrentActionData = {}
	elseif zone == 'MecanoBossAction' then
		CurrentAction     = 'mecano_boss_actions_menu'
		CurrentActionMsg  = _U('open_boss_actions')
		CurrentActionData = {}
	elseif zone == 'MecanoActions' then
		CurrentAction     = 'mecano_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'ClotheMenu'  then
		CurrentAction     = 'mecano_clothe_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction     = 'mecano_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction     = 'mecano_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleGarage' then
		CurrentAction     = 'mecano_garage_menu'
		CurrentActionMsg  = _U('open_garage')
		CurrentActionData = {pos = pos, index = index}
	elseif zone == 'HeliGarage' then
		CurrentAction     = 'mecano_heli_menu'
		CurrentActionMsg  = '~INPUT_CONTEXT~ Spawn Mechanic Buzzard'
		CurrentActionData = {pos = pos, index = index}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
	Hint:Create(CurrentActionMsg)
end)

AddEventHandler('sr_mechanicjob:hasExitedMarker', function(zone)
	if zone == 'Craft' then
		TriggerServerEvent('sr_mechanicjob:stopCraft')
		TriggerServerEvent('sr_mechanicjob:stopCraft2')
		TriggerServerEvent('sr_mechanicjob:stopCraft3')
	end
	if zone == 'Garage' then
		TriggerServerEvent('sr_mechanicjob:stopHarvest')
		TriggerServerEvent('sr_mechanicjob:stopHarvest2')
		TriggerServerEvent('sr_mechanicjob:stopHarvest3')
	end
	CurrentAction = nil
	SR.UI.Menu.CloseAll()
	Hint:Delete()
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v.Blip.coords)
		SetBlipSprite(blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('mechanic'))
		EndTextCommandSetBlipName(blip)
	end
end)

function LockerThread()
	for k, v in pairs(Config.Zones) do
		local v2 = v.ClotheMenu
		for _,point in pairs(v2.Pos) do
			local Interact
			local Point = RegisterPoint(point, Config.DrawDistance, true)
			Point.set('Tag', 'MecanoJob-locker')
			Point.set('InArea', function ()
				DrawMarker(v2.Type, point, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, true, 2, false, false, false, false)
			end)
			Point.set('InAreaOnce', function ()
				Interact = RegisterPoint(point, v2.Size.x, true)
				Interact.set('Tag', 'MecanoJob-locker')
				Interact.set('InAreaOnce', function ()
					TriggerEvent('sr_mechanicjob:hasEnteredMarker', 'ClotheMenu', k)
				end, function ()
					TriggerEvent('sr_mechanicjob:hasExitedMarker', 'ClotheMenu')
				end)
			end, function ()
				if Interact then
					Interact.remove()
				end
			end)
		end
	end
end

function TriggerMecanoCitizen()
	ThreadsCondition = false

	exports.sr_main:RemoveByTag('MecanoJob')

	UnregisterKey(MecanoKey)

	UnregisterKey(MenuKey)
	
	Wait(100)

	if PlayerData.job.name ~= 'benny' and PlayerData.job.name ~= 'mechanic' then
		return
	end

	ThreadsCondition = true

	MecanoKey = RegisterKey('E', false, ActionControl)

	if not (PlayerData.job.grade > 0) then
		return
	end

	MenuKey = RegisterKey('F6', function()
		if PlayerData.job.grade > 0 and not IsDead then
			OpenMobileMecanoActionsMenu()
		end
	end)
	
	for k,v in pairs(Config.Zones) do
		for k2, v2 in pairs(v) do
			if k2 ~= 'Blip' and k2 ~= 'ClotheMenu' then
				for i, point in pairs(v2.Pos) do
					local Interact
					local Point = RegisterPoint(point, Config.DrawDistance, true)
					Point.set('Tag', 'MecanoJob')
					Point.set('InArea', function ()
						DrawMarker(v2.Type, point, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, true, 2, false, false, false, false)
					end)
					Point.set('InAreaOnce', function ()
						Interact = RegisterPoint(point, v2.Size.x, true)
						Interact.set('Tag', 'MecanoJob')
						Interact.set('InAreaOnce', function ()
							TriggerEvent('sr_mechanicjob:hasEnteredMarker', k2, k, i)
						end, function ()
							TriggerEvent('sr_mechanicjob:hasExitedMarker', k2)
						end)
					end, function ()
						if Interact then
							Interact.remove()
						end
					end)
				end
			end
		end
	end

	Citizen.CreateThread(function()
		while ThreadsCondition do
			Citizen.Wait(1)
			local PlayerPed = PlayerPedId()
			if IsPedInAnyVehicle(PlayerPed, false) then
				local vehicle = GetVehiclePedIsIn(PlayerPed, false)
				if IsVehicleModel(vehicle, GetHashKey("towtruck")) or IsVehicleModel(vehicle, GetHashKey("towtruck2")) then
					local entity = GetEntityAttachedToTowTruck(vehicle)
					if entity then
						if IsControlJustPressed(0, 19) then
							DetachVehicleFromTowTruck(vehicle, entity)
						else
							AttachVehicleToTowTruck(vehicle, entity, true, 0, 0, 0)
						end
					end
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)
end

RegisterNetEvent('aduty:flip')
AddEventHandler('aduty:flip', function(target)
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        SetVehicleOnGroundProperly(vehicle)
    else
        local vehicle = SR.Game.GetVehicleInDirection(4)
        if vehicle ~= 0 then
			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
			NetworkRequestControlOfEntity(vehicle)
			while not NetworkHasControlOfEntity(vehicle) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(vehicle)
			end
			Citizen.Wait(1500)
			SetVehicleOnGroundProperly(vehicle)
			Citizen.Wait(3500)
			TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
		end
    end
end)

RegisterNetEvent('esx_mechanicjob:KitEngine')
AddEventHandler('esx_mechanicjob:KitEngine', function()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
		ESX.Alert("Shoma Nemitavanid Dar Mashin Az Kit Tamir Estefade Konid", "info")
    else
        local vehicle = SR.Game.GetVehicleInDirection(4)
        if vehicle ~= 0 then
			if not IsPedInAnyVehicle(PlayerPedId()) then
				if #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3.0 then 
					if GetVehicleEngineHealth(vehicle) < 500.0 then
						NetworkRequestControlOfEntity(vehicle)
						while not NetworkHasControlOfEntity(vehicle) do
							Citizen.Wait(100)
							NetworkRequestControlOfEntity(vehicle)
						end
						TaskTurnPedToFaceEntity(ped, vehicle, 1.0)
						SetVehicleDoorOpen(vehicle, 4, false, false)
						ExecuteCommand("e mechanic")
						exports.essentialmode:DisableControl(true)
						TriggerEvent("dpemote:enable", false)
						SR.UI.Menu.CloseAll()
						TriggerServerEvent("esx_mechanicjob:RemoveFixKit")
						exports["esx_basicneeds"]:startUI(10000, "Reapiring Engine")
						Citizen.Wait(10000)
						SetVehicleDoorShut(vehicle, 4, false)
						ClearPedTasks(PlayerPedId())
						exports.essentialmode:DisableControl(false)
						TriggerEvent("dpemote:enable", true)
						SetVehicleEngineHealth(vehicle, 500.0)
						--exports["LegacyFuel"]:SetFuel(vehicle, exports["LegacyFuel"]:GetFuel(vehicle)+ 10)
					else
						TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0in mashin salem ast!"}})
					end
				else
					TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0shoma az mashin door hastid!"}})
				end
			end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
        end
    end
end)

RegisterNetEvent('esx_mechanicjob:UseWheel')
AddEventHandler('esx_mechanicjob:UseWheel', function()
	if ESX.GetPlayerData().isSentenced or ESX.GetPlayerData().isDead then return end
	local ad = "anim@heists@box_carry@"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	propModel = 'prop_wheel_tyre'
	propSpawned = CreateObject(GetHashKey(propModel), x, y, z + 0.2, true, true, true)
	AttachEntityToEntity(propSpawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.10, 0.26, 0.32, 90.0, 110.0, 0.0, true, true, false, true, 1, true)
	exports.essentialmode:DisableControl(true)
	TriggerEvent("dpemote:enable", false)
	StartThread()
end)

function StartThread()
	while propSpawned and DoesEntityExist(propSpawned) do
		Citizen.Wait(1)
		SR.UI.Menu.CloseAll()
		if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
			Draw3DText(x, y, z, "~r~[G] ~w~Cancel")
			local vehicle = SR.Game.GetClosestVehicle()
			if vehicle ~= nil then
				local tire = GetClosestVehicleTire(vehicle)
				if tire ~= nil then
					Draw3DText(tire.bonePos.x, tire.bonePos.y, tire.bonePos.z, "~g~[E] ~w~Taaviz Lastik")
					if IsControlJustPressed(1, 38) then
						NetworkRequestControlOfEntity(vehicle)
						while not NetworkHasControlOfEntity(vehicle) do
							Citizen.Wait(1)
							NetworkRequestControlOfEntity(vehicle)
						end
						ClearPedSecondaryTask(PlayerPedId())
						local has, x, y = Get_2dCoordFrom_3dCoord(tire.bonePos.x, tire.bonePos.y, tire.bonePos.z)
						if has then
							SetEntityHeading(PlayerPedId(), GetHeadingFromVector_2d(x, y))
						end
						TriggerEvent("dpemote:enable", true)
						Citizen.Wait(150)
						ExecuteCommand("e mechanic3")
						TriggerEvent("dpemote:enable", false)
						FreezeEntityPosition(PlayerPedId(), true)
						exports["esx_basicneeds"]:startUI(10000, "Dar Hale Taaviz Lastik")
						Citizen.Wait(10000)
						if propSpawned and DoesEntityExist(propSpawned) then
							SetVehicleTyreFixed(vehicle, tire.tireIndex, 0, 1)
							TriggerServerEvent('esx_mechanicjob:RepairWheel', VehToNet(vehicle), tire.tireIndex)
							deleteProp()
						else
							deleteProp()
							break
						end
					end
				end
			end
			if IsControlJustPressed(1, 47) then
				deleteProp()
			end
		else
			deleteProp()
			break
		end
	end
	ClearPedSecondaryTask(PlayerPedId())
	ClearPedTasks(PlayerPedId())
end

RegisterNetEvent("esx:RepairWheel")
AddEventHandler("esx:RepairWheel", function(vehicle, tireIndex)
	local veh = NetworkGetEntityFromNetworkId(vehicle)
	if DoesEntityExist(veh) then
		NetworkRequestControlOfEntity(veh)
		while not NetworkHasControlOfEntity(veh) do
			Citizen.Wait(1)
			NetworkRequestControlOfEntity(veh)
		end
		SetVehicleTyreFixed(veh, tireIndex, 0, 1)
	end
end)

function deleteProp()
	DetachEntity(propSpawned, 1, 1)
	DeleteObject(propSpawned)
	ClearPedSecondaryTask(PlayerPedId())
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	propSpawned = nil
	exports.essentialmode:DisableControl(false)
	TriggerEvent("dpemote:enable", true)
end

RegisterNetEvent('esx:removeInventoryItem',function(label)
    if label.name == "highrim" and label.count <= 0 then
		if propSpawned and DoesEntityExist(propSpawned) then
			deleteProp()
		end
    end
end)

function GetClosestVehicleTire(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local minDistance = 1.0
	local closestTire = nil
	
	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, bonePos.x, bonePos.y, bonePos.z)

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end

	return closestTire
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.75*scale)
        SetTextFont(4)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Kit Taamir (25,000$)", value = "fixkit"},
        {label = "Lastik (26,000$)", value = "highrim"},
		{label = "Engine (50,000$)", value = "engine"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_mechanic', {
		title    = 'Mechanic Buy',
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
        TriggerServerEvent("esx_mechanicjob:AddItem", data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function BuyThread()
	exports.sr_main:RemoveByTag("mechanicbot")
	Citizen.Wait(500)
	local coords = {
		vector4(-556.86,-1803.26,22.43,328.68),
		vector4(1340.98,-729.35,70.0,332.59)
	}
	for k, v in pairs(coords) do
		ped_hash = GetHashKey("s_m_m_gaffer_01")
        RequestModel(ped_hash)
        while not HasModelLoaded(ped_hash) do
            Citizen.Wait(1)
        end
        BossNPC = CreatePed(1, ped_hash,v.x, v.y, v.z-0.9, v.w, false, true)
        SetBlockingOfNonTemporaryEvents(BossNPC, true)
        SetPedDiesWhenInjured(BossNPC, false)
        SetPedCanPlayAmbientAnims(BossNPC, true)
        SetPedCanRagdollFromPlayerImpact(BossNPC, false)
        SetEntityInvincible(BossNPC, true)
        FreezeEntityPosition(BossNPC, true)
		local Point = RegisterPoint(vector3(v.x, v.y, v.z), 5, true)
		Point.set("Tag", "mechanicbot")
		Point.set("InArea", function()
			--DrawMarker(0, vector3(v.x, v.y, v.z+1.6), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
			if #(GetEntityCoords(PlayerPedId()) - vector3(v.x, v.y, v.z)) < 1.2 then
				ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Tajhizat')
				if IsControlJustReleased(0, 38) then
					OpenBuyMenu()
				end
			end
		end)
		Point.set("OutAreaOnce", function()
			ESX.UI.Menu.CloseAll()
		end)
	end
end

Citizen.CreateThread(BuyThread)

local carblip                 = 0
local drawInD                 = false

local function openRequst(id)
    ESX.TriggerServerCallback('mechanic:getlist', function(data)
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
                TriggerServerEvent('mechanic:accept',id)
				ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
                openRequst(id)
            elseif data2.current.value == "decline" then
                TriggerServerEvent('mechanic:decline',id)
				ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
                openRequst(id)
            elseif data2.current.value == "finish" then
                TriggerServerEvent('mechanic:finish',id)
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

function openMechanicRequest()
	ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('mechanic:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            local elements = {}
            for k , v in pairs(ems) do
                if v.show and v.job == PlayerData.job.name then
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

RegisterNetEvent('mechanic:openAdmin',function()
    ESX.TriggerServerCallback('mechanic:getlist', function(data)
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

RegisterNetEvent('mechanic:addmecblip',function(id,coords,name)
    local id = id
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
    Wait(2000)
    carblip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(carblip, 402)
    SetBlipFlashes(carblip, true)
    SetBlipColour(carblip,46)
    SetBlipFlashTimer(carblip, 5000)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Mechanic officer')
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
        ESX.ShowAdvancedNotification(name, '~g~Dar rah ast~s~', '/mechanic to open request menu', 'CHAR_CARSITE2', 7)
    end
end)

RegisterNetEvent('mechanic:deleteblip',function()
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
end)

RegisterCommand('mechanic',function()
    ESX.TriggerServerCallback('mechanic:getmerequest',function(id,v)
        if id == nil then
            ESX.ShowNotification('Shoma hich darkhast mechanic ersal nakardid')
        else
            elements = {}
            emoji = "❌"
            if v.accept then
                emoji = "✔️"
            end
            table.insert(elements,{label = "Request id : ".. id .. " | Accept : ".. emoji,value = id})
            if v.accept then
                table.insert(elements,{label = "Accepted by : ".. v.acceptername,value = "no"})
                table.insert(elements,{label = "Phone Number: "..v.accepternumber,value = "call"})
            else
                table.insert(elements,{label = "Cancel request",value = "cancel"})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', 
			{
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data, menu)
                if data.current.value == "call" then
                    --TriggerEvent('gcphone:autoCall',v.accepternumber)
                    --exports['sunset_phone']:Call({number = v.accepternumber,name = v.accepternumber})
                elseif data.current.value == "cancel" then
                    ESX.TriggerServerCallback('mechanic:remove',function(data)
                        menu.close()
                    end)
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end)
end, false)

RegisterNetEvent('mechanic:acceptq',function(id)
	ESX.UI.Menu.CloseAll()
    local elements = {
        {label = 'Bale', value = true},
        {label = 'Kheyr', value = false},
    }
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'a' .. id,
    {
		title 	 = 'Darkhast jadid!',
		align    = 'center',
		question = 'Aya mayel be ghabul kardan darkhast hastid?',
		elements = elements
    }, function(data, menu)
        menu.close()
		if data.current.value then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
			TriggerServerEvent('mechanic:accept',id,mugshotStr)
			ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
		else
			ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
			TriggerServerEvent("mechanic:reject", id)
		end
    end)

    Citizen.SetTimeout(10000,function()
        if ESX.UI.Menu.IsOpen('question',GetCurrentResourceName(),'a' .. id) then
            ESX.UI.Menu.Close('question',GetCurrentResourceName(), 'a' .. id)
            ExecuteCommand('f Darkhast ' .. id .. ' be dalil AFK reject shod!')
			TriggerServerEvent("mechanic:reject", id)
        end
    end)
end)

RegisterNetEvent('mechanic:acceptKarde',function()
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
                ESX.TriggerServerCallback('mechanic:getlist', function(data)
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

Shared = {}
Shared.mechanic = {}
Shared.mechanic.config = {
    mechanicBot = {
        mechanicNeed = 0,
		timer = 90 * 1000,
		models = {
			`s_m_y_xmech_02`,
		},
        cars = {
            `flatbed`,
            `towtruck`,
        },
		spawnRadius = 150,
        cost = 15000,
    }
}

local botThread, botPed, botBlip, botVehicle = false, nil, 0, 0
local function stopBot()
    ESX.Game.DeleteEntity(botPed)
    ESX.Game.DeleteEntity(botVehicle)
    botPed, botThread = nil, nil
end

RegisterNetEvent('mechanic:createBotThread', function()
	exports.yseries:ToggleOpen(false)
	ESX.UI.Menu.CloseAll()
	Citizen.Wait(250)
    ESX.selectVehicleMenu(function(vehicle)
        if not vehicle then
            TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
            return
        end
        if not botThread then
            botThread = true
            local spawnTime = GetGameTimer() + Shared.mechanic.config.mechanicBot.timer
            local task = nil
            CreateThread(function()
                while botThread do
                    if not DoesEntityExist(vehicle) then
                        stopBot()
                        break
                    end
                    local timeMande = spawnTime - GetGameTimer()
                    if timeMande >= 0 then
                        ESX.Game.Utils.DrawText2D(('~g~%sS ta residan mechanic'):format(ESX.Math.Round(timeMande / 1000), 1), 0.5, 0.72, 0.4)
                    end
                    if timeMande <= 0 and not botPed then
                        
                        local coords = GetEntityCoords(vehicle)
                        local model, car = Shared.mechanic.config.mechanicBot.models[math.random(1, #Shared.mechanic.config.mechanicBot.models)], Shared.mechanic.config.mechanicBot.cars[math.random(1, #Shared.mechanic.config.mechanicBot.cars)]
                        local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(coords.x + math.random(-Shared.mechanic.config.mechanicBot.spawnRadius, Shared.mechanic.config.mechanicBot.spawnRadius), coords.y + math.random(-Shared.mechanic.config.mechanicBot.spawnRadius, Shared.mechanic.config.mechanicBot.spawnRadius), coords.z, 0, 3, 0)
                        print(json.encode(spawnPos), spawnHeading)
						if found then
                            local p = promise.new()
                            ESX.Game.SpawnVehicle(car, spawnPos, spawnHeading, function(vehicle)
                                p:resolve(vehicle)
                            end)
                            botVehicle = Citizen.Await(p)
							print(botVehicle)
							--SetVehicleDoorsLockedForAllPlayers(botVehicle, true)
                            TriggerServerEvent('esx_vehiclecontrol:sync', NetworkGetNetworkIdFromEntity(botVehicle), true)
                            ESX.Streaming.RequestModel(model)
                            botPed = CreatePedInsideVehicle(botVehicle, 0, model, -1, true, true)
                            Wait(2000)
                            SetBlockingOfNonTemporaryEvents(botPed, true)
                            SetEntityInvincible(botPed, true)
                            botBlip = AddBlipForEntity(botPed)
                            SetBlipFlashes(botBlip, true)
                            SetBlipColour(botBlip, 5)
                        end
                    elseif botPed then
                        local coords = GetEntityCoords(vehicle)
                        local distance = #(coords - GetEntityCoords(botPed))
                        if distance > 10 then
                            if not task then
                                TaskVehicleDriveToCoord(botPed, botVehicle, coords.x, coords.y, coords.z, 30.0, 0, GetEntityModel(botVehicle), 524863, 5.0, 0)
                                task = true
                                SetTimeout(60000, function()
                                    local coords = GetEntityCoords(vehicle)
                                    if #(coords - GetEntityCoords(botVehicle)) > 10 then
                                        ESX.Game.DeleteEntity(botVehicle)
                                        SetEntityCoords(botPed, coords.x - 2.5, coords.y + 2.5, coords.z)
                                    end
                                end)
                            end
                        else
                            TaskLeaveVehicle(botPed, botVehicle, 0)
                            Wait(1000)
                            TaskGoToEntity(botPed, vehicle, -1, 1.0, 10, 0, 0)
                            Wait(7000)
                            ClearPedTasks(botPed)
                            Wait(1000)
                            ESX.entityFaceEntity(botPed, vehicle)
                            Wait(1000)
                            ESX.Streaming.RequestAnimDict('mini@repair')
                            TaskPlayAnim(botPed, 'mini@repair', 'fixing_a_ped', -1, -1, -1, 1, 1.0, false, false, false)
                            Wait(15000)
                            exports['esx_vehiclecontrol']:repair(vehicle)
                            TriggerServerEvent('mechanic:removeBotMoney')
                            ClearPedTasks(botPed)
                            Wait(1000)
                            if DoesEntityExist(botVehicle) then
                                TaskEnterVehicle(botPed, botVehicle, 15000, -1, 1.0, 1, 0)
                                Wait(10000)
                                TaskVehicleDriveWander(botPed, botVehicle, 100.0, 524863)
                                Wait(15000)
                            end
                            stopBot()
                        end
                    end
                    Wait(0)
                end
            end)
        end
    end, 8)
end)

function impoundBusyThread()
	Citizen.CreateThread(function()
		while impound.busy do
		  	Citizen.Wait(10)
		  	if impound.busy and impound.vehicle ~= 0 then
				local coords = GetEntityCoords(GetPlayerPed(-1))
				if not DoesEntityExist(impound.vehicle) then
					TriggerEvent("mythic_progbar:client:cancel")
					impound.busy = false
					impound.vehicle = 0
				end
				local vcoords = GetEntityCoords(impound.vehicle)
				local distance = GetDistanceBetweenCoords(coords, vcoords, false)
				if IsAnyPedInVehicle(impound.vehicle) then
					ESX.ShowNotification("~h~Shakhsi vared mashin shod!")
					TriggerEvent("mythic_progbar:client:cancel")
					impound.busy = false
					impound.vehicle = 0
				end
				if distance > 4 then
					ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!")
					TriggerEvent("mythic_progbar:client:cancel")
					impound.busy = false
					impound.vehicle = 0
				end	  
			end
		end
	end)
end

RegisterNetEvent("esx_mechanicjob:usingEngine")
AddEventHandler("esx_mechanicjob:usingEngine", function()
	if ESX.GetPlayerData().isSentenced or ESX.GetPlayerData().isDead then return end
	RepairEngine()
end)

function RepairEngine()
	ESX.UI.Menu.CloseAll()
	if impound.busy then return end
	ESX.selectVehicleMenu(function(vehicle)
		if not vehicle then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
			return
		end
		ESX.TriggerServerCallback('esx_advancedgarage:DoesHaveKey',function(a, b, chopped)
			if not chopped then
				ESX.Alert("In Mashin Niaz Be Engine Nadarad", "info")
			else					
				local item = 'engine'
				local enginecount = 0
				local PlayerData = ESX.GetPlayerData()
				for i=1, #PlayerData.inventory do
					if PlayerData.inventory[i].name == item then
						enginecount = PlayerData.inventory[i].count
					end
				end
				if enginecount < 1 then
					ESX.ShowNotification('Shoma niaz be yek Engine darid')
				else
					local time = 30000
					time = time + 1 * 5000
					impound.busy = true
					impound.vehicle = vehicle
					impoundBusyThread()
					ExecuteCommand("e mechanic")
					TriggerServerEvent("esx_advancedgarage:removeEngine")
					TriggerEvent("mythic_progbar:client:progress", {
						name = "mechanic_repair",
						duration = time,
						label = "Dar hale tamir kardan engine mashin",
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}
					}, function(status)
						if not status then
							ClearPedTasksImmediately(GetPlayerPed(-1))
							TriggerServerEvent('esx_advancedgarage:chopFix',GetVehicleNumberPlateText(vehicle))
							impound.busy = false
							impound.vehicle = 0
						elseif status then
							ClearPedTasksImmediately(GetPlayerPed(-1))
							impound.busy = false
							impound.vehicle = 0
						end				
					end)
				end
			end
		end, GetVehicleNumberPlateText(vehicle))	
	end)
end

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

function mechanicRepairVehicle()
	ESX.UI.Menu.CloseAll()
	ESX.selectVehicleMenu(function(vehicle)
		if not vehicle then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
			return
		end
		FixMechanicFunc(vehicle)
	end, 8)
end

function FixMechanicFunc(vehicle)
	local vehicle = vehicle
	if not impound.busy then
		impound.busy = true
		impound.vehicle = vehicle
		impoundBusyThread()
		ExecuteCommand("e mechanic")
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		ESX.SetPlayerData("isSentenced", true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_repair",
			duration = 10000,
			label = "Dar hale tamir kardan mashin",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}
		}, function(status)
			if not status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				TriggerServerEvent('sr_mechanicjob:FixCar', VehToNet(vehicle))
				impound.busy = false
				impound.vehicle = 0
			elseif status then
				ClearPedTasksImmediately(GetPlayerPed(-1))
				impound.busy = false
				impound.vehicle = 0
			end
			exports.essentialmode:DisableControl(false)
			TriggerEvent("dpemote:enable", true)
			TriggerEvent("dpclothingAbuse", false)
			ESX.SetPlayerData("isSentenced", false)
		end)
	end
end