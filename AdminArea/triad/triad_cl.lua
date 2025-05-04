---@diagnostic disable: missing-parameter, undefined-global, undefined-field, need-check-nil
local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(900)
	end

	PlayerData = ESX.GetPlayerData()
    GhabzKey = UnregisterKey(GhabzKey)
    exports.sr_main:RemoveByTag("triad")
	if PlayerData.job.name == "triad" then
		WorkThread()
		BossThread()
	end
end)

local Cool = false
local OrderCoord = vector3(-829.45,-728.61,28.06)
local BossCoord = vector3(-816.4,-698.74,32.14)
local Nosh = vector3(-831.33,-729.91,28.06)
local Clothes = vector3(-815.97,-717.88,28.06)
local Storage = vector3(-816.7,-696.43,32.14)
local Blip

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    GhabzKey = UnregisterKey(GhabzKey)
    exports.sr_main:RemoveByTag("triad")
	if PlayerData.job.name == "triad" then
		WorkThread()
		BossThread()
	end
end)

RegisterCommand("triaddancer", function()
	if PlayerData.job.name == "triad" then
		if Cool then return end
		Cool = true
		Citizen.SetTimeout(3000, function()
			Cool = false
		end)
		TriggerServerEvent("esx_casino:VanillaDancerState")
		ESX.Alert("Taghirat Emaal Shod", "info")
	end
end)

Citizen.CreateThread(function()
    Blip = AddBlipForCoord(-829.45,-728.61,28.06)
    SetBlipSprite(Blip, 590)
	SetBlipColour(Blip, 81)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("TriadClub")
    EndTextCommandSetBlipName(Blip)
end)

function WorkThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(OrderCoord, 3, true)
    DMarker.set("Tag", "triad")
	DMarker.set('InArea', function()
		DrawMarker(21, OrderCoord.x, OrderCoord.y, OrderCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Sabt Sefaresh" ,OrderCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(OrderCoord, 0.5, true)
        DInMarker.set("Tag", "triad")
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
	DSMarker.set("Tag", "triad")
	DSMarker.set('InArea', function()
		DrawMarker(21, Nosh.x, Nosh.y, Nosh.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 230, 200, 255, 150, true, true, 2, false, false, false, false)
		ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Baaz Kardan Yakhchal" ,Nosh)
	end)
	DSMarker.set('InAreaOnce', function()
		DSInMarker = RegisterPoint(Nosh, 0.5, true)
		DSInMarker.set("Tag", "triad")
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
    local veh = RegisterPoint(vector3(-817.62,-728.2,23.78), 5, true)
    veh.set("Tag", "triad")
    veh.set('InArea', function ()
        DrawMarker(36, -817.62,-728.2,23.78, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan/Gozashtan Mashin" ,vector3(-817.62,-728.2,23.78))
    end)
    veh.set('InAreaOnce', function ()
        vehI = RegisterPoint(vector3(-817.62,-728.2,23.78), 1.5, true)
        vehI.set("Tag", "triad")
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
						{label = "MoonBeam 2", value = "moonbeam2"},
						{label = "Stretch", value = "stretch"},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
						title    = 'Spawn Car',
						align    = 'center',
						elements = elem
					}, function(data, menu)
						local coords = vector3(-817.62,-728.2,23.78)
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
								TriggerServerEvent('DiscordBot:ToDiscord', 'triad', 'Bardasht Mashin', ESX.GetPlayerData().name.." Mashine "..data.current.label.." Spawn Kard", 'user', GetPlayerServerId(PlayerId()), true, false)
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

function BossThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "triad")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Baaz Kardan Bossaction" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "triad")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Baaz Kardan Bossaction')
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
	local clothesI
    local Keys
    local clothes = RegisterPoint(Clothes, 5, true)
    clothes.set("Tag", "triad")
    clothes.set('InArea', function ()
        DrawMarker(31, Clothes.x,Clothes.y,Clothes.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,Clothes)
    end)
    clothes.set('InAreaOnce', function ()
        clothesI = RegisterPoint(Clothes, 1.5, true)
        clothesI.set("Tag", "triad")
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
	local storageI
    local PKeys
    local storage = RegisterPoint(Storage, 5, true)
    storage.set("Tag", "triad")
    storage.set('InArea', function ()
        DrawMarker(42, Storage.x,Storage.y,Storage.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Dastresi Be Storage" ,Storage)
    end)
    storage.set('InAreaOnce', function ()
        storageI = RegisterPoint(Storage, 1.5, true)
        storageI.set("Tag", "triad")
        storageI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Dastresi Be Storage')
			PKeys = RegisterKey('E', false, function()
				UnregisterKey(PKeys)
				OpenActionsMenu()
            end)
        end, function()
			Hint:Delete()
			PKeys = UnregisterKey(PKeys)
		end)
    end, function ()
        if storageI then
            storageI.remove()
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

function OpenEmployee()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'triad', function(data, menu)
		menu.close()
	end, { wash = false, withdraw = true })
end

function OpenActionsMenu()
	local elements = {
		{label = 'Put Stock', value = 'put_stock'},
		{label = 'Get Stock', value = 'get_stock'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_actions', {
		title    = "Triad Club",
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
	ESX.TriggerServerCallback('esx_triad:getStockItems', function(items)
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
				title    = "Triad Club",
				align    = 'center',
				elements = elements
			}, function(data, menu)
				local itemName = data.current.value
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = 'Tedad'
				}, function(data2, menu2)
					local count = tonumber(data2.value)
					if count == nil then
						ESX.ShowNotification('Meghdar ~r~Eshtebah~s~ Ast!')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_triad:getStockItem', itemName, count)
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
					TriggerServerEvent('esx_triad:putStockItems', itemName, count)
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
		{label = "Espresso Martini", value = "espressomartini"},
        {label = "Magic Drink", value = "magicdrink"},
        {label = "Choclate Bubble Tea", value = "bubbletea"},
		{label = "Majun", value = "majon"},
		{label = "Whiskey Cola", value = "whiskeycola"},
		{label = "Zereshk Polo Ba Morgh", value = "zereshk"},
		{label = "Kabab Koobide", value = "koobide"},
		{label = "Jooje Kabab", value = "jooje"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = "Triad Club",
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error") end
        SetEntityCoords(PlayerPedId(), -829.45,-728.61,27.06)
        SetEntityHeading(PlayerPedId(), 4.29)
        ExecuteCommand("e petting")
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
				if data.current.value == "koobide" or data.current.value == "jooje" or data.current.value == "zereshk" then
					TriggerServerEvent("esx_triad:AddItem", data.current.value)
				else
					TriggerServerEvent("esx_triad:AddCraftItem", data.current.value)
				end
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
        {label = "Hotchoclate", value = "hotchoc"},
        {label = "Zeytoon", value = "zeytoon"},
		{label = "Ice", value = "yakh"},
		{label = "Vodka", value = "vodka"},
        {label = "Coca Cola", value = "cocacola"},
		{label = "Cake Shokolati", value = "cakechoc"},
		{label = "Limoo", value = "limo"},
		{label = "Croissant", value = "crossan"},
		{label = "Cup Cake", value = "cupcake"},
		{label = "Martini", value = "martini"},
		{label = "Espresso", value = "espresso"},
		{label = "Vodka", value = "vodka"},
		{label = "Whiskey", value = "whiskey"},
		{label = "Coca Cola", value = "cocacola"},
		{label = "Red Bull", value = "redbull"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = "Triad Club",
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Bardasht In Item Ra Nadarid", "error") end
		TriggerServerEvent("esx_triad:AddItem", data.current.value)
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
	  title    = '"Triad Club"',
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
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***"Triad Club"***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_weazel', "Triad Club", amount)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

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