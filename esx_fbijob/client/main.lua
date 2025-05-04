---@diagnostic disable: undefined-field, undefined-global
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
  
local PlayerData              = {}
local CurrentActionData       = {}
local HandcuffTimer           = {}
local DragStatus              = {}
local CurrentTask             = {}
local DefaultKeys 			  = {}
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local IsHandcuffed            = false
local PedPosition			  = nil
DragStatus.IsDragged          = false
local hasAlreadyJoined        = false
local isDead                  = false
local playerInService         = false
local HasAlreadyEnteredMarker = false
local Busy 					  = false
local showit 				  = false
local notified 				  = false
local Draging 				  = false
local ROpen 				  = false
local LOpen 				  = false
local FrontHandCuffed 		  = false
local fbiKeys

ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(10)
	end
	while ESX.GetPlayerData().job == nil do
		Wait(50)
	end
	PlayerData = ESX.GetPlayerData()
	ESX.SetPlayerData("isSentenced", false)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerData = ESX.PlayerData
	if PlayerData.job.name == 'fbi' then
		TriggerfbiCitizen()
		LockerThread()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if PlayerData.job.name ~= 'fbi' then
		if job.name == 'fbi' then
			LockerThread()
			TriggerfbiCitizen()
		end
	end
	if job.name == 'fbi' then
		LockerThread()
		TriggerfbiCitizen()
	end
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGnag', function(gangs)
	ESX.PlayerData.gang = gangs
end)

function ActionControl()
	if CurrentAction ~= nil then
		if CurrentAction == 'menu_cloakroom' then
			OpenCloakroomMenu()
		elseif CurrentAction == 'menu_armory' then
			OpenArmoryMenu(CurrentActionData.station)
		elseif CurrentAction == 'menu_vehicle_spawner' then
			OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		elseif CurrentAction == 'menu_heli_spawner' then
			OpenHeliSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		elseif CurrentAction == 'menu_heli_deleter' then
			vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if vehicle ~= 0 then
				ESX.Game.DeleteVehicle(vehicle)
			end
		elseif CurrentAction == 'delete_vehicle' then
			local plate = string.lower(ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId()))))
			TriggerServerEvent('esx_policejob:DeletePlate', plate)
			ESX.Game.DeleteVehicle(GetVehiclePedIsUsing(PlayerPedId()))
		elseif CurrentAction == 'DoorLock' then
			TriggerServerEvent("esx_fbijob:ChangeDoorsStats")
		elseif CurrentAction == 'menu_boss_actions' then
			ESX.UI.Menu.CloseAll()
			TriggerEvent('esx_society:openBossMenu', 'fbi', function(data, menu)
				menu.close()
				CurrentAction     = 'menu_boss_actions'
				CurrentActionMsg  = _U('open_bossmenu')
				CurrentActionData = {}
			end, { wash = false, withdraw = true })
		end
		CurrentAction = nil
	else
		if CurrentTask.Busy then
			ESX.Alert(_U('impound_canceled'))
			ClearPedTasks(PlayerPedId())
			CurrentTask.Busy = false
		end
	end
end

local Timer = 0

AddEventHandler("onKeyUP", function(key)
	if key == "f6" then
		if PlayerData.job.name == "fbi" and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'fbi_actions') and not ESX.GetPlayerData().isSentenced then
			OpenfbiActionsMenu()
		end
	elseif key == "pagedown" then
		if PlayerData.job.name == "fbi" then
			if GetGameTimer() - Timer > 10000 then
				SendBackup()
				Timer = GetGameTimer()
			else
				ESX.Alert("Spam Nakonid", "error")
			end
		end
	end
end)

AddEventHandler("onMultiplePress", function(keys)
	if keys["lshift"] and keys["y"] then
		if not isDead and PlayerData.job.name == "fbi" then
			if GetGameTimer() - Timer > 10000 then
				SendfbiDistressSignal()
				Timer = GetGameTimer()
			else
				ESX.Alert("Spam Nakonid", "error")
			end
		end
	end
end)

function cleanPlayer(playerPed)
	ESX.SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
			if Config.Uniforms[job].male ~= nil then
				ESX.SetPedArmour(PlayerPedId(), 100.0)
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.Alert(_U('no_outfit'))
			end
		elseif tonumber(skin.sex) == 1 then
			if Config.Uniforms[job].female ~= nil then
				ESX.SetPedArmour(PlayerPedId(), 100.0)
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.Alert(_U('no_outfit'))
			end
		end
	end)
end

function OpenCloakroomMenu()

	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'),  value = 'west_wear' },
		{ label = "Lebas FBI",  value = 'fbi_wear'	},
		{ label = "Custom Clothe",  value = 'custom_wear'	},
	}

	if ESX.GetPlayerData().job.ext == 'hr' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas HR", value = 'hr_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'fa' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas FA", value = 'fa_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'asd' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas ASD", value = 'asd_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'cid' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas CID", value = 'cid_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'cd' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas CD", value = 'cd_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'io' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas IO", value = 'io_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'vsd' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas VSD", value = 'vsd_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'cirg' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas CIRG", value = 'cirg_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'hrt' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas HRT", value = 'hrt_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'bau' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas BAU", value = 'bau_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'ncavc' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas NCAVC", value = 'ncavc_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'toc' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas TOC", value = 'toc_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'cnu' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas CNU", value = 'cnu_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'heli' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas Heli", value = 'heli_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'dispatch' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas Dispatch", value = 'dispatch_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'xray' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas X-Ray", value = 'xray_wear'})
	end

	if ESX.GetPlayerData().job.ext == 'swat' or PlayerData.job.grade >= 5 then
		table.insert(elements, {label = "Lebas SWAT", value = 'swat_wear'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.SetPedArmour(PlayerPedId(), 0.0)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'fbi_wear' then
			ESX.SetPedArmour(PlayerPedId(), 0.0)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'west_wear' then
			TriggerEvent("skinchanger:PutOnVest", 98.0)
		elseif data.current.value == 'dispatch_wear' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleDispatchClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'custom_wear' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleCustomClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'heli_wear' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleHeliClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					--ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'swat_wear' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleSWATClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		elseif data.current.value == 'xray_wear' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:HandleXrayClothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		else
			local code = string.upper(string.gsub(data.current.value, "_wear", ""))
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback("esx_society:Handle"..code.."Clothe", function(clothe)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothe))
					ESX.SetPedArmour(PlayerPedId(), 100.0)
				end, PlayerData.job.name, PlayerData.job.grade, tonumber(skin["sex"]))
			end)
		end
		TriggerServerEvent('duty', PlayerData.job.name, true)
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)

	local elements = {
		{label = _U('get_weapon'),     value = 'get_weapon'},
		{label = _U('put_weapon'),     value = 'put_weapon'},
		{label = _U('remove_object'),  value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'},
		--{label = "Personal Stash", value = 'stash'},
	}

	if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'armory',
	{
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements,
	},
	function(data, menu)

		if data.current.value == "stash" then
            ESX.UI.Menu.CloseAll()
            TriggerEvent("esx_inventoryhud:OpenStash", PlayerData.job.name)
            return 
        end

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		end

		if data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		end

		if data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu(station)
		end

		if data.current.value == 'buy_items' then
			OpenBuyStockMenu(station)
		end

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		end

		if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

	end,
	function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end
	)
