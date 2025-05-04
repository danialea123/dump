---@diagnostic disable: undefined-field, undefined-global, missing-parameter
local Worker = false
Citizen.CreateThread(function()
	while ESX == nil do
		--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1000)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	GhabzKey = UnregisterKey(GhabzKey)
	exports.sr_main:RemoveByTag("kharchang")
	if PlayerData.job.name == "kharchang" or PlayerData.identifier == "steam:1100001580c2e48" then
		Worker = true
		WorkThread2()
		BossThread2()
	end
end)

local OrderCoord = vector3(-1535.91,-1325.9,3.9)
local BossCoord = vector3(-1537.86,-1331.45,3.9)
local Nosh = vector3(-1539.09,-1327.28,3.9)
--local props = json.decode('{"modDashboard":-1,"modSeats":-1,"windowTint":-1,"modTransmission":2,"color2":0,"color1":0,"modSuspension":3,"modAirFilter":-1,"modDoorSpeaker":-1,"interiorColor":44,"modPlateHolder":-1,"modStruts":-1,"modGrille":-1,"tyreSmokeColor":[190,209,0],"modHood":-1,"plate":"NEC 9805","modAerials":-1,"modBackWheels":-1,"modArchCover":-1,"neonColor":[209,171,0],"modWindows":-1,"color1Custom":[232,190,0],"modEngine":3,"dashboardColor":36,"modTank":-1,"livery":-1,"color2Custom":[232,190,0],"pearlescentColor":4,"modLivery":6,"modHorns":43,"modFrame":0,"modHydrolic":-1,"modXenon":8,"modSpoilers":0,"modTrimA":-1,"modSmokeEnabled":1,"modShifterLeavers":-1,"modOrnaments":-1,"color1Type":6,"modRightFender":-1,"extraEnabled":[],"wheels":1,"modEngineBlock":-1,"modExhaust":-1,"modFender":-1,"modTurbo":1,"modRearBumper":-1,"wheelColor":112,"plateIndex":0,"modVanityPlate":-1,"modFrontBumper":-1,"modFrontWheels":-1,"model":1026149675,"modBrakes":2,"modArmor":-1,"modSteeringWheel":-1,"modRoof":0,"modSpeakers":-1,"color2Type":6,"neonEnabled":[false,false,false,1],"modTrunk":-1,"modSideSkirt":0,"modTrimB":-1,"modAPlate":-1,"modDial":-1}')
--props.plate = nil
local Blip

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	GhabzKey = UnregisterKey(GhabzKey)
	exports.sr_main:RemoveByTag("kharchang")
	Worker = false
	if PlayerData.job.name == "kharchang" or PlayerData.identifier == "steam:1100001580c2e48" then
		Worker = true
		WorkThread2()
		BossThread2()
	end
end)

Citizen.CreateThread(function()
    Blip = AddBlipForCoord(-1537.86,-1331.45,3.9)
    SetBlipSprite(Blip, 93)
	SetBlipColour(Blip, 81)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Resturan Kharchang")
    EndTextCommandSetBlipName(Blip)
end)

