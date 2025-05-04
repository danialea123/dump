---@diagnostic disable: undefined-field, lowercase-global
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
    exports.sr_main:RemoveByTag("hookahEmployee")
    isWorker = false
	if PlayerData.job.name == "artist" then
        isWorker = true
        CreatePoint()
        Masalar()
        Other()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    GhabzKey = UnregisterKey(GhabzKey)
    exports.sr_main:RemoveByTag("hookahEmployee")
    isWorker = false
	if PlayerData.job.name == "artist" then
        isWorker = true
        CreatePoint()
        Masalar()
        Other()
	end
end)

hasHookah = false
hasEmber = false
Hookah = nil
isWorker = false
Ember = nil
Loole = nil
isSmoking = false
Tobacoo = {
    ["2sib"] = "Tanbacoo 2 Sib",
    ["blueberry"] = "Tanbacoo BlueBerry",
    ["lemon"] = "Tanbacoo Limoo",
    ["porteghal"] = "Tanbacoo Porteghal Khame"
}

exports("doesHaveEmber", function()
    return hasEmber
end)

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function Other()
    local vehI
    local Keys
    local veh = RegisterPoint(vector3(80.06,226.38,108.53), 5, true)
    veh.set("Tag", "hookahEmployee")
    veh.set('InArea', function ()
        DrawMarker(36, 80.06,226.38,108.53, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Gereftan/Gozashtan Mashin" ,vector3(80.06,226.38,108.53))
    end)
    veh.set('InAreaOnce', function ()
        vehI = RegisterPoint(vector3(80.06,226.38,108.53), 1.5, true)
        vehI.set("Tag", "hookahEmployee")
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
						{label = "Burrito 3", value = "burrito3"},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_order', {
						title    = 'Spawn Car',
						align    = 'center',
						elements = elem
					}, function(data, menu)
						local coords = vector3(80.06,226.38,108.53)
						local shokol = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
						if not DoesEntityExist(shokol) then
							Keys = UnregisterKey(Keys)
							ESX.Game.SpawnVehicle(data.current.value, {
								x = coords.x,
								y = coords.y,
								z = coords.z
							},  251.41, function(callback_vehicle)
								SetVehRadioStation(callback_vehicle, "OFF")
								ESX.CreateVehicleKey(callback_vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
								menu.close()
								--ESX.Game.SetVehicleProperties(callback_vehicle, props)
                                TriggerServerEvent('DiscordBot:ToDiscord', 'artist', 'Bardasht Mashin', ESX.GetPlayerData().name.." Mashine "..data.current.label.." Spawn Kard", 'user', GetPlayerServerId(PlayerId()), true, false)
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

function Masalar()
    Citizen.CreateThread(function()
        for k, v in pairs(Config.Masalar) do 
            local Coord = Config.Masalar[k].coords
            Config.Masalar[k].Point = RegisterPoint(Coord, 2, true)
            Config.Masalar[k].Point.set("Tag", "hookahEmployee")
            Config.Masalar[k].Point.set("InArea", function()
                if not Config.Masalar[k].alreadyHaveHookah then
                    if(hasHookah)then
                        local text = '[E] Gozashtan Ghelyion'
                        DrawText3D(Config.Masalar[k].coords, text, 0.55, 1.5)
                        if #(GetEntityCoords(PlayerPedId()) - Config.Masalar[k].coords) < 1.2 then
                            ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Gozashtan Ghelyion')
                            if IsControlJustReleased(0, 38) then
                                Citizen.Wait(math.random(150, 600))
                                ESX.Game.DeleteObject(Hookah)
                                hasHookah = false
                                TriggerServerEvent("esx_hookah:addHookah", k)
                            end
                        end
                    end
                else
                    if not hasHookah then
                        local text = '[E] Hazf Ghelyion | [G] Smoke | [H] Tanbacoo | [K] Zoghal | Zoghal: ['..Config.Masalar[k].Ember.."] | Tanbacoo: "..Config.Masalar[k].Tanbacoo
                        if isSmoking then
                            text = '[G] Stop Smoking... | Meghdar Zoghal: '..Config.Masalar[k].Ember
                        end
                        DrawText3D(Config.Masalar[k].coords, text, 0.55, 1.5)
                        if #(GetEntityCoords(PlayerPedId()) - Config.Masalar[k].coords) < 2.5 then
                            if IsControlJustReleased(0, 38) then
                                if not hasEmber then
                                    Citizen.Wait(math.random(150, 600))
                                    TriggerServerEvent("esx_hookah:removeHookah", k)
                                    AttachHookah()
                                else
                                    ESX.Alert("Dast Shoma Por Ast", "error")
                                end
                            elseif IsControlJustReleased(0, 311) then
                                if hasEmber then
                                    ClearPedTasks(PlayerPedId())
                                    Panim()
                                    hasEmber = false
                                    exports.essentialmode:DisableControl(false)
                                    TriggerServerEvent("esx_hookah:addEmber", k)
                                else
                                    ESX.Alert("Shoma Zoghal Hamrah Khod Nadarid", "error")
                                end
                            elseif IsControlJustReleased(0, 47) then
                                if not isSmoking then
                                    if Config.Masalar[k].Ember > 0 then
                                        if Config.Masalar[k].Tanbacoo > 0 then
                                            Smoke(k)
                                        else
                                            ESX.Alert("In Ghelyion Tanbacoo Nadarad", "error")
                                        end
                                    else
                                        ESX.Alert("In Ghelyion Zoghal Kafi Nadarad", "error")
                                    end
                                else
                                    isSmoking = false
                                    ClearPedTasks(PlayerPedId())
                                    Delete()
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    exports.essentialmode:DisableControl(false)
                                end
                            elseif IsControlJustReleased(0, 74) then
                                if Config.Masalar[k].Tanbacoo <= 0 then
                                    Panim()
                                    local mod = GetTobacooModel()
                                    if mod then 
                                        TriggerServerEvent("esx_hookah:addTobacoo", k, mod)
                                    else
                                        ESX.Alert("Shoma Tanbacoo Nadarid", "error")
                                    end
                                else
                                    ESX.Alert("In Ghelyion Tanbacoo Darad!", "error")
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

function GetTobacooModel()
    local model = nil
    for k, v in pairs(Tobacoo) do 
        ESX.DoesHaveItem(k, 1, function()
            model = k
        end, v)
    end
    Citizen.Wait(750)
    return model
end

function OpenActionsMenuGhabz()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_weazel_actions', {
	  title    = 'Cafe Artist',
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
					TriggerServerEvent('DiscordBot:ToDiscord', 'jobsfine', 'JOBS FINE LOG', '***Cafe Artist***\n```css\n[FROM]: ('..GetPlayerServerId(PlayerId())..') '..GetPlayerName(PlayerId())..'\n[TO]: ('..GetPlayerServerId(target)..') '..GetPlayerName(target)..'\n[AMOUNT]: '..ESX.Math.GroupDigits(amount)..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_weazel', 'Cafe Artist', amount)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function CreatePoint()
    GhabzKey = RegisterKey("F7", false, function()
        OpenActionsMenuGhabz()
    end)
    local Point = RegisterPoint(Config.hookahYap.coords, 20, true)
    local Interact = RegisterPoint(vector3(100.8659, 199.622, 107.3561), 5, true)
    Interact.set("Tag", "hookahEmployee")
    Point.set("Tag", "hookahEmployee")
    Interact.set("InArea", function()
        DrawMarker(1, vector3(100.8659, 199.622, 107.3561), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
        if #(GetEntityCoords(PlayerPedId()) - vector3(100.8659, 199.622, 107.3561)) < 1.2 then
            ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Tajhizat')
            if IsControlJustReleased(0, 38) then
                OpenBuyMenu()
            end
        end
    end)
    Interact.set("OutAreaOnce", function()
        ESX.UI.Menu.CloseAll()
    end)
    Point.set("OutAreaOnce", function()
        if hasHookah then 
            ESX.Game.DeleteObject(Hookah)
            ClearPedTasks(PlayerPedId())
            Hookah = nil
            exports.essentialmode:DisableControl(false)
            ESX.Alert("Shoma Az Gheliony Kharej Shodid", "info")
        end
        if hasEmber then
            ESX.Game.DeleteObject(Ember)
            ClearPedTasks(PlayerPedId())
            Ember = nil
            exports.essentialmode:DisableControl(false)
            ESX.Alert("Shoma Az Gheliony Kharej Shodid", "info")
        end
    end)
    Point.set("InArea", function()
        local text = '[E] - Gereftan Ghelyion | [K] - Gereftan Zoghal'
        if(hasHookah)then
            text = '[E] - Hazf Ghelyion | [K] - Gereftan Zoghal'
        end
        if hasEmber then
            text = '[E] - Gereftan Ghelyion | [K] - Hazf Zoghal'
        end
        DrawText3D(Config.hookahYap.coords, text, 0.55, 1.5)
        --DrawMarker(1, Config.hookahYap.coords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
        if #(GetEntityCoords(PlayerPedId()) - Config.hookahYap.coords) < 1.2 then
            ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Ya Dokmeye ~INPUT_REPLAY_SHOWHOTKEY~ Baraye Daryaft Ghelyion - Zoghal')
            if IsControlJustReleased(0, 38) then
                if not hasEmber then
                    if not hasHookah then
                        AttachHookah()
                    else
                        ClearPedTasks(PlayerPedId())
                        Hookah = nil
                        hasHookah = false
                        exports.essentialmode:DisableControl(false)
                        Delete()
                    end
                else
                    ESX.Alert("Dast Shoma Por Ast", "error")
                end
            elseif IsControlJustReleased(0, 311) then
                if not hasHookah then
                    if not hasEmber then
                        AttachEmber()
                    else
                        ESX.Game.DeleteObject(Ember)
                        ClearPedTasks(PlayerPedId())
                        Ember = nil
                        hasEmber = false
                        exports.essentialmode:DisableControl(false)
                        Delete()
                    end
                else
                    ESX.Alert("Dast Shoma Por Ast", "error")
                end
            end
        end
    end)
end

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Zoghal", value = "ember"},
        {label = "Ab Porteghal", value = "abporteghal"},
        {label = "MilkShake", value = "milkshake"},
        {label = "Sigar Kaptan", value = "cigarett"},
        {label = "Bastani", value = "bastani"},
        {label = "Mohito", value = "mohito"},
        {label = "Waffle", value = "waffle"},
        {label = "Ghelyion", value = "hookah"},
    }
    for k, v in pairs(Tobacoo) do
        table.insert(elem, {label = v, value = k})
    end
    table.insert(elem, {label = "====================", value = nil})
    table.insert(elem, {label = "Anbar", value = "anbar"})
    table.insert(elem, {label = "Boss Action", value = "boss"})
    table.insert(elem, {label = "Taghir Lebas", value = "clothes"})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_tobacoo', {
		title    = 'Café Artist',
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
        local data = data.current.value
        if data and data == "anbar" then
            OpenActionsMenu()
            return
        end
        if data and data == "boss" then
            ESX.UI.Menu.CloseAll()
            TriggerEvent('esx_society:openBossMenu', 'artist', function(data, menu)
                menu.close()
            end, { wash = false, withdraw = true })
            return
        end
        if data and data == "clothes" then
            OpenClothes()
            return
        end
        if data then
            if CanCraft(data) then
                TriggerServerEvent("esx_hookah:AddTobacooItem", data)
            else
                ESX.Alert("Shoma Dastresi Bardasht In Item Ra Nadarid", "error")
            end
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
		title    = 'Cafe',
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
					TriggerServerEvent('esx_hookah:putStockItems', itemName, count)
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
				title    ="Artist Locker",
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
						TriggerServerEvent('esx_hookah:getStockItem', itemName, count)
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

function Panim()
    local ped = PlayerPedId()
    RequestAnimDict("misscarsteal3pullover")
    while not HasAnimDictLoaded("misscarsteal3pullover") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "misscarsteal3pullover", "pull_over_right", 2.0, 2.0, -1, 49, 0, false, false, false)
    Citizen.Wait(5500)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
    local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)
    if Ember then
	    AttachEntityToEntity(Ember, ped, boneIndex, 0.15,-0.10,0.0, -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
    end
    Citizen.Wait(1000)
    Delete()
    ClearPedTasks(PlayerPedId())
    Ember = nil
    hasEmber = false
end

function PutHookah(k)
    Config.Masalar[k].alreadyHaveHookah = true
    Config.Masalar[k].Obj = CreateObject(4037417364, Config.Masalar[k].coords, false, 0, false)
    local obj = Config.Masalar[k].Obj
	FreezeEntityPosition(obj, true)
    ClearPedTasks(PlayerPedId())
end

function RemoveHookah(k)
    SetEntityAsMissionEntity(Config.Masalar[k].Obj, true, true)
    ESX.Game.DeleteObject(Config.Masalar[k].Obj)
    Config.Masalar[k].Obj = nil
    Config.Masalar[k].alreadyHaveHookah = false
end

function Delete()
    for k, v in pairs(GetGamePool("CObject")) do
        if IsEntityAttached(v) then
            if GetEntityAttachedTo(v) == PlayerPedId() then
                ESX.Game.DeleteObject(v)
            end
        end
    end
end

function AttachEmber()
    hasEmber = true
	local hash = GetHashKey('v_corp_boxpaprfd')
	local ped = PlayerPedId()
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end
	Ember = CreateObject(hash, GetEntityCoords(PlayerPedId()),  true,  true, true)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(0)
    end
    UseParticleFxAsset("core")
    StartNetworkedParticleFxLoopedOnEntity("ent_anim_cig_smoke",Ember,0,0,0.1, 0,0,0, 3.0, 0,0,0)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
	local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)
	AttachEntityToEntity(Ember, ped, boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
end

RegisterNetEvent("esx_hookah:reduceEmber")
AddEventHandler("esx_hookah:reduceEmber", function(k)
    if not Config.Masalar[k] then return end
    Config.Masalar[k].Ember = Config.Masalar[k].Ember - 5
    Config.Masalar[k].Tanbacoo = Config.Masalar[k].Tanbacoo - 5
end)

RegisterNetEvent("esx_hookah:addTobacoo")
AddEventHandler("esx_hookah:addTobacoo", function(k)
    if not Config.Masalar[k] then return end
    Config.Masalar[k].Tanbacoo = 300
end)

function AttachHookah()
    Hookah = CreateObject(4037417364, 1, 1, 1, true, 0, true)
    PlaceObjectOnGroundProperly(Hookah)
    local boneIndex2 = GetPedBoneIndex(PlayerPedId(), 24818)
    anim()
    AttachEntityToEntity(Hookah, PlayerPedId(), boneIndex2, -0.15, 0.2, 0.18, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    hasHookah = true
    exports.essentialmode:DisableControl(true)
end

function anim()
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
end

DrawText3D = function(coords, text, size, font)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(vector - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry('STRING')
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(vector.xyz, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
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

function Poke(k)
    Citizen.CreateThread(function()
        local p_smoke_location = {
            20279,
        }
        local p_smoke_particle = "exp_grd_bzgas_smoke"
        local p_smoke_particle_asset = "core" 
        local hookCoord = vector3(105.99,203.77,108.37)
        local mycoord = GetEntityCoords(PlayerPedId())
        if #(mycoord - hookCoord) <= 50.0 then
            TriggerEvent('esx_Quest:point', 'Ghelion', nil, 1)
        end
        for _,bones in pairs(p_smoke_location) do
            createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, PlayerPedId(), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(PlayerPedId(), bones), 5.0, 0.0, 0.0, 0.0)
            while isSmoking and Config.Masalar[k].Ember > 0 and Config.Masalar[k].Point and Config.Masalar[k].Tanbacoo > 0 do
                TriggerServerEvent("esx_hookah:reduceEmber", k)
                TriggerEvent('esx_status:add', 'mental', 35000)
                Citizen.Wait(15000)
            end
            isSmoking = false
            FreezeEntityPosition(PlayerPedId(), false)
            Delete()
            StopParticleFxLooped(createdSmoke, 1)
            Wait(1000*2)
            RemoveParticleFxFromEntity(PlayerPedId())
            ClearPedTasks(PlayerPedId())
            break
        end
    end)
end

function Smoke(k)
    isSmoking = true
    anim()
    local playerPed  = PlayerPedId()
    local coords     = GetEntityCoords(playerPed)
    local boneIndex  = GetPedBoneIndex(playerPed, 12844)
    local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
    local model = GetHashKey('v_corp_lngestoolfd')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end
    --local bool, x, y = GetHudScreenPositionFromWorldPosition(Config.Masalar[k].coords.x, Config.Masalar[k].coords.y, Config.Masalar[k].coords.z)
    --local hed = GetHeadingFromVector_2d(x, y)
    --SetEntityHeading(PlayerPedId(), hed)
    FreezeEntityPosition(PlayerPedId(), true)
    exports.essentialmode:DisableControl(true)							
    Loole = CreateObject(model,  coords.x+0.5, coords.y+0.1, coords.z+0.4, true, false, true)
    AttachEntityToEntity(Loole, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)
    Poke(k)
end

RegisterNetEvent("esx_hookah:manageEmployee")
AddEventHandler("esx_hookah:manageEmployee", function(data)
    OpenBossMenu(data)
end)

RegisterNetEvent("esx_hookah:addEmber")
AddEventHandler("esx_hookah:addEmber", function(k)
    if not Config.Masalar[k] then return end
    Config.Masalar[k].Ember = 300
end)

RegisterNetEvent("esx_hookah:removeHookah")
AddEventHandler("esx_hookah:removeHookah", function(k)
    print(k)
    RemoveHookah(k)
    Config.Masalar[k].Ember = 0
    Config.Masalar[k].Tanbacoo = 0
    if Config.Masalar[k].Point then
        if not isWorker or Config.Masalar[k].Owner then
            Config.Masalar[k].Point = Config.Masalar[k].Point.remove()
            Config.Masalar[k].Point = nil
        end
    end
end)

RegisterNetEvent("esx_hookah:useHookah")
AddEventHandler("esx_hookah:useHookah", function()
    if not hasHookah and not hasEmber then
        AttachHookah()
        Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gharar Dadan Ghelyion")
        Key = RegisterKey("E", false, function()
            Key = UnregisterKey(Key)
            Hint:Delete()
            ClearPedTasks(PlayerPedId())
            Hookah = nil
            hasHookah = false
            exports.essentialmode:DisableControl(false)
            Delete()
            TriggerServerEvent("esx_hookah:setHookahOnGround")
        end)
    else
        ESX.Alert("Dastet Ye Ghelyion Dari Yeki Dige Ham Mikhay Biary? antar", "error")
    end
end)

RegisterNetEvent("esx_hookah:setHookahOnGround")
AddEventHandler("esx_hookah:setHookahOnGround", function(coord, src, id)
    local len = id
    Config.Masalar[len + 1] = {
        coords =  vector3(coord.x+0.25, coord.y, coord.z - 0.7),
        alreadyHaveHookah = false,
        Obj = nil,
        Ember = 0,
        Point = nil,
        Tanbacoo = 0,
        Owner = src
    }
    PutHookah(len+1)
    AddPoint(len+1)
end)

RegisterNetEvent("esx_hookah:addHookah")
AddEventHandler("esx_hookah:addHookah", function(k)
    PutHookah(k)
    if Config.Masalar[k].Point == nil then
        AddPoint(k)
    end
end)

function AddPoint(k)
    Citizen.CreateThread(function()
        local Coord = Config.Masalar[k].coords
        Config.Masalar[k].Point = RegisterPoint(Coord, 2, true)
        Config.Masalar[k].Point.set("InArea", function()
            if Config.Masalar[k].alreadyHaveHookah then
                local text = '[G] Smoke | [H] Tanbacoo | [K] Zoghal | Zoghal: '..Config.Masalar[k].Ember.." | Tanbacoo: "..Config.Masalar[k].Tanbacoo
                if isSmoking then
                    text = '[G] Stop Smoking... | Meghdar Zoghal: ['..Config.Masalar[k].Ember.."] | Tanbacoo: "..Config.Masalar[k].Tanbacoo
                end
                if Config.Masalar[k].Owner then
                    if Config.Masalar[k].Owner == GetPlayerServerId(PlayerId()) and not isSmoking then
                        text = '[E] Hazf Ghaleyion | [G] Smoke| [H] Tanbacoo | [K] Zoghal | Zoghal: ['..Config.Masalar[k].Ember.."] | Tanbacoo: "..Config.Masalar[k].Tanbacoo
                    end
                end
                DrawText3D(Config.Masalar[k].coords, text, 0.55, 1.5)
                if #(GetEntityCoords(PlayerPedId()) - Config.Masalar[k].coords) < 2.5 then
                    if IsControlJustReleased(0, 38) then
                        if Config.Masalar[k].Owner then
                            if Config.Masalar[k].Owner == GetPlayerServerId(PlayerId()) and not isSmoking or isWorker then
                                TriggerServerEvent("esx_hookah:removeHookah", k, Config.Masalar[k].Owner)
                            end
                        end
                    elseif IsControlJustReleased(0, 311) then
                        Citizen.Wait(math.random(150, 1100))
                        if not isSmoking then
                            ESX.DoesHaveItem("ember", 1, function()
                                TriggerServerEvent("esx_hookah:addEmber", k, Config.Masalar[k].Owner)
                            end, "Zoghal")
                        end
                    elseif IsControlJustReleased(0, 47) then
                        if not isSmoking then
                            if Config.Masalar[k].Ember > 0 then
                                if Config.Masalar[k].Tanbacoo > 0 then
                                    Smoke(k)
                                else
                                    ESX.Alert("In Ghelyion Tanbacoo Nadarad", "error")
                                end
                            else
                                ESX.Alert("In Ghelyion Zoghal Kafi Nadarad", "error")
                            end
                        else
                            isSmoking = false
                            ClearPedTasks(PlayerPedId())
                            Delete()
                            FreezeEntityPosition(PlayerPedId(), false)
                            exports.essentialmode:DisableControl(false)
                        end
                    elseif IsControlJustReleased(0, 74) then
                        if not isSmoking then
                            if Config.Masalar[k].Tanbacoo <= 0 then
                                Panim()
                                local mod = GetTobacooModel()
                                if mod then 
                                    TriggerServerEvent("esx_hookah:addTobacoo", k, mod)
                                else
                                    ESX.Alert("Shoma Tanbacoo Nadarid", "error")
                                end
                            else
                                ESX.Alert("In Ghelyion Tanbacoo Darad!", "error")
                            end
                        end
                    end
                end
            end
        end)
    end)
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(98.34726, 200.5846, 107.3661)
    SetBlipSprite(blip, 650)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Café Artist")
    EndTextCommandSetBlipName(blip)
end)

function usedItem(k)
    if k == "hookah" then return end
    if k == "cigarett" then
        ExecuteCommand("e smoke")
        return
    end
    local pedaret = math.random(2,6)
    if pedaret == 4 then
        LoadAnimDict("mp_player_inteat@burger")
        TaskPlayAnim(PlayerPedId(), "mp_player_inteat@burger", "mp_player_int_eat_burger_fp", 8.0, -8, -1, 49, 0, 0, 0, 0)
    else
        LoadAnimDict("mp_player_intdrink")
        TaskPlayAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
    TriggerEvent('esx_status:add', "hunger", math.random(50000, 55000))
    TriggerEvent('esx_status:add', "thirst", math.random(50000, 55000))
end

local items = {
    ["esx_hookah:usePort"] = "abporteghal",
    ["esx_hookah:useMilk"] = "milkshake",
    ["esx_hookah:useSigar"] = "cigarett",
    ["esx_hookah:useIce"] = "bastani",
    ["esx_hookah:useMohito"] = "mohito",
    ["esx_hookah:useWaffle"] = "waffle",
    ["esx_hookah:useHookah"] = "hookah",
}

for k, v in pairs(items) do
    RegisterNetEvent(k)
    AddEventHandler(k, function()
        usedItem(v)
    end)
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

LoadAnimDict = function(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end
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