end

function SpawnVehicle(vehicle, plate, coords, heading)
	local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
	if not DoesEntityExist(shokol) then
		TriggerServerEvent('esx_fbijob:saveVehicle', plate, true)
		ESX.Game.SpawnVehicle(vehicle.model, {
			x = coords.x,
			y = coords.y,
			z = coords.z + 1
		}, heading, function(callback_vehicle)
			SetVehicleMaxMods(callback_vehicle)
			SetVehicleNumberPlateText(callback_vehicle, plate)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			ESX.CreateVehicleKey(callback_vehicle)
			TriggerServerEvent('savedVehicles', 'fbi', VehToNet(callback_vehicle))
			Wait(2000)
			exports["LegacyFuel"]:SetFuel(callback_vehicle, 100.0)
			if vehicle == "vxr" or vehicle == "gcmm52021" then
				SetVehicleExtraColours(vehicle, 0, 0, 0)
				SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
				SetVehicleColours(vehicle, 0, 0)
				SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
			end
		end)
	else
	  ESX.Alert('Mahale Spawn mashin ro Khali konid')
	end
end

function OpenVehicleSpawnerMenu(station, partNum)
	local vehicles = Config.fbiStations[station].Vehicles
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback("esx_society:GetVehiclesByPermission", function(Cars, AccessAll) 
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
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), vehicles[partNum].SpawnPoint, vehicles[partNum].Heading)
									end
								end, data3.value)
							end, data.current.model)
						end
					end, function(data3, menu3)
						menu3.close()
						CurrentAction     = 'menu_vehicle_spawner'
						CurrentActionMsg  = _U('vehicle_spawner')
						CurrentActionData = {station = station, partNum = partNum}
					end)
				end, function(data, menu)
					menu.close()
		
					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}
		
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
										SpawnVehicle(json.decode(veh), string.lower(ESX.Math.Trim(data3.value)), vehicles[partNum].SpawnPoint, vehicles[partNum].Heading)
									end
								end, data3.value)
							end, data.current.model)
						end
					end, function(data3, menu3)
						menu3.close()
						CurrentAction     = 'menu_vehicle_spawner'
						CurrentActionMsg  = _U('vehicle_spawner')
						CurrentActionData = {station = station, partNum = partNum}
					end)
				end, function(data, menu)
					menu.close()
		
					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}
				end)
			end
		end
	end)
end

--[[function OpenVehicleSpawnerMenu(station, partNum)
	local vehicles = Config.fbiStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	local elements = {}

	ESX.TriggerServerCallback('esx_society:GetSocietyCars', function(cars)
		for i=1, #cars do
			if cars[i].toggle then
				local vehicle = json.decode(cars[i].vehicle)
				local vehicleName = ESX.GetVehicleLabelFromName(vehicle.model)
				table.insert(elements, { label = vehicleName, plate = cars[i].plate})
			end
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
				if data3.value == nil then
					ESX.Alert('Lotfan Yek Pelak Vared Konid!')
				else
					menu3.close()
					print()
					ESX.TriggerServerCallback('esx:GetVehicleByPlate', function(veh)
						ESX.TriggerServerCallback('esx_fbijob:callbackVehicle', function(status)
							if status then
					ESX.Alert('In Pelak Ghablan Vared Shode Va Dar Hal Hazer Motalegh Be Yek Nafar Mibashad!', "info")
							else
								SpawnVehicle(json.decode(veh), data3.value, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading)
							end
						end, data3.value)
					end, data.current.plate)
				end
			end, function(data3, menu3)
				menu3.close()
				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
			end)
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = _U('vehicle_spawner')
			CurrentActionData = {station = station, partNum = partNum}

		end)
	end, PlayerData.job.name, PlayerData.job.grade)
end]]

function OpenHeliSpawnerMenu(station, partNum)
	local helicopters = Config.fbiStations[station].Helicopters
	ESX.UI.Menu.CloseAll()
	if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'heli_spawner',
		{
			title    = 'Helicopter Menu',
			align    = 'top-left',
			elements = {
				{label = 'Heli - 1', value = 'fblsp'},
				{label = 'Heli - 2', value = 'buzzard2'},
			}
		}, function(data, menu)
			menu.close()
			if data.current.value == 'fblsp' then
				ESX.Game.SpawnVehicle('fblsp', helicopters[partNum].SpawnPoint, helicopters[partNum].Heading, function(vehicle)
					SetVehicleModKit(vehicle, 0)
					SetVehicleLivery(vehicle, 0)
					Citizen.Wait(2000)
					TriggerServerEvent('savedVehicles', 'fbi', VehToNet(vehicle))
					exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
					ESX.CreateVehicleKey(vehicle)
				end)
			elseif data.current.value == 'buzzard2' then
				ESX.Game.SpawnVehicle('buzzard2', helicopters[partNum].SpawnPoint, helicopters[partNum].Heading, function(vehicle)
					Wait(2000)
					TriggerServerEvent('savedVehicles', 'forces', VehToNet(vehicle))
					exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
					ESX.CreateVehicleKey(vehicle)
				end)
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'menu_heli_spawner'
			CurrentActionMsg  = '~INPUT_CONTEXT~ Spawn Helicopter'
			CurrentActionData = {station = station, partNum = partNum}
		end)
	end
end