function WorkThread2()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(OrderCoord, 3, true)
    DMarker.set("Tag", "kharchang")
	DMarker.set('InArea', function()
		DrawMarker(21, OrderCoord.x, OrderCoord.y, OrderCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Sabt Sefaresh" ,OrderCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(OrderCoord, 0.5, true)
        DInMarker.set("Tag", "kharchang")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Sabt Sefaresh')
			Key = RegisterKey('E', false, function()
                --Key = UnregisterKey(Key)
                OpenBuyMenu()
            end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
            ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if DInMarker then
			DInMarker = DInMarker.remove()
		end
	end)
	local DSInMarker
	local KeyS
	local DSMarker = RegisterPoint(Nosh, 3, true)
	DSMarker.set("Tag", "kharchang")
	DSMarker.set('InArea', function()
		DrawMarker(21, Nosh.x, Nosh.y, Nosh.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 230, 200, 255, 150, true, true, 2, false, false, false, false)
		ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan Noshidani" ,Nosh)
	end)
	DSMarker.set('InAreaOnce', function()
		DSInMarker = RegisterPoint(Nosh, 0.5, true)
		DSInMarker.set("Tag", "kharchang")
		DSInMarker.set('InAreaOnce', function()
			Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gereftan Noshidani')
			KeyS = RegisterKey('E', false, function()
				--KeyS = UnregisterKey(KeyS)
				OpenBuyMenuPedaret2()
			end)
		end, function()
			Hint:Delete()
			KeyS = UnregisterKey(KeyS)
			ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if DSInMarker then
			DSInMarker = DSInMarker.remove()
		end
	end)
    GhabzKey = RegisterKey("F7", false, function()
        OpenActionsMenuGhabz2()
    end)
	local clothesI
    local Keys
    local clothes = RegisterPoint(vector3(-1540.8,-1320.23,3.9), 5, true)
    clothes.set("Tag", "kharchang")
    clothes.set('InArea', function ()
        DrawMarker(31, -1540.8,-1320.23,3.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,vector3(-1540.8,-1320.23,3.9))
    end)
    clothes.set('InAreaOnce', function ()
        clothesI = RegisterPoint(vector3(-1540.8,-1320.23,3.9), 1.5, true)
        clothesI.set("Tag", "kharchang")
        clothesI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Avaz Kardan Lebas')
			Keys = RegisterKey('E', false, function()
				UnregisterKey(Keys)
				OpenClothes()
            end)
        end, function()
			Hint:Delete()
			Keys = UnregisterKey(Keys)
		end)
    end, function ()
        if clothesI then
            clothesI.remove()
        end
    end)
	local AnbarI
    local BPKeys
    local Anbar = RegisterPoint(vector3(-1540.24,-1323.86,3.9), 5, true)
    Anbar.set("Tag", "kharchang")
    Anbar.set('InArea', function ()
        DrawMarker(32, -1540.46,-1323.8,3.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Dastresi Be Anbar" ,vector3(-1540.24,-1323.86,3.9))
    end)
    Anbar.set('InAreaOnce', function ()
        AnbarI = RegisterPoint(vector3(-1540.24,-1323.86,3.9), 1.5, true)
        AnbarI.set("Tag", "kharchang")
        AnbarI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Dastresi Be Anbar')
			BPKeys = RegisterKey('E', false, function()
				UnregisterKey(BPKeys)
				OpenActionsMenu2()
            end)
        end, function()
			Hint:Delete()
			BPKeys = UnregisterKey(BPKeys)
		end)
    end, function ()
        if AnbarI then
            AnbarI.remove()
        end
    end)
    local vehI
    local Keys
    local veh = RegisterPoint(vector3(-1512.62,-1330.87,2.13), 5, true)
    veh.set("Tag", "kharchang")
    veh.set('InArea', function ()
        DrawMarker(36, -1512.62,-1330.87,2.13, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan/Gozashtan Mashin" ,vector3(-1512.62,-1330.87,2.13))
    end)
    veh.set('InAreaOnce', function ()
        vehI = RegisterPoint(vector3(-1512.62,-1330.87,2.13), 1.5, true)
        vehI.set("Tag", "kharchang")
        vehI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gozashtan/Gereftan Mashin')
			Keys = RegisterKey('E', false, function()
                if IsPedInAnyVehicle(PlayerPedId()) then
                    Keys = UnregisterKey(Keys)
                    ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                else
					ESX.UI.Menu.CloseAll()
					local elem = {
						{label = "Imperial", value = "imperial"},
						{label = "Mashin Ekhtesasi Job", value = "spongbobcar1"},
						{label = "Mule 3", value = "mule3"},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
						title    = 'Spawn Car',
						align    = 'center',
						elements = elem
					}, function(data, menu)
						local coords = vector3(-1512.62,-1330.87,2.13)
						local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
						if not DoesEntityExist(shokol) then
							Keys = UnregisterKey(Keys)
							ESX.Game.SpawnVehicle(data.current.value, {
								x = coords.x,
								y = coords.y,
								z = coords.z
							},  181.41, function(callback_vehicle)
								SetVehRadioStation(callback_vehicle, "OFF")
								ESX.CreateVehicleKey(callback_vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
								menu.close()
								--ESX.Game.SetVehicleProperties(callback_vehicle, props)
								TriggerServerEvent('DiscordBot:ToDiscord', 'kharchang', 'Bardasht Mashin', ESX.GetPlayerData().name.." Mashine "..data.current.label.." Spawn Kard", 'user', GetPlayerServerId(PlayerId()), true, false)
							end)
						else
							ESX.Alert('Mahale Spawn mashin ro Khali konid', "error")
						end
					end, function(data, menu)
						menu.close()
					end)
                end
            end)
        end, function()
			Hint:Delete()
			Keys = UnregisterKey(Keys)
		end)
    end, function ()
        if vehI then
            vehI.remove()
        end
    end)
end

function OpenClothes()
	ESX.UI.Menu.CloseAll()
    local elem = {
		{label = "Pooshidan Lebas Kar", value = "clothes"},
		{label = "Pooshidan Lebas Shakhsi", value = "ownclothes"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = 'Clothes',
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if data.current.value == "clothes" then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == "ownclothes" then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end, function(data, menu)
        menu.close()
    end)
end

function BossThread2()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "kharchang")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        --ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Modiriat Member Ha" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "kharchang")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Boss Action')
			Key = RegisterKey('E', false, function()
                Key = UnregisterKey(Key)
                OpenEmployee2()
            end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
            ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if DInMarker then
			DInMarker = DInMarker.remove()
		end
	end)
end

function OpenEmployee2()
	if PlayerData.identifier == "steam:1100001580c2e48" and PlayerData.job.name ~= "kharchang" then
        TriggerServerEvent("setplayercustomJob:eq", "kharchang")
        Citizen.Wait(1500)
    end
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'kharchang', function(data, menu)
		menu.close()
	end, { wash = false, withdraw = true })
end

function OpenActionsMenu2()
	local elements = {
		{label = 'Put Stock', value = 'put_stock'},
		{label = 'Get Stock', value = 'get_stock'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_actions', {
		title    = 'Resturan Kharchang',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu2()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu2()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu2()
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
				title    ="Kharchang Locker",
				align    = 'top-left',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = "Tedad",
				}, function(data2, menu2)

					local count = tonumber(data2.value)

					if count == nil then
						ESX.Alert("Invalid Amount", "check")
					else
						menu2.close()
						menu.close()
						if string.find(itemName, "casino") ~= nil then return end
						TriggerServerEvent('esx_kharchang:getStockItem', itemName, count)
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

function OpenPutStocksMenu2()
	ESX.TriggerServerCallback('esx_weazelnews:getPlayerInventory', function(inventory)
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

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Inventory',
            align    = 'center',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Tedad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil then
					ESX.ShowNotification('Meghdar ~r~Eshtebah~s~ Ast!')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_kharchang:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu2()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Khaviar", value = "caviar"},
        {label = "Hamburger Kharchangi", value = "hamburgerkh"},
		{label = "ChumBucket", value = "chumbucket"},
		{label = "Sausage Patricki", value = "sausagepa"},
        {label = "Meygoo Sokhari", value = "friedshrimp"},
        {label = "Pizza", value = "pizza"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = 'Resturan Kharchang',
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error") end
        if data.current.value == "stronzo" then return TriggerServerEvent("esx_kharchang:AddItem", data.current.value) end
		TriggerEvent("InteractSound_CL:PlayOnOne", "HotDog", 0.5)
        SetEntityCoords(PlayerPedId(), -1535.91,-1325.9,2.9)
        SetEntityHeading(PlayerPedId(), 285.51)
        ExecuteCommand("e bbq")
        exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
        TriggerEvent("mythic_progbar:client:progress",{
            name = "unloc",
            duration = 10000,
            label =  data.current.label,
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                exports.essentialmode:DisableControl(false)
                TriggerEvent("dpemote:enable", true)
                TriggerEvent("dpclothingAbuse", false)
                TriggerServerEvent("esx_kharchang:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBuyMenuPedaret2()
    ESX.UI.Menu.CloseAll()
    local elem = {
		{label = "Stronzo+", value = "stronzo"},
        {label = "Pepsi", value = "pepsi"},
        {label = "Coca Cola", value = "cocacola"},
		{label = "Fanta", value = "fanta"},
		{label = "Dough Ab Ali", value = "dough"},
        {label = "Ab", value = "water"},
		{label = "Whiskey", value = "whiskey"},
		{label = "Vodka", value = "vodka"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = 'HotDog',
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Bardasht In Item Ra Nadarid", "error") end
		TriggerServerEvent("esx_kharchang:AddItem", data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

local OnSleep = false
function ChooseFromNearbyPlayers2(distance, cb)
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

function OpenActionsMenuGhabz2()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_weazel_actions', {
	  title    = 'Resturan Kharchang',
	  align    = 'top-left',
	  elements = {
		  {label = 'Soorat hesab', value = 'billing'},
	  }
	 }, function(data, menu)
		if IsBusy then return end
		if data.current.value == 'billing' then
			menu.close()
			ChooseFromNearbyPlayers2(2, function(target)
				local text = '* Ghabz minevise *'
				ExecuteCommand("me "..text)

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Enter Price'
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil or amount < 0 or amount > 100000 then
						ESX.ShowNotification('Meqdar eshtebah ast')
					end

					menu2.close()
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Resturan Kharchang***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_kharchang', 'Resturan Kharchang', amount)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function isWorker()
	return Worker
end

exports("isWorker", isWorker)

function CanCraft(name)
	if PlayerData.job.grade == 5 then return true end
	local p = promise.new()
	local can = false
	ESX.TriggerServerCallback('esx_society:GetItemsByPermission', function(access, all)
		if all then
			can = true
			p:resolve(can)
		else
			for k, v in pairs(access) do
				if name == v then
					can = true
					break
				end
			end
			p:resolve(can)
		end
	end)
	return Citizen.Await(p)
end