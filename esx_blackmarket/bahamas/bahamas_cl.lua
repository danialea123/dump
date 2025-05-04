---@diagnostic disable: missing-parameter, undefined-global, undefined-field
local Worker = false
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	if PlayerData.job.name == "bahamas" then
		GhabzKey = UnregisterKey(GhabzKey)
		exports.sr_main:RemoveByTag("bahamas")
		Citizen.Wait(750)
		WorkThread()
		BossThread()
		Worker = true
	end
end)

local Cool = false
local OrderCoord = vector3(-1386.05,-606.06,30.32)
local BossCoord = vector3(-1385.55,-633.7,30.82)
local Nosh = vector3(-1386.71,-608.73,30.32)
--local props = json.decode('{"modDashboard":-1,"modSeats":-1,"windowTint":-1,"modTransmission":2,"color2":0,"color1":0,"modSuspension":3,"modAirFilter":-1,"modDoorSpeaker":-1,"interiorColor":44,"modPlateHolder":-1,"modStruts":-1,"modGrille":-1,"tyreSmokeColor":[190,209,0],"modHood":-1,"plate":"NEC 9805","modAerials":-1,"modBackWheels":-1,"modArchCover":-1,"neonColor":[209,171,0],"modWindows":-1,"color1Custom":[232,190,0],"modEngine":3,"dashboardColor":36,"modTank":-1,"livery":-1,"color2Custom":[232,190,0],"pearlescentColor":4,"modLivery":6,"modHorns":43,"modFrame":0,"modHydrolic":-1,"modXenon":8,"modSpoilers":0,"modTrimA":-1,"modSmokeEnabled":1,"modShifterLeavers":-1,"modOrnaments":-1,"color1Type":6,"modRightFender":-1,"extraEnabled":[],"wheels":1,"modEngineBlock":-1,"modExhaust":-1,"modFender":-1,"modTurbo":1,"modRearBumper":-1,"wheelColor":112,"plateIndex":0,"modVanityPlate":-1,"modFrontBumper":-1,"modFrontWheels":-1,"model":1026149675,"modBrakes":2,"modArmor":-1,"modSteeringWheel":-1,"modRoof":0,"modSpeakers":-1,"color2Type":6,"neonEnabled":[false,false,false,1],"modTrunk":-1,"modSideSkirt":0,"modTrimB":-1,"modAPlate":-1,"modDial":-1}')
--props.plate = nil
local clothes = json.decode('{"pants_1": 62,"bproof_1": 0,"bproof_2": 0,"mask_1": 8,"chain_1": 0,"shoes_1": 10,"torso_1": 100,"pants_2": 0,"tshirt_2": 0,"torso_2": 7,"shoes_2": 0,"helmet_2": 0,"helmet_1": -1,"arms": 4,"tshirt_1": 15,"mask_2": 0,"chain_2": 0}')
local Blip

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	GhabzKey = UnregisterKey(GhabzKey)
	exports.sr_main:RemoveByTag("bahamas")
	Worker = false
	if PlayerData.job.name == "bahamas" then
		Worker = true
		WorkThread()
		BossThread()
	end
end)

--[[RegisterNetEvent("esx_newbahamas:employeeLoaded")
AddEventHandler("esx_newbahamas:employeeLoaded", function(isBoss)
	Worker = true
    GhabzKey = UnregisterKey(GhabzKey)
    exports.sr_main:RemoveByTag("bahamas")
    WorkThread()
    if isBoss then
        Boss = true
    end
	BossThread()
end)]]

RegisterCommand("bahamasdancer", function()
	if not Worker then return end
	if Cool then return end
	Cool = true
	Citizen.SetTimeout(3000, function()
		Cool = false
	end)
	TriggerServerEvent("esx_casino:BahamasDancerState")
	ESX.Alert("Taghirat Emaal Shod", "info")
end)

Citizen.CreateThread(function()
    Blip = AddBlipForCoord(-1371.0,-594.31,21.6)
    SetBlipSprite(Blip, 766)
	SetBlipColour(Blip, 81)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Bahamas")
    EndTextCommandSetBlipName(Blip)
end)

function WorkThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(OrderCoord, 3, true)
    DMarker.set("Tag", "bahamas")
	DMarker.set('InArea', function()
		DrawMarker(21, OrderCoord.x, OrderCoord.y, OrderCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Sabt Sefaresh" ,OrderCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(OrderCoord, 0.5, true)
        DInMarker.set("Tag", "bahamas")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Sabt Sefaresh')
			Key = RegisterKey('E', false, function()
                Key = UnregisterKey(Key)
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
	DSMarker.set("Tag", "bahamas")
	DSMarker.set('InArea', function()
		DrawMarker(21, Nosh.x, Nosh.y, Nosh.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 230, 200, 255, 150, true, true, 2, false, false, false, false)
		ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Baaz Kardan Yakhchal" ,Nosh)
	end)
	DSMarker.set('InAreaOnce', function()
		DSInMarker = RegisterPoint(Nosh, 0.5, true)
		DSInMarker.set("Tag", "bahamas")
		DSInMarker.set('InAreaOnce', function()
			Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gereftan Noshidani')
			KeyS = RegisterKey('E', false, function()
				KeyS = UnregisterKey(KeyS)
				OpenBuyMenuPedaret()
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
        OpenActionsMenuGhabz()
    end)
    local vehI
    local Keys
    local veh = RegisterPoint(vector3(-1394.62,-582.75,30.15), 5, true)
    veh.set("Tag", "bahamas")
    veh.set('InArea', function ()
        DrawMarker(36, -1394.62,-582.75,30.15, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan/Gozashtan Mashin" ,vector3(-1394.62,-582.75,30.15))
    end)
    veh.set('InAreaOnce', function ()
        vehI = RegisterPoint(vector3(-1394.62,-582.75,30.15), 1.5, true)
        vehI.set("Tag", "bahamas")
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
						{label = "Imperial 2", value = "imperial2"},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
						title    = 'Spawn Car',
						align    = 'center',
						elements = elem
					}, function(data, menu)
						local coords = vector3(-1394.62,-582.75,30.15)
						local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
						if not DoesEntityExist(shokol) then
							Keys = UnregisterKey(Keys)
							ESX.Game.SpawnVehicle(data.current.value, {
								x = coords.x,
								y = coords.y,
								z = coords.z
							},  302.41, function(callback_vehicle)
								SetVehRadioStation(callback_vehicle, "OFF")
								ESX.CreateVehicleKey(callback_vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
								menu.close()
								--ESX.Game.SetVehicleProperties(callback_vehicle, props)
								TriggerServerEvent('DiscordBot:ToDiscord', 'bahamas', 'Bardasht Mashin', ESX.GetPlayerData().name.." Mashine "..data.current.label.." Spawn Kard", 'user', GetPlayerServerId(PlayerId()), true, false)
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
	local SvehI
    local SKeys
    local Sveh = RegisterPoint(vector3(-1371.09,-626.12,30.82), 5, true)
    Sveh.set("Tag", "bahamas")
    Sveh.set('InArea', function ()
        DrawMarker(31, -1371.09,-626.12,30.82, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,vector3(-1371.09,-626.12,30.82))
    end)
    Sveh.set('InAreaOnce', function ()
        SvehI = RegisterPoint(vector3(-1371.09,-626.12,30.82), 1.5, true)
        SvehI.set("Tag", "bahamas")
        SvehI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Avaz Kardan Lebas')
			SKeys = RegisterKey('E', false, function()
				UnregisterKey(SKeys)
				OpenClothes()
            end)
        end, function()
			Hint:Delete()
			SKeys = UnregisterKey(SKeys)
		end)
    end, function ()
        if SvehI then
            SvehI.remove()
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

function BossThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "bahamas")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Baaz Kardan Locker" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "bahamas")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Baaz Kardan Locker')
			Key = RegisterKey('E', false, function()
                Key = UnregisterKey(Key)
                OpenEmployee()
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

function OpenEmployee()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Boss Action", value = "boss"},
        {label = "Storage", value = "storage"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = 'Management',
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if data.current.value == "storage" then
			menu.close()
			OpenActionsMenu()
		else
			ESX.UI.Menu.CloseAll()
			TriggerEvent('esx_society:openBossMenu', 'bahamas', function(data, menu)
				menu.close()
			end, { wash = false, withdraw = true })
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenActionsMenu()
	local elements = {
		{label = 'Put Stock', value = 'put_stock'},
		{label = 'Get Stock', value = 'get_stock'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_actions', {
		title    = "Bahamas",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
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

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    ="Bahamas Locker",
				align    = 'top-left',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = _U('quantity')
				}, function(data2, menu2)

					local count = tonumber(data2.value)

					if count == nil then
						ESX.Alert(_U('quantity_invalid'))
					else
						menu2.close()
						menu.close()
						if string.find(itemName, "casino") ~= nil then return end
						TriggerServerEvent('esx_newbahamas:getStockItem', itemName, count)
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
					TriggerServerEvent('esx_newbahamas:putStockItems', itemName, count)
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

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Sini Maaze", value = "sini"},
        {label = "Mohito", value = "moohito"},
		{label = "Bloody Merry", value = "bloodymerry"},
		{label = "Margarita", value = "margarita"},
        {label = "Pina Colada", value = "pinacolada"},
        {label = "Vodka Redbull", value = "vodkaredbull"},
		{label = "Whiskey Cola", value = "whiskeycola"},
		{label = "Hype Energy", value = "hypeenergy"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = "Bahamas",
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error") end
        --SetEntityCoords(PlayerPedId(), -1371.07,-594.07,21.7)
        --SetEntityHeading(PlayerPedId(), 120.61)
        ExecuteCommand("e mechanic4")
        exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
        TriggerEvent("mythic_progbar:client:progress",{
            name = "unloc",
            duration = 5000,
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
				TriggerEvent("onKeyDown", "x")
                TriggerServerEvent("esx_newbahamas:AddCraftItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
		TriggerEvent("InteractSound_CL:PlayOnOne", "blender", 0.5)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBuyMenuPedaret()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Kalbas", value = "kalbas"},
        {label = "Zeytoon", value = "zeytoon"},
		{label = "Ice", value = "yakh"},
		{label = "Vodka", value = "vodka"},
        {label = "Coca Cola", value = "cocacola"},
		{label = "Toot Farangi", value = "toot"},
		{label = "Limoo", value = "limo"},
		{label = "Shekar Darchin", value = "zimt"},
		{label = "Annanas", value = "anna"},
		{label = "Tonic Water", value = "tonic"},
		{label = "RedBull", value = "redbull"},
		{label = "Nanaa", value = "nanaa"},
		{label = "Khaame", value = "khame"},
		{label = "Asal", value = "asal"},
		{label = "Whiskey", value = "whiskey"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = "Bahamas",
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Bardasht In Item Ra Nadarid", "error") end
		TriggerServerEvent("esx_newbahamas:AddItem", data.current.value)
        --menu.close()
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

function OpenActionsMenuGhabz()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_weazel_actions', {
	  title    = 'Bahamas',
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

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Enter Price'
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil or amount < 0 or amount > 100000 then
						ESX.ShowNotification('Meqdar eshtebah ast')
					end

					menu2.close()
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***"Bahamas"***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_bahamas', "Bahamas", amount)
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
	print(Worker)
	return Worker
end

exports("isWorker", isWorker)

Config.VStripDancerPeds = {
    { model="s_f_y_stripperlite", x=-1379.94, y = -617.63, z = 31.76, a = 124.22, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
    { model="csb_stripper_01", x=-1383.65, y = -612.15, z = 31.76, a = 131.43, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
    { model="csb_stripper_02", x=-1389.54, y = -633.02, z = 30.83, a = 308.61, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
	{ model="s_f_y_stripper_02", x=-1390.26, y = -620.81, z = 30.82, a = 307.68, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
    { model="mp_f_stripperlite", x=-1387.51, y = -613.42, z = 30.82, a = 229.89, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
    --{ model="s_f_y_stripperlite", x=-1383.14, y = -610.36, z = 28.8, a = 35.19, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
}

-- START DANCERS
local VStripPeds, VNightClubPeds = {}, {}
local function TriggerVStripDancers()
    -- Dancers
    for k,v in ipairs(Config.VStripDancerPeds) do
        RequestModel(GetHashKey(v.model))

        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(0)
        end

        RequestAnimDict(v.animation)
        
        while not HasAnimDictLoaded(v.animation) do
            Wait(1)
        end
        
        local stripPed = CreatePed(1, GetHashKey(v.model), v.x, v.y, v.z-1, v.a, false, false)
        table.insert(VStripPeds, stripPed)
        
        SetEntityInvincible(stripPed, true)
        SetBlockingOfNonTemporaryEvents(stripPed, true)
        
        Wait(500)
        
        FreezeEntityPosition(stripPed, true)
        SetPedFleeAttributes(stripPed, 0, 0)
        SetPedArmour(stripPed, 100)
        SetPedMaxHealth(stripPed, 100)
        SetPedDiesWhenInjured(stripPed, false)
        TaskPlayAnim(stripPed, v.animation, v.animationName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        SetModelAsNoLongerNeeded(GetHashKey(v.model))
    end
end

RegisterNetEvent('esx_bahamas:TogglevStripDancers')
AddEventHandler('esx_bahamas:TogglevStripDancers', function(toggle)
	if toggle then
        CreateThread(TriggerVStripDancers)
    else
        for k,v in pairs(VStripPeds) do
            DeletePed(v)
        end
        VStripPeds = {}
    end
end)

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