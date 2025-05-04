---@diagnostic disable: undefined-global, undefined-field
local OrderCoord = vector3(-590.5,-1063.01,22.36)
local BossCoord = vector3(-579.05,-1060.55,26.61)
local OtherCoord = vector3(-590.15,-1058.58,22.34)
local Blip
local Worker = false
local clothes = json.decode('{"pants_1": 62,"bproof_1": 0,"bproof_2": 0,"mask_1": 0,"chain_1": 0,"shoes_1": 35,"torso_1": 435,"pants_2": 0,"tshirt_2": 0,"torso_2": 11,"shoes_2": 7,"helmet_2": 0,"helmet_1": -1,"arms": 24,"tshirt_1": 15,"mask_2": 0,"chain_2": 0}')
local fclothes = json.decode('{"pants_1": 6,"bproof_1": 0,"bproof_2": 0,"mask_1": 0,"chain_1": 0,"shoes_1": 19,"torso_1": 7,"pants_2": 0,"tshirt_2": 3,"torso_2": 15,"shoes_2": 3,"helmet_2": 0,"helmet_1": -1,"arms": 26,"tshirt_1": 179,"mask_2": 0,"chain_2": 0}')

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(500)
		--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end
	while ESX.GetPlayerData().gang == nil do 
		Citizen.Wait(500)
	end
	while not PlayerData do 
		Citizen.Wait(500)
	end
	GhabzKey = UnregisterKey(GhabzKey)
	exports.sr_main:RemoveByTag("Cat Cafe")
	Worker = false
	if PlayerData.job.name == "catcafe" then
		GhabzKey = UnregisterKey(GhabzKey)
		exports.sr_main:RemoveByTag("Cat Cafe")
		Citizen.Wait(750)
		Worker = true
		WorkThread()
		BossThread()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	GhabzKey = UnregisterKey(GhabzKey)
	Worker = false
	exports.sr_main:RemoveByTag("Cat Cafe")
	if PlayerData.job.name == "catcafe" then
		Worker = true
		WorkThread()
		BossThread()
	end
end)

Citizen.CreateThread(function()
    Blip = AddBlipForCoord(-590.5,-1063.01,22.36)
    SetBlipSprite(Blip, 614)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Cat Cafe")
    EndTextCommandSetBlipName(Blip)
end)

function WorkThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(OrderCoord, 5, true)
    DMarker.set("Tag", "Cat Cafe")
	DMarker.set('InArea', function()
		DrawMarker(21, OrderCoord.x, OrderCoord.y, OrderCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Sabt Sefaresh" ,OrderCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(OrderCoord, 0.5, true)
        DInMarker.set("Tag", "Cat Cafe")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Sabt Sefaresh')
			Key = RegisterKey('E', false, function()
                Key = UnregisterKey(Key)
                OpenBuyMenu3()
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
    SDMarker.set("Tag", "Starbucks")
	SDMarker.set('InArea', function()
		DrawMarker(22, OtherCoord.x, OtherCoord.y, OtherCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, true, true, 2, false, false, false, false)
        --ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Sabt Sefaresh" ,OtherCoord)
	end)
	SDMarker.set('InAreaOnce', function()
		SDInMarker = RegisterPoint(OtherCoord, 0.5, true)
        SDInMarker.set("Tag", "Starbucks")
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
    local veh = RegisterPoint(vector3(-613.5,-1062.73,21.79), 5, true)
    veh.set("Tag", "BeanCafe")
    veh.set('InArea', function ()
        DrawMarker(36, -613.5,-1062.73,21.79, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan/Gozashtan Mashin" ,vector3(-613.5,-1062.73,21.79))
    end)
    veh.set('InAreaOnce', function ()
        vehI = RegisterPoint(vector3(-613.5,-1062.73,21.79), 1.5, true)
        vehI.set("Tag", "BeanCafe")
        vehI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Gozashtan/Gereftan Mashin')
			vehKey = RegisterKey('E', false, function()
                if IsPedInAnyVehicle(PlayerPedId()) then
                    vehKey = UnregisterKey(vehKey)
                    ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                else
                    local coords = vector3(-613.5,-1062.73,21.79)
                    local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                    if not DoesEntityExist(shokol) then
                        vehKey = UnregisterKey(vehKey)
                        ESX.Game.SpawnVehicle("imperial3", {
                            x = coords.x,
                            y = coords.y,
                            z = coords.z
                        },  300.92, function(callback_vehicle)
                            SetVehRadioStation(callback_vehicle, "OFF")
							ESX.CreateVehicleKey(callback_vehicle)
                            TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
							TriggerServerEvent('DiscordBot:ToDiscord', 'catcafe', 'Bardasht Mashin', ESX.GetPlayerData().name.." Mashine Imperial 3 Spawn Kard", 'user', GetPlayerServerId(PlayerId()), true, false)
                        end)
                    else
                        ESX.Alert('Mahale Spawn mashin ro Khali konid', "error")
                    end
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
    local clothes = RegisterPoint(vector3(-586.77,-1050.06,22.34), 5, true)
    clothes.set("Tag", "Cat Cafe")
    clothes.set('InArea', function ()
        DrawMarker(31, -586.83,-1049.98,22.34, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,vector3(-586.77,-1050.06,22.34))
    end)
    clothes.set('InAreaOnce', function ()
        clothesI = RegisterPoint(vector3(-586.77,-1050.06,22.34), 1.5, true)
        clothesI.set("Tag", "Cat Cafe")
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
    local storage = RegisterPoint(vector3(-597.61,-1067.04,22.34), 5, true)
    storage.set("Tag", "Cat Cafe")
    storage.set('InArea', function ()
        DrawMarker(42, -597.61,-1067.04,22.34, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Dastresi Be Storage" ,vector3(-597.61,-1067.04,22.34))
    end)
    storage.set('InAreaOnce', function ()
        storageI = RegisterPoint(vector3(-597.61,-1067.04,22.34), 1.5, true)
        storageI.set("Tag", "Cat Cafe")
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

function BossThread()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "Cat Cafe")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        --ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Modiriat Member Ha" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "Cat Cafe")
		DInMarker.set('InAreaOnce', function()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Baz Kardan Boss Action')
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
	TriggerEvent('esx_society:openBossMenu', 'catcafe', function(data, menu)
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
		title    = "Cat Cafe",
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
				title    ="Cat Cafe Locker",
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
						TriggerServerEvent('esx_catCafe:getStockItem', itemName, count)
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
					TriggerServerEvent('esx_catCafe:putStockItems', itemName, count)
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
		{label = "Cat Apple Juice", value = "catapplejuice"},
		{label = "Cat Grape Juice", value = "catgrapejuice"},
		{label = "Cat Donut", value = "catdonut"},
		{label = "Cat Lemonade", value = "catlemonade"},
		{label = "Ice Cream 1", value = "icecreamcat1"},
		{label = "Ice Cream 2", value = "icecreamcat2"},
		{label = "Ice Cream 3", value = "icecreamcat3"},
		{label = "Cat Latte", value = "catlatte"},
		{label = "Moochi", value = "moochi"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = "Cat Cafe",
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error") end
        --if data.current.value == "baghlava" or data.current.value == "strawberry" then return TriggerServerEvent("esx_catCafe:AddItem", data.current.value) end
        SetEntityCoords(PlayerPedId(), -590.03,-1058.56,21.34)
        SetEntityHeading(PlayerPedId(), 87.67)
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
                TriggerServerEvent("esx_catCafe:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
        --TriggerEvent("InteractSound_CL:PlayOnOne", "starbucks", 0.3)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBuyMenu3()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Cat Rice", value = "catrice"},
        {label = "Cat Pizza", value = "catpizza"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
		title    = "Cat Cafe",
		align    = 'center',
		elements = elem
	}, function(data, menu)
		if not CanCraft(data.current.value) then return ESX.Alert("Shoma Dastresi Craft In Item Ra Nadarid", "error") end
        --if data.current.value == "baghlava" or data.current.value == "strawberry" then return TriggerServerEvent("esx_catCafe:AddItem", data.current.value) end
        SetEntityCoords(PlayerPedId(), -590.34,-1063.05,22.36)
        SetEntityHeading(PlayerPedId(), 91.3)
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
                TriggerServerEvent("esx_catCafe:AddItem", data.current.value)
                ClearPedTasks(PlayerPedId())
            end
        end)
        TriggerEvent("InteractSound_CL:PlayOnOne", "knifeboard", 0.3)
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
	  title    = "Cat Cafe",
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
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Cat Cafe***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_catcafe', "Cat Cafe", amount)
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