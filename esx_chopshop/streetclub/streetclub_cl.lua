---@diagnostic disable: undefined-global, missing-parameter, undefined-field
local OrderCoord = vector3(244.05,-3158.13,-0.19)
local BossCoord = vector3(244.02,-3151.02,3.33)
local OtherCoord = vector3(251.6,-3157.22,-0.19)
local Clothes = vector3(254.52,-3151.26,-0.19)
local Vehicle = vector4(181.83,-3181.79,5.67,358.84)
local Storage = vector3(260.89,-3158.96,-0.19)
local Blip

Citizen.CreateThread(function()
	while ESX == nil do 
	    Citizen.Wait(0) 
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    GhabzKey = UnregisterKey(GhabzKey)
    exports.sr_main:RemoveByTag("StreetClub")

	PlayerData = ESX.GetPlayerData()

    if PlayerData.job.name == "streetclub" then
        WorkThread()
        BossThread()
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    GhabzKey = UnregisterKey(GhabzKey)
    exports.sr_main:RemoveByTag("StreetClub")
    if PlayerData.job.name == "streetclub" then
        WorkThread()
        BossThread()
    end
end)

Citizen.CreateThread(function()
    Blip = AddBlipForCoord(254.52,-3151.26,-0.19)
    SetBlipSprite(Blip, 121)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Sicily Club")
    EndTextCommandSetBlipName(Blip)
end)

function WorkThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(OrderCoord, 5, true)
    DMarker.set("Tag", "StreetClub")
	DMarker.set('InArea', function()
		DrawMarker(21, OrderCoord.x, OrderCoord.y, OrderCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Sabt Sefaresh" ,OrderCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(OrderCoord, 0.5, true)
        DInMarker.set("Tag", "StreetClub")
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
	local SDInMarker
	local SKey
	local SDMarker = RegisterPoint(OtherCoord, 5, true)
    SDMarker.set("Tag", "StreetClub")
	SDMarker.set('InArea', function()
		DrawMarker(22, OtherCoord.x, OtherCoord.y, OtherCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan Item" ,OtherCoord)
	end)
	SDMarker.set('InAreaOnce', function()
		SDInMarker = RegisterPoint(OtherCoord, 0.5, true)
        SDInMarker.set("Tag", "StreetClub")
		SDInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gereftan Item Ha')
			SKey = RegisterKey('E', false, function()
                SKey = UnregisterKey(SKey)
                OpenBuyMenu2()
            end)
		end, function()
			Hint:Delete()
			SKey = UnregisterKey(SKey)
            ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if SDInMarker then
			SDInMarker = SDInMarker.remove()
		end
	end)
    GhabzKey = RegisterKey("F7", false, function()
        OpenActionsMenuGhabz()
    end)
	local vehI
    local vehKey
    local veh = RegisterPoint(Vehicle, 5, true)
    veh.set("Tag", "BlackMarket")
    veh.set('InArea', function ()
        DrawMarker(36, Vehicle.x,Vehicle.y,Vehicle.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan/Gozashtan Mashin" ,Vehicle)
    end)
    veh.set('InAreaOnce', function ()
        vehI = RegisterPoint(Vehicle, 1.5, true)
        vehI.set("Tag", "BlackMarket")
        vehI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gozashtan/Gereftan Mashin')
			vehKey = RegisterKey('E', false, function()
                if IsPedInAnyVehicle(PlayerPedId()) then
                    vehKey = UnregisterKey(vehKey)
                    ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                else
					ESX.UI.Menu.CloseAll()
					local elem = {
						{label = "Patriot2", value = "patriot2"},
						{label = "Stretch", value = "stretch"},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_m', {
						title    = 'Spawn Car',
						align    = 'center',
						elements = elem
					}, function(data, menu)
						local coords = Vehicle
						local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
						if not DoesEntityExist(shokol) then
							vehKey = UnregisterKey(vehKey)
							ESX.Game.SpawnVehicle(data.current.value, {
								x = coords.x,
								y = coords.y,
								z = coords.z
							},  358.84, function(callback_vehicle)
								SetVehRadioStation(callback_vehicle, "OFF")
								ESX.CreateVehicleKey(callback_vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
								menu.close()
								--ESX.Game.SetVehicleProperties(callback_vehicle, props)
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
			vehKey = UnregisterKey(vehKey)
		end)
    end, function ()
        if vehI then
            vehI.remove()
        end
    end)
	local clothesI
    local Keys
    local clothes = RegisterPoint(Clothes, 5, true)
    clothes.set("Tag", "StreetClub")
    clothes.set('InArea', function ()
        DrawMarker(31, Clothes.x,Clothes.y,Clothes.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,Clothes)
    end)
    clothes.set('InAreaOnce', function ()
        clothesI = RegisterPoint(Clothes, 1.5, true)
        clothesI.set("Tag", "StreetClub")
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
    storage.set("Tag", "StreetClub")
    storage.set('InArea', function ()
        DrawMarker(42, Storage.x,Storage.y,Storage.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        --ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Dastresi Be Storage" ,Storage)
    end)
    storage.set('InAreaOnce', function ()
        storageI = RegisterPoint(Storage, 1.5, true)
        storageI.set("Tag", "StreetClub")
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

function BossThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "StreetClub")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        --ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Modiriat Member Ha" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "StreetClub")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Modiriat Member Ha')
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
	TriggerEvent('esx_society:openBossMenu', 'streetclub', function(data, menu)
		menu.close()
	end, { wash = false, withdraw = true })
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

function OpenActionsMenu()
	local elements = {
		{label = 'Put Stock', value = 'put_stock'},
		{label = 'Get Stock', value = 'get_stock'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'StreetClub_actions', {
		title    = 'StreetClub',
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
	ESX.TriggerServerCallback('esx_StreetClub:getStockItems', function(items)
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
				title    = 'StreetClub Stock',
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
						TriggerServerEvent('esx_StreetClub:getStockItem', itemName, count)
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
					TriggerServerEvent('esx_StreetClub:putStockItems', itemName, count)
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

function OpenBuyMenu2()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Chocolate Cake", value = "cakechoc"},
        {label = "Croissant", value = "crossan"},
        {label = "Cup Cake", value = "cupcake"},
        {label = "Donut", value = "donut"},
        {label = "Kalbas", value = "kalbas"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'StreetClub_order', {
		title    = 'StreetClub',
		align    = 'center',
		elements = elem
	}, function(data, menu)
        -- SetEntityCoords(PlayerPedId(), 129.46,-1281.72,28.27)
        -- SetEntityHeading(PlayerPedId(), 300.94)
        ExecuteCommand("e mechanic4")
        exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
        TriggerEvent("mythic_progbar:client:progress",{
            name = "unloc",
            duration = 7000,
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
                TriggerServerEvent("esx_StreetClub:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
        --TriggerEvent("InteractSound_CL:PlayOnOne", "StreetClub", 0.3)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Espresso", value = "espresso"},
        {label = "MilkShake", value = "milkshake"},
        {label = "Mohito", value = "mohito"},
		{label = "Vodka Redbull", value = "vodkaredbull"},
		{label = "Vodka Energy", value = "vodkaenergy"},
		{label = "Vodka", value = "vodka"},
		{label = "Pool Cocktail", value = "poolcocktail"},
		{label = "Bramble", value = "bramble"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'StreetClub_order', {
		title    = 'StreetClub',
		align    = 'center',
		elements = elem
	}, function(data, menu)
        if data.current.value == "donut" or data.current.value == "cupcake" or data.current.value == "crossan" or data.current.value == "cakechoc" then return TriggerServerEvent("esx_StreetClub:AddItem", data.current.value) end
        -- SetEntityCoords(PlayerPedId(), 129.53,-1284.14,28.27)
        -- SetEntityHeading(PlayerPedId(), 118.52)
        ExecuteCommand("e mechanic4")
        exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
        TriggerEvent("mythic_progbar:client:progress",{
            name = "unloc",
            duration = 7000,
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
                TriggerServerEvent("esx_StreetClub:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
        TriggerEvent("InteractSound_CL:PlayOnOne", "starbucks", 0.3)
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
	  title    = 'StreetClub',
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
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***StartBucks***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_weazel', 'StreetClub', amount)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

local Configs = {}

Configs.VStripDancerPeds = {
    { model="s_f_y_stripperlite", x=112.32, y = -1287.27, z = 27.46, a = 305.17, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
    { model="csb_stripper_01", x=108.43, y = -1289.66, z = 27.86, a = 302.89, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
    { model="csb_stripper_02", x=103.92, y = -1294.45, z = 28.26, a = 300.29, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
	{ model="s_f_y_stripper_02", x=101.99, y = -1291.03,z = 28.26, a = 300.72, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
	{ model="s_f_y_stripperlite", x=111.42, y = -1304.12, z = 28.02, a = 295.05, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
}

-- START DANCERS
local VStripPeds, VNightClubPeds = {}, {}
local function TriggerVStripDancers()
    -- Dancers
    for k,v in ipairs(Configs.VStripDancerPeds) do
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

local togg = false

RegisterNetEvent('esx_streetclub:ToggleStripDancers')
AddEventHandler('esx_streetclub:ToggleStripDancers', function(toggle)
	togg = toggle
	if toggle then
		local coord = GetEntityCoords(PlayerPedId())
		local c = vector3(112.32, -1287.27, 27.46)
		while (#(coord - c) >= 60.0 and togg) do
			coord = GetEntityCoords(PlayerPedId())
			Citizen.Wait(5000)
		end
        CreateThread(TriggerVStripDancers)
    else
        for k,v in pairs(VStripPeds) do
            DeletePed(v)
        end
        VStripPeds = {}
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
	TriggerServerEvent("esx_streetclub:checkDancerState")
end)

local TimeOut = 0

RegisterCommand("streetdancer", function()
	if PlayerData.job.name == "streetclub" then
		if GetGameTimer() - TimeOut > 5000 then
			TriggerServerEvent("esx_streetclub:changeDancerState")
			TimeOut = GetGameTimer()
			ESX.Alert("Taghiraat Emaal Shod", "check")
		else
			ESX.Alert("Spam Nakonid", "info")
		end
	end
end)