local OnSleep = false
function ChooseFromNearbyPlayers(distance, cb)
	if OnSleep then
		ESX.Alert('Dar har ~r~10 Saniye~s~ faghat 1 bar mitavanid in amaliat ra anjam bedid.')
		return
	end

	OnSleep = true
	SetTimeout(10000, function()
		OnSleep = false
	end)

	local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), distance + 0.0)
	local foundPlayers = false
	local elements = {}

	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			foundPlayers = true
			table.insert(elements, {source_id = GetPlayerServerId(players[i]), value = players[i]})
		end
	end

	if not foundPlayers then
	  	ESX.Alert('Hich fardi dar nazdiki shoma ~r~yaft~s~ nashod!')
		OnSleep = false
		return
	end

	ESX.TriggerServerCallback('Diamond:getClosestPlayersName', function(PlayersElem)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'send_bill_to_nearby_player', {
			title    = 'Lotfan fard mored nazar ro entekhab konid:',
			align    = 'top-left',
			elements = PlayersElem
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'send_bill_confirm', {
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

function OpenfbiActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fbi_actions', {
		title    = 'fbi',
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			{label = "Zendan",               value = 'jail_menu'},
			{label = "Bazdashtgah",				value = 'mini_jail_menu'},
			{label = "Tablet",				value = 'tablet'},
		}
	}, function(data, menu)

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'),			value = 'identity_card'},
				{label = _U('search'),			value = 'body_search'},
				{label = _U('handcuff'),		value = 'handcuff'},
				{label = 'HandCuff Front',      value = 'Handcuff2'},
				{label = _U('uncuff'),			value = 'uncuff'},
				{label = _U('drag'),			value = 'drag'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
				{label = _U('fine'),			value = 'fine'},
				{label = _U('unpaid_bills'),	value = 'unpaid_bills'},
				{label = _U('license_check'), 	value = 'license' },
				{label = "Carry Player", 	value = 'carry' },
			}
			if ESX.GetPlayerData().job.ext == 'fire_arms' then
				table.insert(elements, {label = 'give weapon license', value = 'give_weap_license'})
			end

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value
					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						if IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
							local text = '* Shoro be gashtane fard mikone *'
							ExecuteCommand("me "..text)
							OpenBodySearchMenu(closestPlayer)
						elseif not IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
							ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
								if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfra1mcs_2_crew_react","handsup_standing_base", 3) or Cuff or IsInjure or IsDead then -- یاد بگیر یه ذره سطحت بیاد بالا
									local text = '* Shoro be gashtane fard mikone *'
									ExecuteCommand("me "..text)
									OpenBodySearchMenu(closestPlayer)
								else
									ESX.Alert("~y~Dast Player Mored Nazar Paiin Ast")
								end
							end, GetPlayerServerId(closestPlayer))
						else
							ESX.Alert('Shoma Ejaze Search Nadarid!')
						end
					elseif action == 'handcuff' then
						playerPed = PlayerPedId()
						SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(PlayerPedId())
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(PlayerPedId())
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
								ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
									if not Cuff then 
										if not IsInjure or not IsDead then 
											TriggerServerEvent('esx_fbijob:requestarrest', target_id, playerheading, playerCoords, playerlocation, false)
										else
											ESX.Alert("~y~Shoma Nemitavanid Player Zakhmi Ra Cuff Konid")
										end
									else
										ESX.Alert("~y~Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid")
									end
								end, GetPlayerServerId(target))
							else
								ESX.Alert('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!')
							end
						else
							ESX.Alert('Shakhsi nazdik shoma nist')
						end
					elseif action == 'Handcuff2' then
						playerPed = PlayerPedId()
						SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(PlayerPedId())
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(PlayerPedId())
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
								ESX.TriggerServerCallback("HR_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
									if not Cuff then 
										if not IsInjure or not IsDead then 
											TriggerServerEvent('esx_fbijob:requestarrest', target_id, playerheading, playerCoords, playerlocation, true)
										else
											ESX.Alert("~y~Shoma Nemitavanid Player Zakhmi Ya Morde Ra Cuff Konid")
										end
									else
										ESX.Alert("~y~Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid")
									end
								end, GetPlayerServerId(target))
							else
								ESX.Alert('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!')
							end
						else
							ESX.Alert('Shakhsi nazdik shoma nist')
						end
					elseif action == 'uncuff' then
						playerPed = PlayerPedId()
						SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(PlayerPedId())
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(PlayerPedId())
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							-- if exports.sr_main:GetDecor('_IS_PED_HANDCUFFED', GetPlayerPed(target)) then
								TriggerServerEvent('esx_fbijob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
							-- else
								-- ESX.Alert('Shoma Nemitavanid Dast Kasi Ke Cuff Nist Ra Baz Konid')
							-- end	
						else
							ESX.Alert('Shakhsi nazdik shoma nist')
						end
					elseif action == 'drag' then
						TriggerServerEvent('esx_fbijob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_fbijob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_fbijob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						ChooseFromNearbyPlayers(2, function(target)
							OpenFineMenu(target)
						end)
					elseif action == 'jail' then
						JailPlayer(GetPlayerServerId(closestPlayer))
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					elseif action == 'give_weap_license' then
						ChooseFromNearbyPlayers(2, function(target)
							TriggerServerEvent('esx_fbijob:GiveWeaponLicese', target)
						end)
					elseif action == 'carry' then
						ExecuteCommand("bhnjs "..GetPlayerServerId(closestPlayer))
						menu2.close()
					end
				else
					ESX.Alert(_U('no_players_nearby'), "info")
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'jail_menu' then
			TriggerEvent("esx-qalle-jail:openJailMenu")
		elseif data.current.value == 'mini_jail_menu' then
			TriggerEvent("esx-qalle-jail:openMiniJailMenu", "fbi")
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			
			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'),		value = 'impound'})
			end
			
			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				
				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					if action == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData)
						
					elseif action == 'hijack_vehicle' then

					if CurrentTask.Busy then
						return
					end
					
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							CurrentTask.Busy = true
							TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
							TriggerEvent("mythic_progbar:client:progress", {
							name = "hijack_vehicle2",
							duration = 30000,
							label = "LockPick kardan mashin",
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
				
								ClearPedTasksImmediately(playerPed)
								SetVehicleDoorsLocked(vehicle, 1)
								--SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								ESX.Alert(_U('vehicle_unlocked'))
								CurrentTask.Busy = false
								TriggerEvent('esx_customItems:checkVehicleStatus', false)
			
							elseif status then
								ClearPedTasksImmediately(playerPed)
								CurrentTask.Busy = false
								TriggerEvent('esx_customItems:checkVehicleStatus', false)
							end
						end)
							
						end
					elseif action == 'impound' then
					
						-- is the script busy?
						if CurrentTask.Busy then
							return
						end
						
						CurrentTask.Busy = true
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
							ImpoundVehicle(vehicle)
							CurrentTask.Busy = false
							TriggerEvent('esx_customItems:checkVehicleStatus', false)
		
						elseif status then
							ClearPedTasks(playerPed)
							CurrentTask.Busy = false
							TriggerEvent('esx_customItems:checkVehicleStatus', false)
						end
					end)
						
					end
				else
					ESX.Alert(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == "tablet" then
			ExecuteCommand("cad")
			menu.close()
		elseif data.current.value == "idcard" then
			ExecuteCommand("idcard")
			menu.close()
		else
			ExecuteCommand("idcard true")
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)

	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local idLabel     = nil
	
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
	
		if Config.EnableESXIdentity then
	
			nameLabel = _U('name', data.name)
	
			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end
	
			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end
	
			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
	
		end
	
		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}
	
		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end
	
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end
	
		if data.licenses ~= nil then
	
			table.insert(elements, {label = _U('license_label'), value = nil})
	
			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end
	
		end

		local text = '* ID Card fard ro search mikone *'
		ExecuteCommand("me "..text)
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	
	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu(player)

	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
		local elements = {}
		table.insert(elements, {label = '--- Money ---', value = nil})

		table.insert(elements, {label =  ESX.Math.GroupDigits(data.money), value = nil})

		table.insert(elements, {label = '--- Pool Kasif ---', value = nil})

		table.insert(elements, {label =  ESX.Math.GroupDigits(data.black_money), value = 'Pool Kasif', itemType = "black_money", amount = data.black_money})
	
		table.insert(elements, {label = _U('guns_label'), value = nil})

		for i=1, #data.loadout, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.loadout[i].name), data.loadout[i].ammo),
				value    = data.loadout[i].name,
				itemType = 'item_weapon',
				amount   = data.loadout[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label'), value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
				label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
				value    = data.inventory[i].name,
				itemType = 'item_standard',
				amount   = data.inventory[i].count
				})
			end
		end


		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		{
			title    = _U('search'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount

			if data.current.value ~= nil then
				TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				OpenBodySearchMenu(player)
			end

		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))

