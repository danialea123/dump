---@diagnostic disable: undefined-global, missing-parameter, undefined-field, need-check-nil, param-type-mismatch
local PlayerData = {}
local Blip = {}
local ESX = nil
local CanPressKey = false
local BossCoord = vector3(128.46,-1778.14,29.73)
local Storage = vector3(132.56,-1778.19,29.73)
local Clothes = vector3(127.54,-1780.98,29.73)
local Vehicle = vector3(121.58,-1765.24,29.34)

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(900)
	end

	PlayerData = ESX.GetPlayerData()

	if PlayerData.job.name == "blackmarket" then
		AreYouOK()
		ImNotOk()
		OtherStuff()
	end
end)

local allpos = {
	vector3(-246.5934, -2370.33, 9.312866),
	vector3(-245.433, -2373.626, 9.312866),
	vector3(-246.7648, -2361.626, 9.312866),
	vector3(-245.4066, -2358.501, 9.312866),
	vector3(-95.35384, -2362.695, 14.28357),
	vector3(-96.31648, -2356.404, 14.28357),
	vector3(-183.244, -2363.552, 9.312866),
	vector3(-181.1868, -2370.092, 9.312866),
	vector3(-198.4483, -2352.923, 9.312866),
	vector3(-204.6725, -2352.91, 9.312866),
	vector3(-207.7714, -2377.305, 9.312866),
}

-- Citizen.CreateThread(function()
--     Blips = AddBlipForCoord(Clothes.x, Clothes.y, Clothes.z)
--     SetBlipSprite(Blips, 628)
-- 	SetBlipColour(Blips, 81)
--     SetBlipScale(Blips, 0.6)
--     SetBlipAsShortRange(Blips, true)
--     BeginTextCommandSetBlipName('STRING')
--     AddTextComponentString("Semsari Ayande")
--     EndTextCommandSetBlipName(Blips)
-- end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	for k, v in pairs(Blip) do
		RemoveBlip(k)
	end
	exports.sr_main:RemoveByTag("BlackMarket")
	Citizen.Wait(1000)
	if PlayerData.job.name == "blackmarket" then
		AreYouOK()
		ImNotOk()
		OtherStuff()
	end
end)

function OtherStuff()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "BlackMarket")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Baaz Kardan Bossaction" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "BlackMarket")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Baaz Kardan Boss Action')
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
	local storageI
    local PKeys
    local storage = RegisterPoint(Storage, 5, true)
    storage.set("Tag", "BlackMarket")
    storage.set('InArea', function ()
        DrawMarker(42, Storage.x,Storage.y,Storage.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Dastresi Be Storage" ,Storage)
    end)
    storage.set('InAreaOnce', function ()
        storageI = RegisterPoint(Storage, 1.5, true)
        storageI.set("Tag", "BlackMarket")
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
	local clothesI
    local Keys
    local clothes = RegisterPoint(Clothes, 5, true)
    clothes.set("Tag", "BlackMarket")
    clothes.set('InArea', function ()
        DrawMarker(31, Clothes.x,Clothes.y,Clothes.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,Clothes)
    end)
    clothes.set('InAreaOnce', function ()
        clothesI = RegisterPoint(Clothes, 1.5, true)
        clothesI.set("Tag", "BlackMarket")
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
						{label = "Youga2", value = "youga2"},
						{label = "ratloader", value = "ratloader"},
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
							},  317.36, function(callback_vehicle)
								SetVehRadioStation(callback_vehicle, "OFF")
								ESX.CreateVehicleKey(callback_vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
								menu.close()
								--ESX.Game.SetVehicleProperties(callback_vehicle, props)
								TriggerServerEvent('DiscordBot:ToDiscord', 'blackmarket', 'Bardasht Mashin', ESX.GetPlayerData().name.." Mashine "..data.current.label.." Spawn Kard", 'user', GetPlayerServerId(PlayerId()), true, false)
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

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BlackMarket_actions', {
		title    = 'BlackMarket',
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
	ESX.TriggerServerCallback('esx_BlackMarket:getStockItems', function(items)
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
				title    = 'BlackMarket Stock',
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
						TriggerServerEvent('esx_BlackMarket:getStockItem', itemName, count)
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
					TriggerServerEvent('esx_BlackMarket:putStockItems', itemName, count)
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

function OpenEmployee()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'blackmarket', function(data, menu)
		menu.close()
	end, { wash = false, withdraw = true })
end

function AreYouOK()
	Citizen.CreateThread(function ()
		for k, v in pairs(allpos) do
			Blip[k]       = AddBlipForCoord(v)
			SetBlipSprite (Blip[k], 615)
			SetBlipDisplay(Blip[k], 4)
			SetBlipScale  (Blip[k], 0.6)
			SetBlipColour (Blip[k], 41)
			SetBlipAsShortRange(Blip[k], true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("BarDashtan Item")
			EndTextCommandSetBlipName(Blip[k])
		end
		local c = vector3(130.23,-1775.42,29.73)
		while PlayerData.job.name == "blackmarket" do
			Citizen.Wait(2)
			local Sleep = true
			local coord = GetEntityCoords(PlayerPedId())
			if #(coord - c) <= 2.0 then
				Sleep = false
				DrawMarker(22,c, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255,0,0, 100, false, false, 2,false, nil, false)
				ESX.ShowHelpNotification("~INPUT_CONTEXT~ To Open Menu")
				CanPressKey = true
			end
			if Sleep then CanPressKey = false Citizen.Wait(710) end
		end
	end)
end

AddEventHandler("onKeyDown", function(key)
	if key == "e" then
		if CanPressKey then
			SetDisplay(true)
		end
	end
end)

RegisterNUICallback('1', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("net_cracker") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "net_cracker")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('2', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("c4_bank") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "c4_bank")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('3', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("blowtorch") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "blowtorch")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('4', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("jewelryhack") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "jewelryhack") 
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('5', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("hostagekit") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "hostagekit")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('6', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("mythic") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "mythic")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('7', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("lockpick") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "lockpick")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('8', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("gpsdetector") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "lockpick")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('9', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("gpspanel") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "gpspanel")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
	end
end)

RegisterNUICallback('10', function(data, cb)
	SetDisplay(false)
  	cb('ok')
	if CanCraft("cargps") then
		TriggerServerEvent("esx_blackmarket:AddCraftItem", "cargps")
	else
		ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error")
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

RegisterNUICallback('fechar', function(data, cb)
	SetDisplay(false)
  	cb('ok')
end)

function SetDisplay(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        ativa = bool,
    })
end

local spam =  false

function ImNotOk()
	CreateThread(function()
		while PlayerData.job.name == "blackmarket" do
    	Citizen.Wait(2)
		local coord = GetEntityCoords(PlayerPedId())
		local good = true
    		for k,v in pairs(allpos)do  
    			if #(coord - v) < 3 then
					good = false
					DrawMarker(20,v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255,0,0, 100, false, false, 2,false, nil, false)
					ESX.ShowHelpNotification("~INPUT_CONTEXT~ Baray Gashtan")
					if IsControlJustPressed(0,38) and not spam then 
						spam = true
						ExecuteCommand("e petting")
						TriggerEvent("mythic_progbar:client:progress", {
							name = "process_itemsrech",
							duration = 15000,
							label ="Dar Hal Gashtan",
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
						},})
						SetTimeout(15000,function()
							TriggerServerEvent("GiveitemRandom")
							spam = false
						end)
						break
					end
				end
			end
			if good then Citizen.Wait(710) end
		end
	end)
end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end