end

function OpenFineMenu(player)
	-- ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
	-- 	title    = _U('fine'),
	-- 	align    = 'top-left',
	-- 	elements = {
	-- 		-- {label = _U('traffic_offense'), value = 0},
	-- 		-- {label = _U('minor_offense'),   value = 1},
	-- 		-- {label = _U('average_offense'), value = 2},
	-- 		-- {label = _U('major_offense'),   value = 3},
	-- 		{label = _U('custom_fine'),   	value = 4}
	-- 	},
	-- }, function(data, menu)
		OpenFineCategoryMenu(player)
	-- end, function(data, menu)
		-- menu.close()
	-- end)
end

function OpenFineCategoryMenu(player)
	local text = '* Ghabz minevise *'
	ExecuteCommand("me "..text)

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'custom_fine', {
		title = _U('custom_fine_title'),
	}, function(data, menu)
		local reason = tostring(data.value)
		if #reason <= 40 then
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'custom_fine_number', {
				title = _U('custom_fine_number'),
			}, function(data2, menu2)
				local amount = tonumber(data2.value)
				if amount ~= nil then
					if amount <= 100000 then
						menu2.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_fbi', "Ghabz FBI", amount)
						TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***fbi Fine***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..PlayerData.name..'\n[TO]: ('..GetPlayerServerId(player)..') '..GetPlayerName(player)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n[REASON]: '..reason..'```', 'user', GetPlayerServerId(PlayerId()), true, false)
					else
						ESX.Alert(_U('high_money'))
						menu2.close()
					end
				else
					ESX.Alert(_U('wrong_character'))
					menu2.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		else
			ESX.Alert(_U('high_character'))
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.Alert(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_fbijob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.Alert(_U('search_database_found', owner))
				else
					ESX.Alert(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end
		
		if Config.EnableESXIdentity then
			targetName = data.name
		end
		
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			ESX.Alert(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_society:LicenseRewoked', GetPlayerServerId(player))
			
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
			
			
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)

			Citizen.Wait(1000)
			TriggerServerEvent('esx_dmvschool:updateLicense', GetPlayerServerId(player))

		end,
		function(data, menu)
			menu.close()
		end
		)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)

	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)

	ESX.TriggerServerCallback('esx_fbijob:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
		{
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)

	end, vehicleData.plate)

end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_fbijob:getArmoryWeapons', function(weapons)
		ESX.TriggerServerCallback('esx_society:GetWeaponsByPermission', function(Guns, AccessAll)
			if not AccessAll then
				if Guns ~= nil then
					local elements = {}
					for i=1, #weapons, 1 do
						for j=1, #Guns, 1 do
							if weapons[i].count > 0 and string.upper(weapons[i].name) == Guns[j] then
								table.insert(elements, {
									label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), 
									value = weapons[i].name
								})
							end
						end
					end
					if #elements == 0 then
						ESX.Alert("~y~Shoma Be Hich Aslahei Dastresi Nadarid")
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
						title    = _U('get_weapon_menu'),
						align    = 'top-left',
						elements = elements
					}, function(data, menu)

						menu.close()

						ESX.TriggerServerCallback('esx_fbijob:removeArmoryWeapon', function()
							OpenGetWeaponMenu()
						end, data.current.value)

					end, function(data, menu)
						menu.close()
					end)
				else
					ESX.Alert("~y~Shoma Be Hich Aslahei Dastresi Nadarid")
				end
			else
				if Guns ~= nil then
					local elements = {}
					for i=1, #weapons, 1 do
						for k, v in pairs(Guns) do
							if weapons[i].count > 0 and string.upper(weapons[i].name) == v.name then
								table.insert(elements, {
									label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), 
									value = weapons[i].name
								})
							end
						end
					end
					if #elements == 0 then
						ESX.Alert("~y~Shoma Be Hich Aslahei Dastresi Nadarid")
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
						title    = _U('get_weapon_menu'),
						align    = 'top-left',
						elements = elements
					}, function(data, menu)

						menu.close()

						ESX.TriggerServerCallback('esx_fbijob:removeArmoryWeapon', function()
							OpenGetWeaponMenu()
						end, data.current.value)

					end, function(data, menu)
						menu.close()
					end)
				else
					ESX.Alert("~y~Shoma Be Hich Aslahei Dastresi Nadarid")
				end
			end
		end)
	end)
end

function OpenPutWeaponMenu()

	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do

		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_put_weapon',
		{
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
		},
		function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_fbijob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

		end,
		function(data, menu)
		menu.close()
		end
	)

end

function OpenBuyWeaponsMenu(station)
	ESX.TriggerServerCallback('esx_fbijob:getArmoryWeapons', function(weapons)
		local elements = {}
		for i=1, #Config.fbiStations[station].AuthorizedWeapons, 1 do
			local weapon = Config.fbiStations[station].AuthorizedWeapons[i]
			local count  = 0

			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.name then
					count = weapons[i].count
					break
				end
			end

			table.insert(elements, {
				label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. ESX.Math.GroupDigits(weapon.price),
				value = weapon.name,
				price = weapon.price
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
			title    = _U('buy_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.TriggerServerCallback('esx_fbijob:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					ESX.TriggerServerCallback('esx_fbijob:addArmoryWeapon', function()
						OpenBuyWeaponsMenu(station)
					end, data.current.value, false)
				else
					ESX.Alert(_U('not_enough_money'))
				end
			end, data.current.price)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBuyStockMenu(station)
	ESX.TriggerServerCallback('esx_fbijob:getStockItems', function(inventory)
		local elements = {}

		for i=1, #Config.fbiStations[station].AuthorizedItems, 1 do
			local item = Config.fbiStations[station].AuthorizedItems[i]
			local count  = 0
			for i2=1, #inventory, 1 do
				if inventory[i2].name == item.name then
					count = inventory[i2].count
					break
				end
			end
			table.insert(elements, {label = 'x' .. count .. ' ' .. item.label .. ' $' .. item.price, value = item.name, price = item.price})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_stock', {
			title    = _U('buy_stock_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_fbijob:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_fbijob:addStockItems', data.current.value)
					OpenBuyStockMenu(station)
				else
					ESX.Alert(_U('not_enough_money'))
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

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    ="FBI Locker",
				align    = 'top-left',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = "Tedad"
				}, function(data2, menu2)

					local count = tonumber(data2.value)

					if count == nil then
						ESX.Alert(_U('quantity_invalid'), "info")
					else
						menu2.close()
						menu.close()
						if string.find(itemName, "casino") ~= nil then return end
						TriggerServerEvent('esx_fbijob:getStockItem', itemName, count)
						Citizen.Wait(300)
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

	ESX.TriggerServerCallback('esx_fbijob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

		local item = inventory.items[i]

		if item.count > 0 then
			table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
				title = _U('quantity')
			},
			function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
				ESX.Alert(_U('quantity_invalid'))
				else
				menu2.close()
				menu.close()
				if string.find(itemName, "casino") ~= nil then return end
				TriggerServerEvent('esx_fbijob:putStockItems', itemName, count)

				Citizen.Wait(300)
				OpenPutStocksMenu()
				end

			end,
			function(data2, menu2)
				menu2.close()
			end
			)

		end,
		function(data, menu)
			menu.close()
		end
		)

	end)

end

AddEventHandler('esx_fbijob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'VehicleSpawner' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	elseif part == 'HelicopterSpawner' then
		CurrentAction     = 'menu_heli_spawner'
		CurrentActionMsg  = '~INPUT_CONTEXT~ Spawn Helicopter'
		CurrentActionData = {station = station, partNum = partNum}
	elseif part == 'HelicopterSpawnPoint' then
		CurrentAction     = 'menu_heli_deleter'
		CurrentActionMsg  = '~INPUT_CONTEXT~ Impound Helicopter'
		CurrentActionData = {station = station, partNum = partNum}
	elseif part == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if DoesEntityExist(vehicle) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionData = {vehicle = vehicle}
		end

		end
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_fbijob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_fbijob:AddBlipForNumber')
AddEventHandler('esx_fbijob:AddBlipForNumber', function(target, name, job)
	if (PlayerData.job.name == job and PlayerData.job.grade > 0) then
		ESX.Alert("Moqeyiate "..(name):gsub("_", " ").." Roye ~g~Radar~s~ Moshakhas Shod!")
		TriggerfbiRadar(target)
	end
end)

RegisterNetEvent('esx_fbijob:AddBlipForVehicle')
AddEventHandler('esx_fbijob:AddBlipForVehicle', function(plate, job)
	if (PlayerData.job.name == job and PlayerData.job.grade > 0) then
		TriggerfbiVehicleRadar(plate)
	end
end)

local FindNumberBlip = {}
function TriggerfbiRadar(target)
	if not FindNumberBlip[target] then
		FindNumberBlip[target] = AddBlipForCoord(vector3(0,0,0))
		SetBlipAlpha(FindNumberBlip[target], 180)
		SetBlipSprite(FindNumberBlip[target], 1)
		SetBlipScale(FindNumberBlip[target], 0.8)
		SetBlipShrink(FindNumberBlip[target], 1)
		SetBlipCategory(FindNumberBlip[target], 7)
		SetBlipDisplay(FindNumberBlip[target], 6)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Target')
		EndTextCommandSetBlipName(FindNumberBlip[target])
	end
end

local FindVehicleBlip = {}
function TriggerfbiVehicleRadar(plate)
	if not FindVehicleBlip[plate] then
		FindVehicleBlip[plate] = AddBlipForCoord(vector3(0,0,0))
		SetBlipAlpha(FindVehicleBlip[plate], 180)
		SetBlipSprite(FindVehicleBlip[plate], 1)
		SetBlipScale(FindVehicleBlip[plate], 0.8)
		SetBlipShrink(FindVehicleBlip[plate], 1)
		SetBlipCategory(FindVehicleBlip[plate], 7)
		SetBlipDisplay(FindVehicleBlip[plate], 6)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Vehicle Target')
		EndTextCommandSetBlipName(FindVehicleBlip[plate])
		ESX.Alert("Moqeyiate mashin ba pelak '"..plate.."' roye ~g~Radar~s~ moshakhas shod!")
	end
end

RegisterNetEvent('esx_fbijob:UpdateRadar')
AddEventHandler('esx_fbijob:UpdateRadar', function(target, coords)
	if FindNumberBlip[target] then
		SetBlipCoords(FindNumberBlip[target], coords)
	end
end)

RegisterNetEvent('esx_fbijob:KillRadar')
AddEventHandler('esx_fbijob:KillRadar', function(target)
	if FindNumberBlip[target] then
		FindNumberBlip[target] = nil
		if DoesBlipExist(FindNumberBlip[target]) then
			RemoveBlip(FindNumberBlip[target])
		end
	end
end)

RegisterNetEvent('esx_fbijob:UpdateVehRadar')
AddEventHandler('esx_fbijob:UpdateVehRadar', function(plate, coords)
	if FindVehicleBlip[plate] then
		SetBlipCoords(FindVehicleBlip[plate], coords)
	end
end)

RegisterNetEvent('esx_fbijob:KillVehRadar')
AddEventHandler('esx_fbijob:KillVehRadar', function(plate)
	if FindVehicleBlip[plate] then
		FindVehicleBlip[plate] = nil
		if DoesBlipExist(FindVehicleBlip[plate]) then
			RemoveBlip(FindVehicleBlip[plate])
		end
	end
end)

RegisterNetEvent('esx_fbijob:removeHandcuff')
AddEventHandler('esx_fbijob:removeHandcuff', function()
	IsHandcuffed = false
end)

RegisterNetEvent('esx_fbijob:removeHandcuffFull')
AddEventHandler('esx_fbijob:removeHandcuffFull', function()

	local playerPed = PlayerPedId()
	
	IsHandcuffed = false
	TriggerServerEvent('esx_fbijob:SetCuffStatus', false)
	
	if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	ClearPedSecondaryTask(playerPed)
	SetEnableHandcuffs(playerPed, false)
	DisablePlayerFiring(playerPed, false)
	SetPedCanPlayGestureAnims(playerPed, true)
	-- FreezeEntityPosition(playerPed, false)
	
	TriggerEvent("esx_fbijob:removeHandcuff")
end)

RegisterNetEvent('esx_fbijob:unrestrain')
AddEventHandler('esx_fbijob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false
		TriggerServerEvent('esx_fbijob:SetCuffStatus', false)

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

RegisterNetEvent('esx_fbijob:drag')
AddEventHandler('esx_fbijob:drag', function(copID)
	if not IsHandcuffed then
		return
	end
	if DragStatus.CopId then
		TriggerServerEvent('esx_fbijob:lastDragger', DragStatus.CopId)
	end
	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

RegisterNetEvent('esx_fbijob:lastDragger')
AddEventHandler('esx_fbijob:lastDragger', function()
	Draging = false
end)

RegisterNetEvent('esx_fbijob:draging')
AddEventHandler('esx_fbijob:draging', function(copID)
	Draging = not Draging
	if Draging then
		loadanimdict('switch@trevor@escorted_out')
		TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		Citizen.CreateThread(function()
			while Draging do
				Wait(0)
				DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
				DisableControlAction(2, Keys['SPACE'], true) -- Jump
				DisableControlAction(0, Keys['LEFTSHIFT'], true) -- HandsUP
				DisableControlAction(0, Keys['SPACE'], true) -- Jump
			end
		end)
	else
		StopAnimTask(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

RegisterNetEvent('esx_fbijob:putInVehicle')
AddEventHandler('esx_fbijob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		if DoesEntityExist(vehicle) then

			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				TriggerEvent('autobelt')
				DragStatus.IsDragged = false
			end

		end

	end
end)

RegisterNetEvent('esx_fbijob:OutVehicle')
AddEventHandler('esx_fbijob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not (IsPedSittingInAnyVehicle(playerPed) and IsHandcuffed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
	SetTimeout(1000, function()
		if FrontHandCuffed then
			loadanimdict('anim@move_m@prisoner_cuffed')
			TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		else
			loadanimdict('mp_arresting')
			TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		end
	end)
end)

RegisterNetEvent('esx_fbijob:getarrested')
AddEventHandler('esx_fbijob:getarrested', function(playerheading, playercoords, playerlocation, faction, front)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	ESX.UI.Menu.CloseAll()
    ESX.SetPlayerData('isSentenced', true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	ESX.SetEntityCoords(PlayerPedId(), x, y, z)
	if front then
		FrontHandCuffed = true
		SetEntityHeading(PlayerPedId(), playerheading - 180.0)
	else
		SetEntityHeading(PlayerPedId(), playerheading)
	end
	Citizen.Wait(250)
	if not front then
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	else
		loadanimdict('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, 6000 , 2, 0, 0, 0, 0)
	end	
	-- exports.sr_main:SetDecor('_IS_PED_HANDCUFFED', true)
	if not front then
		Citizen.Wait(3760)
	else
		Citizen.Wait(6000)
		loadanimdict('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end
	IsHandcuffed = true
	TriggerCuffCitizen()
	TriggerServerEvent('esx_fbijob:SetCuffStatus', faction)
	if not front then
		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end
	--[[TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
			SetPedComponentVariation(playerPed,7,47,0,0)
		else
			SetPedComponentVariation(playerPed,7,25,0,0)
		end
	end)]]
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_fbijob:doarrested')
AddEventHandler('esx_fbijob:doarrested', function(front)
	ClearPedTasks(PlayerPedId())
	local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuff', 1.0)
	local function DisableControl()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl()
		end)
	end
	DisableControl()
	Citizen.Wait(250)
	if not front then
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	else
		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,6000, 2, 0, 0, 0, 0)
	end	
	Citizen.Wait(3000)
	DisableControl = function() return nil end
end) 

RegisterNetEvent('esx_fbijob:douncuffing')
AddEventHandler('esx_fbijob:douncuffing', function()
	ClearPedTasks(PlayerPedId())
	local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'uncuff', 1.0)
	local function DisableControl()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl()
		end)
	end
	DisableControl()
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
	Draging = false
	DisableControl = function() return nil end
end)

RegisterNetEvent('esx_fbijob:getuncuffed')
AddEventHandler('esx_fbijob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	ESX.SetEntityCoords(PlayerPedId(), x, y, z)
	if not FrontHandCuffed then
		SetEntityHeading(PlayerPedId(), playerheading)
	else
		SetEntityHeading(PlayerPedId(), playerheading - 180.0)
	end
	Citizen.Wait(250)
	if not FrontHandCuffed then
		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	else
		loadanimdict('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8,-1, 2, 0, 0, 0, 0)
		FrontHandCuffed = false
	end
	Citizen.Wait(5500)
	IsHandcuffed = false
	DragStatus.IsDragged = false
	DetachEntity(playerPed, true, false)
	TriggerServerEvent('esx_fbijob:SetCuffStatus', false)
	ClearPedTasks(PlayerPedId())
	SetPedComponentVariation(PlayerPedId(),7,0,0,0)
	ESX.SetPlayerData('isSentenced', false)
	-- exports.sr_main:SetDecor('_IS_PED_HANDCUFFED', false)
	EnableAllControlActions(0)
	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_fbijob:unrestrain')
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.Alert(_U('unrestrained_timer'))
		TriggerEvent('esx_fbijob:unrestrain')
		HandcuffTimer.Active = false
	end)
end

function ImpoundVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.Alert(_U('impound_successful'))
	CurrentTask.Busy = false
end

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function ToggleVehicleLock()
	local xPlayer = ESX.GetPlayerData()
	if has_value("fbi", xPlayer.job.name) then
		
	end
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 70)
	end
	local plate = GetVehicleNumberPlateText(vehicle)
	plate = string.gsub(plate, " ", "")
	if not DoesEntityExist(vehicle) then
		return
	end
	
	if myPlate ~= nil then
		for i=1, #myPlate, 1 do
			if myPlate[i] == plate then
				
				local lockStatus = GetVehicleDoorLockStatus(vehicle)
				
				if lockStatus == 1 then -- unlocked
					SetVehicleDoorsLocked(vehicle, 2)
					PlayVehicleDoorCloseSound(vehicle, 1)

					TriggerEvent('chat:addMessage', { args = { _U('message_title'), _U('message_locked') } })
				elseif lockStatus == 2 then -- locked
					SetVehicleDoorsLocked(vehicle, 1)
					PlayVehicleDoorOpenSound(vehicle, 0)

					TriggerEvent('chat:addMessage', { args = { _U('message_title'), _U('message_unlocked') } })
				end
			end
		end
	end
end

function JailPlayer(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_menu', {
		title = _U('jail_menu_info'),
	}, function (data2, menu)
		local jailTime = tonumber(data2.value)
		if jailTime == nil then
			ESX.Alert('invalid number!')
		else
			TriggerServerEvent("esx_jail:sendToJail", player, jailTime * 60)
			menu.close()
		end
	end, function (data2, menu)
		menu.close()
	end)
end

function UnblockMenuInput()
    Citizen.CreateThread( function()
        Citizen.Wait( 150 )
        blockinput = false 
    end )
end

function SendfbiDistressSignal() -- shift + y
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	ExecuteCommand("me Dastesho Mibare Samt Radio Va Dokme Panic Alarm Ro Feshar Mide")
	ESX.Alert(_U('distress_sent'), "check")
	--[[local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerEvent('InteractSound_CL:PlayOnOne', 'panic', 0.1)

	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		local plate = GetVehicleNumberPlateText(vehicle)
		TriggerServerEvent("esx_fbijob:soundplay", "panic", 0.1, PedPosition.x, PedPosition.y, plate, false, true, true)
	else
		TriggerServerEvent("esx_fbijob:soundplay", "panic", 0.1, PedPosition.x, PedPosition.y, false, string.gsub(PlayerData.name, "_", " "), true)
	end
	--TriggerServerEvent("esx_fbijob:showBackUP", PedPosition.x, PedPosition.y, true)]]
	exports['ps-dispatch']:OfficerInDistress()
end

function SendBackup()
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	ExecuteCommand("me Dastesho Mibare Samt Radio Va Darkhast BackUp Ersal Mikone")
	ESX.Alert(_U('distress_sent'), "check")
	--[[local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerEvent('InteractSound_CL:PlayOnOne', 'demo', 0.5)

	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		local plate = GetVehicleNumberPlateText(vehicle)
		TriggerServerEvent("esx_fbijob:soundplay", "demo", 0.5, PedPosition.x, PedPosition.y, plate, false, false, false)
	else

		TriggerServerEvent("esx_fbijob:soundplay", "demo", 0.5, PedPosition.x, PedPosition.y, false, string.gsub(PlayerData.name, "_", " "), false)
			
	end
	TriggerServerEvent("esx_fbijob:showBackUP", PedPosition.x, PedPosition.y)]]
	exports['ps-dispatch']:OfficerBackup()
end

local P, Q = nil, nil

AddEventHandler("onKeyUP", function(key)
	if key == "e" and showit and PlayerData.job.name == "fbi" then
		showit = false
		SetNewWaypoint(P, Q)
		P, Q = nil, nil
	end
end)

RegisterNetEvent('esx_fbijob:showNotification')
AddEventHandler('esx_fbijob:showNotification', function(x, y)
	showit = true
	P, Q = x, y
	SetTimeout(16000, function()
		showit = false
	end)
	
	local function shownotify()
		ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ ro feshar bedid ta be backup javab bedid")
		if showit then
			SetTimeout(0, shownotify)
		end
	end

	shownotify()
end)

RegisterNetEvent("esx_fbijob:startAnim") 
AddEventHandler("esx_fbijob:startAnim", function(player)
    Citizen.CreateThread(function()
    	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
        RequestAnimDict("random@arrests")
        while not HasAnimDictLoaded( "random@arrests") do
            Citizen.Wait(1)
        end
        TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
    end
    end)
end)

RegisterNetEvent("esx_fbijob:stopAnim")
AddEventHandler("esx_fbijob:stopAnim", function(player)
    Citizen.CreateThread(function()
        Citizen.Wait(1)
        ClearPedTasks(PlayerPedId())
    end)
end)

function EnableActions(ped)
	EnableControlAction(1, 140, true)
	EnableControlAction(1, 141, true)
	EnableControlAction(1, 142, true)
	EnableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, false) -- Disable weapon firing
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

--- cuff anim --
function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

function contains(table, val)
	for i = 1, #table do
		if table[i].name == val then
			return true
		end
	end
	return false
end

function TriggerCuffCitizen()
	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(1)
			local playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					-- AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		end
	end)

	-- Handcuff
	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(0)
			DisableControlAction(2, Keys['~'], true) -- HandsUP
			DisableControlAction(2, Keys['X'], true) -- HandsUP
			DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['M'], true) -- Select Weapon
			DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			DisableControlAction(0, Keys['Q'], true)
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
			end
		end
	end)

	Citizen.CreateThread(function()
		while IsHandcuffed == false do
			Citizen.Wait(0)
			EnableAllControlActions(0)
			EnableAllControlActions(1)
			EnableAllControlActions(2)
		end
	end)
end

-- Create blips
CreateThread(function()
	for k,v in pairs(Config.fbiStations) do
		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, 0.6)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "e" and PlayerData.job.name == "fbi" then
		ActionControl()
	end
end)

function LockerThread()
	Citizen.CreateThread(function()
    	while PlayerData.job and PlayerData.job.name == 'fbi' do
      	Citizen.Wait(3)
			local canSleep  = true
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			for k,v in pairs(Config.fbiStations) do
				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < 5 then
					canSleep = false
						DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end
				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < 5 then
					canSleep = false
						DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end
				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < 5 then
					canSleep = false
						DrawMarker(Config.MarkerTypeveh, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end
				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < 5 then
					canSleep = false
						DrawMarker(Config.MarkerTypevehdel, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end
				for i=1, #v.Helicopters, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, true) < 10.0 then
						canSleep = false
						DrawMarker(7, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y,v.Helicopters[i].Spawner.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 0, 0, 255, 100, false, true, 2, false, false, false, false)
					end
				end
				for i=1, #v.DoorLock, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.DoorLock[i].x,  v.DoorLock[i].y,  v.DoorLock[i].z,  true) < (Config.MarkerSize.x / 2) then
						canSleep = false
						DrawMarker(Config.MarkerType, v.DoorLock[i].x,  v.DoorLock[i].y,  v.DoorLock[i].z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 0, 0, 255, 100, false, true, 2, false, false, false, false)
					end
				end	
				--if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < 5 then
						canSleep = false
							DrawMarker(Config.MarkerTypeboss, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				--end
			end
			if canSleep then Citizen.Wait(500) end
		end
	end)
end

function TriggerfbiCitizen()
	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'fbi' do
		Citizen.Wait(1000)
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil
			for k,v in pairs(Config.fbiStations) do
				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Cloakroom'
						currentPartNum = i
					end
				end
				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Armory'
						currentPartNum = i
					end
				end
				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleSpawner'
						currentPartNum = i
					end
				end
				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end
				for i=1, #v.Helicopters, 1 do
					if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < (Config.MarkerSize.x / 2) then
						isInMarker     = true
						currentStation = k
						currentPart    = 'HelicopterSpawner'
						currentPartNum = i
					end
				end		
				--if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'BossActions'
							currentPartNum = i
						end
					end
				--end
			end
			local hasExited = false
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					TriggerEvent('esx_fbijob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end
				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum
				TriggerEvent('esx_fbijob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end
			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_fbijob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
		end
	end)
end

local locations = {
    {
        coords = vector3(136.16, -761.73, 44.8),
        coords2 = vector4(136.05, -761.79, 241.2, 172.0),
        text = 'Press ~INPUT_PICKUP~ To Enter FBI.'
    },
    {
        coords = vector3(136.05, -761.79, 241.2),
        coords2 = vector4(136.16, -761.73, 44.8, 172.0),
        text = 'Press ~INPUT_PICKUP~ To Exit FBI.'
    },
    {
        coords = vector3(139.07, -762.68, 44.8),
        coords2 = vector4(88.80, -726.80, 32.183, 337.0),
        text = 'Press ~INPUT_PICKUP~ To Enter Garage.'
    },
    {
        coords = vector3(88.80, -726.80, 32.183),
        coords2 = vector4(139.07, -762.68, 44.8, 172.0),
        text = 'Press ~INPUT_PICKUP~ To Exit Garage.'
    },
    {
        coords = vector3(138.4, -764.48, 241.2),
        coords2 = vector4(141.39, -734.85, 261.88, 165.0),
        text = 'Press ~INPUT_PICKUP~ To Enter Roof.'
    },
    {
        coords = vector3(141.39, -734.85, 261.88),
        coords2 = vector4(138.4, -764.48, 241.2, 172.0),
        text = 'Press ~INPUT_PICKUP~ To Exit Roof.'
    },
	{
        coords = vector3(131.18, -762.86, 241.20),
        coords2 = vector4(115.03, -741.5, 257.20, 336.17),
        text = 'Press ~INPUT_PICKUP~ To Exit Roof.'
    },
	{
        coords = vector3(115.03, -741.5, 258.10),
        coords2 = vector4(131.18, -762.86, 241.20, 336.17),
        text = 'Press ~INPUT_PICKUP~ To Exit Roof.'
    },
}

local Coords = nil
local NearCoords = nil
local Head = nil 

-- AddEventHandler("onKeyDown", function(key)
--     if key == "e" then
-- 		if NearCoords then
-- 			ESX.TriggerServerCallback('esx_fbijob:getdoor', function(result)
-- 				if result then
-- 					ESX.SetEntityCoords(PlayerPedId(), Coords)
-- 					SetEntityHeading(PlayerPedId(), Head)
-- 				else
-- 					ESX.Alert('The Door is Locked', "error")
-- 				end
-- 			end)
-- 		elseif ESX.PlayerData.job.name == "fbi" then
-- 			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  vector3(125.18, -766.19, 242.20),  true) < (Config.MarkerSize.x / 2) then
-- 				TriggerServerEvent("esx_fbijob:ChangeDoorsStats")
-- 			end
-- 		end
--     end
-- end)

-- Citizen.CreateThread(function ()
--     while true do
--         Citizen.Wait(4)
-- 		local Sleep = true
-- 		for k, v in pairs(locations) do
-- 			local distance = #(GetEntityCoords(PlayerPedId()) - v.coords)
-- 			if distance < 2.0 then
-- 				Sleep = false
-- 				DrawMarker(23, v.coords, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 36, 237, 157, 200, 0, 0, 0, 0)
-- 				NearCoords, Coords, Head = true, v.coords2, v.coords2.w
-- 			end
-- 		end
-- 		if Sleep then Citizen.Wait(750) NearCoords = false end
--     end
-- end)


-- Change Name Area
--[[local ChangeName = vector3(441.26, -981.81, 30.69)
CreateThread(function()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(ChangeName, 15, true)
	DMarker.set('InArea', function()
		DrawMarker(20, ChangeName.x, ChangeName.y, ChangeName.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 100, true, true, 2, false, false, false, false)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(ChangeName, 1, true)
		DInMarker.set('InAreaOnce', function()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Taghir Name Khod')
			Key = RegisterKey('E', false, function()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'first_name', {
					title = 'لطفا اسم کوچک خودتون رو وارد کنید',
				}, function(data, menu)
					menu.close()
					if data.value then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'last_name', {
							title = 'لطفا نام خانوادگی خودتون رو وارد کنید',
						}, function(data2, menu2)
							menu2.close()
							if data2.value then
								TriggerServerEvent('sr:changeNickname', data.value, data2.value)
							else
								ESX.Alert('Meghdar sahih vared ~r~nashod~s~!')
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					else
						ESX.Alert('Meghdar sahih vared ~r~nashod~s~!')
					end
				end, function(data, menu)
					menu.close()
				end)
			end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
		end)
	end, function()
		if DInMarker then
			DInMarker = DInMarker.remove()
		end
	end)
end)]]

function SetVehicleMaxMods(vehicle)

	local props = {
		modEngine       =   3,
		modBrakes       =   2,
		windowTint      =   1,
		modArmor        =   4,
		modTransmission =   2,
		modSuspension   =   -1,
		modTurbo        =   false,
		modXenon     = false,
		color1 = 0,
		color2 = 0,
		pearlescentColor = 0
	}
		
ESX.Game.SetVehicleProperties(vehicle, props)

end