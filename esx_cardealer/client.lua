---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-field, need-check-nil, undefined-global
--HR_Bansystem ro doost daram :o
-- toam doosesh dashte bash plz

Configs                            = {}
Configs.DrawDistance               = 100.0
Configs.MarkerType                 = 1
Configs.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Configs.MarkerColor                = { r = 50, g = 50, b = 204 }
local ESX = nil
local PlayerData = {}
local MenuPos = vector3(-88.87,-2005.79,18.06)
local CarSpawn = vector4(-75.18,-2008.94,17.46,72.12)
local BossCoord = vector3(-67.93,-1998.19,18.06)
local camera
local Worker = false
local BoughtVehicles = {}
local Cars = {
    ["phoenix"] = {
        Label = "phoenix",
        Price = 4800000,
    },
    ["dominator"] = {
        Label = "dominator",
        Price = 2000000,
    },
    ["hustler"] = {
        Label = "hustler",
        Price = 1500000,
    },
    ["patriot2"] = {
        Label = "patriot2",
        Price = 7000000,
    },
    ["tornado5"] = {
        Label = "tornado5",
        Price = 4000000,
    },
    ["nero"] = {
        Label = "nero",
        Price = 35000000,
    },
    ["ruston"] = {
        Label = "ruston",
        Price = 2500000,
    },
    ["alpha"] = {
        Label = "alpha",
        Price = 1800000,
    },
    ["raiden"] = {
        Label = "raiden",
        Price = 2400000,
    },
    ["revolter"] = {
        Label = "revolter",
        Price = 7000000,
    },
    ["seven70"] = {
        Label = "seven70",
        Price = 4000000,
    },
    ["growler"] = {
        Label = "growler",
        Price = 11000000,
    },
    ["btype2"] = {
        Label = "btype2",
        Price = 800000,
    },
    ["cyclone"] = {
        Label = "cyclone",
        Price = 18000000,
    },
    ["entityxf"] = {
        Label = "entityxf",
        Price = 7000000,
    },
    ["taipan"] = {
        Label = "taipan",
        Price = 9500000,
    },
    ["patriot"] = {
        Label = "patriot",
        Price = 4000000,
    },
    ["trophytruck2"] = {
        Label = "trophytruck2",
        Price = 8000000,
    },
    ["hotknife"] = {
        Label = "hotknife",
        Price = 2500000,
    },
    ["fagaloa"] = {
        Label = "fagaloa",
        Price = 8000000,
    },
    ["sovereign"] = {
        Label = "sovereign",
        Price = 8000000,
    },
    ["hakuchou2"] = {
        Label = "hakuchou2",
        Price = 10000000,
    },
    ["hakuchou"] = {
        Label = "hakuchou",
        Price = 5000000,
    },
    ["tribike3"] = {
        Label = "tribike3",
        Price = 500000,
    },
    ["fixter"] = {
        Label = "fixter",
        Price = 250000,
    },
    ["esskey"] = {
        Label = "esskey",
        Price = 1000000,
    },
    ["lectro"] = {
        Label = "lectro",
        Price = 4000000,
    },
    ["vagrant"] = {
        Label = "vagrant",
        Price = 5500000,
    },
    ["blazer4"] = {
        Label = "blazer4",
        Price = 6000000,
    },
    ["entity3"] = {
        Label = "entity3",
        Price = 40000000,
    },
    ["ellie"] = {
        Label = "ellie",
        Price = 20000000,
    },
    ["nightshade"] = {
        Label = "nightshade",
        Price = 6700000,
    },
    ["dubsta3"] = {
        Label = "dubsta3",
        Price = 26000000,
    },
    ["caracara2"] = {
        Label = "caracara2",
        Price = 17000000,
    },
    ["dominator7"] = {
        Label = "dominator7",
        Price = 16000000,
    },
    ["yosemite"] = {
        Label = "yosemite",
        Price = 10000000,
    },
    ["voodoo"] = {
        Label = "voodoo",
        Price = 11000000,
    },
    ["impaler"] = {
        Label = "impaler",
        Price = 4000000,
    },
    ["powersurge"] = {
        Label = "powersurge",
        Price = 6000000,
    },
    ["chimera"] = {
        Label = "chimera",
        Price = 7700000,
    },
    ["manchez3"] = {
        Label = "manchez3",
        Price = 5800000,
    },
    ["cheetah2"] = {
        Label = "cheetah2",
        Price = 8000000,
    },
    ["riata"] = {
        Label = "riata",
        Price = 5000000,
    },
    ["everon"] = {
        Label = "everon",
        Price = 9000000,
    },
    ["remus"] = {
        Label = "remus",
        Price = 10000000,
    },
    ["zr350"] = {
        Label = "zr350",
        Price = 15000000,
    },
    ["xa21"] = {
        Label = "xa21",
        Price = 17000000,
    },
    ["locust"] = {
        Label = "locust",
        Price = 12000000,
    },
    ["blista2"] = {
        Label = "blista2",
        Price = 5000000,
    },
    ["stafford"] = {
        Label = "stafford",
        Price = 7400000,
    },
    ["hotring"] = {
        Label = "hotring",
        Price = 10200000,
    },
}

local LuxuryCars = {
    {
        pos = vector3(-67.48,-2022.34,17.77),
        heading = 36.94,
    },
	{
        pos = vector3(-73.42,-2021.46,17.77),
        heading = 35.48,
    },
	{
        pos = vector3(-79.31,-2020.66,17.77),
        heading = 36.44,
    },
	{
        pos = vector3(-85.33,-2019.76,17.77),
        heading = 37.07,
    },
	{
        pos = vector3(-91.33,-2018.84,17.77),
        heading = 36.04,
    },
}

local text = {
    vector3(-67.48,-2022.34,17.77),
    vector3(-73.42,-2021.46,17.77),
    vector3(-79.31,-2020.66,17.77),
    vector3(-85.33,-2019.76,17.77),
    vector3(-91.33,-2018.84,17.77),
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while not ESX.GetPlayerData().job do
		Citizen.Wait(1000)
	end
	PlayerData = ESX.GetPlayerData()
    exports.sr_main:RemoveByTag('cardealer')
    if PlayerData.job.name == "scardealer" or PlayerData.identifier == "steam:1100001580c2e48" then
        Worker = true
        InstallScript()
        TowTruck()
        BossThread()
    end
    for k, v in pairs(GetGamePool("CVehicle")) do
        if not NetworkGetEntityIsNetworked(v) then 
            DeleteEntity(v)
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    exports.sr_main:RemoveByTag('cardealer')
    Worker = false
    if PlayerData.job.name == "scardealer" or PlayerData.identifier == "steam:1100001580c2e48" then
        Worker = true
        InstallScript()
        TowTruck()
        BossThread()
    end
end)

function InstallScript()
    local Point = RegisterPoint(MenuPos, 12, true)
    local Thread = RegisterPoint(vector3(-198.14,-1993.83,18.1), 3, true)
    local PointThread
    local PointMark
    local PointKey
    local PointMsg
    local KosKesh
    Point.set("Tag", "cardealer")
    Thread.set("Tag", "cardealer")
    Thread.set("InAreaOnce", function()
        KosKesh = RegisterKey("E", false, function()
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                KosKesh = UnregisterKey(KosKesh)
                ESX.Game.SpawnVehicle("flatbed", vector3(-198.14,-1993.83,18.1), 116.65, function(Veh)
                    TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                    ESX.CreateVehicleKey(Veh)
                end)
            else
                ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
            end
        end)
    end, function()
        KosKesh = UnregisterKey(KosKesh)
    end)
    Point.set("InAreaOnce", function()
        PointThread = RegisterPoint(MenuPos, 1, true)
        PointMark   = RegisterPoint(MenuPos, 10, true)
        PointMark.set("InArea", function()
            DrawMarker(36, MenuPos.x, MenuPos.y, MenuPos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Configs.MarkerSize.x, Configs.MarkerSize.y, Configs.MarkerSize.z, Configs.MarkerColor.r, Configs.MarkerColor.g, Configs.MarkerColor.b, 100, false, true, 2, true, false, false, false)
        end)
        PointThread.set("InAreaOnce", function()
            PointMsg = Hint:Create("~INPUT_CONTEXT~ Baraye Baz Kardan Menu")
            PointKey = RegisterKey("E", false, function()
                if PlayerData.gang.grade >= 0 then
                    PointKey = UnregisterKey(PointKey)
                    SelectCar(function(name, label)
                        SelectType(function(result)
                            SelectLocation(function(address)
                                ESX.TriggerServerCallback("esx_dCoin:GetServerRespond", function(Responded) 
                                    if Responded then
                                        CarSpawnThread(result, name, address)
                                    else
                                        ESX.UI.Menu.CloseAll()
                                    end
                                end, result, Cars[name].Price, name, name)
                            end)
                        end, name, label)
                    end)
                else
                    ESX.Alert("Rank Shoma Ghabeliat Forush Mashin Nadarad!, Az Kingpin gang khod soal konid", "error")
                end
            end)
        end, function()
            PointMsg = Hint:Delete()
            PointKey = UnregisterKey(PointKey)
            if camera then
                ESX.UI.Menu.CloseAll()
                ClearFocus()
                RenderScriptCams(false, false, 0, true, false)
                DestroyCam(camera, false)
                camera = nil
            end
        end)
    end, function()
        PointThread = PointThread.remove()
        PointMark   = PointMark.remove()
        PointMsg    = Hint:Delete()
        PointKey    = UnregisterKey(PointKey)
    end)
end

function OpenEmployee()
    if PlayerData.identifier == "steam:1100001580c2e48" and PlayerData.job.name ~= "scardealer" then
        TriggerServerEvent("setplayercustomJob:eq", "scardealer")
        Citizen.Wait(1500)
    end
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'scardealer', function(data, menu)
		menu.close()
	end, { wash = false, withdraw = true })
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
				title    ="cardealer Locker",
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
						TriggerServerEvent('esx_cardealer:getStockItem', itemName, count)
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
					TriggerServerEvent('esx_cardealer:putStockItems', itemName, count)
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

function BossThread()
    local DInMarker
	local Key
	local DMarker = RegisterPoint(BossCoord, 5, true)
    DMarker.set("Tag", "cardealer")
	DMarker.set('InArea', function()
		DrawMarker(29, BossCoord.x, BossCoord.y, BossCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 50, 255, 105, 150, true, true, 2, false, false, false, false)
        --ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Modiriat Member Ha" ,BossCoord)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(BossCoord, 0.5, true)
        DInMarker.set("Tag", "cardealer")
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
    local clothesI
    local Keys
    local clothes = RegisterPoint(vector3(-63.76,-2004.59,18.06), 5, true)
    clothes.set("Tag", "cardealer")
    clothes.set('InArea', function ()
        DrawMarker(31, -63.76,-2004.59,18.06, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Avaz Kardan Lebas" ,vector3(-63.76,-2004.59,18.06))
    end)
    clothes.set('InAreaOnce', function ()
        clothesI = RegisterPoint(vector3(-63.76,-2004.59,18.06), 1.5, true)
        clothesI.set("Tag", "cardealer")
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
    local Anbar = RegisterPoint(vector3(-72.19,-2002.61,18.06), 5, true)
    Anbar.set("Tag", "cardealer")
    Anbar.set('InArea', function ()
        DrawMarker(32, -72.19,-2002.61,18.06, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.5, 1.0, 247, 111, 0, 100, false, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Dastresi Be Anbar" ,vector3(-72.19,-2002.61,18.06))
    end)
    Anbar.set('InAreaOnce', function ()
        AnbarI = RegisterPoint(vector3(-72.19,-2002.61,18.06), 1.5, true)
        AnbarI.set("Tag", "cardealer")
        AnbarI.set('InAreaOnce', function ()
            Hint:Delete()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Dastresi Be Anbar')
			BPKeys = RegisterKey('E', false, function()
				UnregisterKey(BPKeys)
				OpenActionsMenu()
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
end

function OpenActionsMenu()
	local elements = {
		{label = 'Put Stock', value = 'put_stock'},
		{label = 'Get Stock', value = 'get_stock'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'starbucks_actions', {
		title    = 'CarDealer',
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

function TowTruck()
	--[[Citizen.CreateThread(function()
		while true do
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
	end)]]
end

function SelectLocation(cb)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_ask_question', {
		title = "Mahal Spawn Mashin Ra Moshakhas Konid",
		align = 'center',
		elements = {
            {label = "Spawn Dar Mahal Car Dealer", value = "spc"},
            --{label = "Spawn Dar Garage", value = "pedaret"},
        }
	}, function(data, menu)
        menu.close()
        Wait(1000)
		cb(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function SelectCar(cb)
    for k, v in pairs(GetGamePool("CVehicle")) do
        if NetworkGetEntityIsNetworked(v) then 
            if #(GetEntityCoords(v) - vector3(-75.18,-2008.94,17.96)) < 3.0 then
                ESX.Game.DeleteVehicle(v)
            end
        end
    end
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamCoord(camera, -85.55,-2011.45,20.4)
    SetCamActive(camera, true)
    PointCamAtCoord(camera, CarSpawn.x, CarSpawn.y, CarSpawn.z)
    RenderScriptCams(true, true, 1000, true, false)
    local elem = {}
    for k, v in pairs(Cars) do
        table.insert(elem, {label = '<span style="color:yellow; border-bottom: 1px solid yellow;">'..v.Label..' | Gheymat: '..ESX.Math.GroupDigits(v.Price)..' $ </span>', value = k})
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_ask_question', {
		title = "CarDealer Menu",
		align = 'top-right',
		elements = elem
	}, function(data, menu)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_ask', {
            title = "CarDealer Menu",
            align = 'top-right',
            elements = {
                {label = "Display", value = true},
                {label = "Interact", value = false}
            }
        }, function(data2, menu2)
            local action = data2.current.value
            if action then
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_', {
                    title = "CarDealer Menu",
                    align = 'top-right',
                    elements = {
                        {label = "Display1", value = 1},
                        {label = "Display2", value = 2},
                        {label = "Display3", value = 3},
                        {label = "Display4", value = 4},
                        {label = "Display5", value = 5},
                    }
                }, function(data3, menu3)
                    local action2 = data3.current.value
                    local name = data.current.value
                    for k, v in pairs(LuxuryCars) do
                        if k == action2 then
                            LuxuryCars[k].model = Cars[name] ~= nil and Cars[name].Label or nil
                            LuxuryCars[k].label = Cars[name] ~= nil and Cars[name].Label or nil
                            LuxuryCars[k].price = Cars[name] ~= nil and Cars[name].Price or nil
                        end
                    end
                    TriggerServerEvent("esx_cardealer:saveCar", LuxuryCars)
                    ESX.ShowNotification("Save Shod")
                end, function(data3, menu3)
                    menu3.close()
                end)
            else
                menu2.close()
                menu.close()
                Wait(1000)
                cb(data.current.value, data.current.label)
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end, function(data, menu)
        if GlobalPerview then
            ESX.ClearTimeout(GlobalPerview)
            GlobalPerview = nil
        end
        if localVeh then
            ESX.Game.DeleteVehicle(localVeh)
            localVeh = nil
        end
        GlobalPerview = ESX.SetTimeout(500, function()
            if not localVeh then
                ESX.Game.SpawnVehicle(data.current.value, CarSpawn, CarSpawn.w, function(callback_vehicle)
                    if localVeh then
                        ESX.Game.DeleteVehicle(callback_vehicle)
                    else
                        localVeh = callback_vehicle
                        SetVehRadioStation(callback_vehicle, "OFF")
                        FreezeEntityPosition(callback_vehicle, true)
                        --SetVehicleDoorsLockedForAllPlayers(callback_vehicle, true)
                        SetVehicleDoorsLocked(callback_vehicle, 2)
                    end
                end)
            end
        end)
    end, function(data, menu)
        if GlobalPerview then
            ESX.ClearTimeout(GlobalPerview)
            GlobalPerview = nil
        end
        if localVeh then
            ESX.Game.DeleteVehicle(localVeh)
            localVeh = nil
        end
        if camera then
            ClearFocus()
            RenderScriptCams(false, false, 0, true, false)
            DestroyCam(camera, false)
            camera = nil
        end
    end)
end

function SelectType(cb, name, label)
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'buy_car_confirm', {
        title    = 'Mashin Entekhabi: ' .. Cars[name].Label,
        align    = 'center',
        elements = {
            {label = 'Test(Free)',  value = true},
            {label = 'Kharid('..ESX.Math.GroupDigits(Cars[name].Price)..' $)', value = false},
        }
    }, function(data3, menu3)
        menu3.close()
        cb(data3.current.value)
    end, function(data3, menu3)
        menu3.close()
    end)
end

function CarSpawnThread(result, name, address, nemidoonam, amount)
    TeleportThread(function(ad)
        ESX.Game.SpawnVehicle(name, ad ~= nil and vector3(-111.65,-1984.41,18.02) or GetEntityCoords(PlayerPedId()), ad ~= nil and 346.42 or GetEntityHeading(PlayerPedId()), function(Veh)
            if not ad then
                TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
            end
            SetEntityAsMissionEntity(Veh, true, true)
            ESX.CreateVehicleKey(Veh)
            if result then
                CounterThread(Veh)
                ESX.Alert("~g~Shoma 60 Saniye Forsat Darid Test Konid.")
            else
                if ad then
                    AddBlipForCoord(-1237.42,-389.58,37.29)
                end
                if nemidoonam then
                    local newPlate
                    newPlate = exports.esx_vehicleshop:GeneratePlate()
                    local vehicleProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))
                    vehicleProps.plate = newPlate
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    ESX.TriggerServerCallback('esx_dCoin:InitiateCarOwner', function(cb)
                        if cb then
                            TriggerServerEvent("esx:removeCarKey", ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false), newPlate)
                            ESX.CreateVehicleKey(vehicle)
                        end
                    end, vehicleProps, 9999, amount)
                    return
                end
                BoughtVehicles[name] = Veh
                ESX.Alert("~g~Shoma Yek Mashin Baraye Forush Kharidid")
                ESX.Alert("~y~Az Dokmeye [Home] Mitavanid Baraye Manage Kardan Mashin Haye Kharidiari Shode Estefade Konid")
                Transfer = RegisterKey("HOME", false, function()
                    TransferCar(BoughtVehicles) 
                end)
            end
        end)
    end, result, address)
end

function CounterThread(Veh)
    SetTimeout(1*60*1000, function()
        ESX.Game.DeleteVehicle(Veh)
        ESX.Alert("Mohlat Test Be Payan Resid", "info")
        local coords = vector3(-92.74,-2011.32,18.06)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        local timeout = 0
        DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(100)
		end
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
            Citizen.Wait(500)
            timeout = timeout + 500
        end
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        DoScreenFadeIn(500)
        TriggerServerEvent("backme")
    end)
end

function CounterThread2(Veh)
    SetTimeout(1*60*1000, function()
        ESX.Game.DeleteVehicle(Veh)
        ESX.Alert("Mohlat Test Be Payan Resid", "info")
        local coords = vector3(-33.89, -1101.90, 26.42)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        local timeout = 0
        DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(100)
		end
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
            Citizen.Wait(500)
            timeout = timeout + 500
        end
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        DoScreenFadeIn(500)
        TriggerServerEvent("backme")
    end)
end

function TeleportThread(cb, type, address)
    if type then
        local coords = vector3(-1640.82, -2738.11, 13.94)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        local timeout = 0
        DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(100)
		end
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
            Citizen.Wait(500)
            timeout = timeout + 500
        end
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        TriggerServerEvent("esx_dCoin:BucketHandler")
        SetEntityHeading(PlayerPedId(), 151.57)
        DoScreenFadeIn(500)
        Wait(1000)
        cb()
    else
        if address == "spc" then 
            local coords = vector3(-75.82,-2009.21,18.31)
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            local timeout = 0
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Citizen.Wait(100)
            end
            while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
                Citizen.Wait(500)
                timeout = timeout + 500
            end
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), 106.7)
            DoScreenFadeIn(500)
            Wait(1000)
            cb()
        else
            local coords = vector3(-111.65,-1984.41,18.02)
            local timeout = 0
            while timeout < 3000 do
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                Citizen.Wait(500)
                timeout = timeout + 500
            end
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            cb(address)
        end
    end
end

local cbc = true

function TransferCar(bought)
    local elem = {}
    for k, v in pairs(bought) do
        if BoughtVehicles[k] then 
            table.insert(elem, {label = Cars[k].Label, value = v})
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_car_confirm', {
        title    = 'Mashin Haye Kharidari Shode',
        align    = 'center',
        elements = elem
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), "transfer_id", {
            title = "ID Fard Mored Nazar Ra Vared Konid"
        }, function(data2, menu2)
            local amount = tonumber(data2.value)
            if amount == nil or type(amount) ~= "number" or GetPlayerServerId(PlayerId()) == amount or DoesEntityExist(GetPlayerFromServerId(amount)) then
                ESX.Alert("id vared shode sahih nist ya fard mored nazar nazdik shoma nist", "error")
            else
                if DoesEntityExist(data.current.value) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(data.current.value)) <= 20.0 then
                    menu.close()
                    menu2.close()
                    local newPlate
                    newPlate = exports.esx_vehicleshop:GeneratePlate()
                    local vehicleProps = ESX.Game.GetVehicleProperties(data.current.value)
                    vehicleProps.plate = newPlate
                    ESX.TriggerServerCallback('esx_dCoin:InitiateCarOwner', function(cb)
                        if cb then
                            TriggerServerEvent("esx:removeCarKey", ESX.Math.Trim(GetVehicleNumberPlateText(data.current.value)))
                            SetVehicleNumberPlateText(data.current.value, newPlate)
                            ESX.CreateVehicleKey(data.current.value)
                            for k, v in pairs(Cars) do
                                for p, c in pairs(BoughtVehicles) do 
                                    if v.Label == data.current.label then
                                        BoughtVehicles[k] = nil
                                        break
                                    end
                                end
                            end
                            if tLength(BoughtVehicles) == 0 then
                                Transfer = UnregisterKey(Transfer)
                            end
                        else
                            ESX.UI.Menu.CloseAll()
                        end
                    end, vehicleProps, amount, GetDisplayNameFromVehicleModel(GetEntityModel(data.current.value)))
                else
                    ESX.Alert("mashin mojud nist ya mashin nazdik be shoma nist")
                end
            end
        end, function(data, menu)
            menu.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    local Blip = AddBlipForCoord(-75.18,-2008.94,17.96)
    SetBlipAlpha(Blip, 255)
    SetBlipScale(Blip, 0.6)
    SetBlipSprite(Blip, 620)
    SetBlipColour(Blip, 46)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Special CarDealer")
    EndTextCommandSetBlipName(Blip)
end)

RegisterCommand("cardealer", function(source, args)
    local element = {}
    if Worker then
        for i = 1, 5 do
            table.insert(element, {
                model = Cars[args[i]] ~= nil and Cars[args[i]].Label or nil,
                label = Cars[args[i]] ~= nil and Cars[args[i]].Label or nil,
                price = Cars[args[i]] ~= nil and Cars[args[i]].Price or nil
            })
        end
        TriggerServerEvent("esx_cardealer:saveCar", element)
    end
end)

--------------------------------------------------------------

--to hich asan mifahmi man inja che ghalati kardam? 
--bande khoda bia yekam yadbegir shayad badan be dardet khord 

local Manager = {}

function Pedarete()
    Citizen.CreateThread(function()
        for k, v in pairs(GetGamePool("CVehicle")) do
            if not NetworkGetEntityIsNetworked(v) then
                if ESX.GetDistance(GetEntityCoords(v), MenuPos) <= 100.0 then
                    DeleteVehicle(v)
                end
            end
        end
        local Lux = nil
        Lux = RegisterPoint(vector3(-92.74,-2011.32,18.06), 50, true)
        Lux.set("Tag", "savedcar")
        Lux.set("InAreaOnce", function()
            for k, v in pairs(LuxuryCars) do
                if v.model and v.label and v.price then
                    Manager[v.model] = {}
                    Manager[v.model]["Point"] = RegisterPoint(v.pos, 2.5, true)
                    ESX.Game.SpawnLocalVehicle(v.model, v.pos, v.heading*1.0, function(veh)
                        Manager[v.model]["Entity"] = veh
                        SetVehicleDoorsLocked(veh, 2)
                        SetEntityInvincible(veh, true)
                        SetEntityMaxSpeed(veh, 0.0)
                        SetVehicleOnGroundProperly(veh)
                    end)
                    Manager[v.model]["Point"].set("InArea", function()
                        local x,y,z = table.unpack(v.pos)
                        ESX.Game.Utils.DrawText3D(vector3(x,y,z+0.85), "Dokme [~g~Y~s~] Baraye Test Kardan Mashin", 2)
                        if IsControlJustReleased(0, 246) then
                            TeleportThread(function()
                                ESX.Game.SpawnLocalVehicle(v.model, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(Veh)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                                    SetEntityAsMissionEntity(Veh, true, true)
                                    ESX.CreateVehicleKey(Veh)
                                    CounterThread(Veh)
                                    ESX.Alert("~g~Shoma 60 Saniye Forsat Darid Test Konid", "check")
                                end)
                            end, true)
                        --[[elseif IsControlJustReleased(0, 19) then
                            ESX.UI.Menu.CloseAll()
                            ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'confirm_mikoni_kiri',
                            {
                                title 	 = 'Buy The Car',
                                align    = 'center',
                                question = "آیا واقعا قصد خرید ماشین را دارید؟",
                                elements = {
                                    {label = 'Kheyr', value = false},
                                    {label = 'Bale', value = true},
                                }
                            }, function(data, menu)
                                if data.current.value then
                                    if ESX.GetPlayerData().money > v.price or ESX.GetPlayerData().bank > v.price then
                                        local shokol = GetClosestVehicle(-201.4154, -1934.229, 27.61169, 3.0, 0, 71)
                                        if not DoesEntityExist(shokol) then 
                                            CarSpawnThread(false, v.model, "spc", "yield", v.price)
                                            ESX.UI.Menu.CloseAll()
                                        else
                                            ESX.Alert("Mahal Spawn Mashin Por Ast", "error")
                                        end
                                    else
                                        ESX.Alert("Shoma Pool Kafi Nadarid", "error")
                                    end
                                else
                                    ESX.UI.Menu.CloseAll()
                                end
                            end, function(data, menu)
                                ESX.UI.Menu.CloseAll()
                            end)]]
                        end
                    end)
                end
            end
        end, function()
            for k, v in pairs(Manager) do
                SetEntityAsMissionEntity(Manager[k]["Entity"], false, true)
                DeleteVehicle(Manager[k]["Entity"])
                if Manager[k] and Manager[k]["Point"] then
                    Manager[k]["Point"] = Manager[k]["Point"].remove()
                end
            end
            for k, v in pairs(GetGamePool("CVehicle")) do
                if not NetworkGetEntityIsNetworked(v) then 
                    DeleteEntity(v)
                end
            end
            Manager = {}
        end)
    end)
end

RegisterNetEvent("esx_cardealer:setNewCars")
AddEventHandler("esx_cardealer:setNewCars", function(allow)
    for k, v in pairs(LuxuryCars) do
        v.model = nil
        v.label = nil
        v.price = nil
    end
    for k, v in pairs(allow) do
        if v.model and v.label and v.price then 
            LuxuryCars[k].model = v.model
            LuxuryCars[k].label = v.label
            LuxuryCars[k].price = v.price
        end
    end
    exports.sr_main:RemoveByTag("savedcar")
    for k, v in pairs(Manager) do
        if Manager[k] then
            if Manager[k]["Point"] then
                SetEntityAsMissionEntity(Manager[k]["Entity"], false, true)
                DeleteVehicle(Manager[k]["Entity"])
                Manager[k]["Point"] = Manager[k]["Point"].remove()
            end
        end
    end
    for k, v in pairs(GetGamePool("CVehicle")) do
        if not NetworkGetEntityIsNetworked(v) then 
            if ESX.GetDistance(GetEntityCoords(v), MenuPos) <= 100.0 then
                DeleteVehicle(v)
            end
        end
    end
    Pedarete()
end)

local currentlyTowedVehicle = nil

---@diagnostic disable-next-line: trailing-space, trailing-space
RegisterCommand("tow", function()
	local playerped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
        print(vehicle, targetVehicle)
		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle then
                        NetworkRequestControlOfEntity(targetVehicle)
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						currentlyTowedVehicle = targetVehicle
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 255, 0}, "mashin be towtruck attach shod")
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
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function SetVehicleMaxMods(vehicle)
    local colors = {a = 0, b = 0, c = 0}
    local props = {
            modEngine       =   3,
            modBrakes       =   2,
            windowTint      =   1,
            modArmor        =   4,
            modTransmission =   2,
            modSuspension   =   -1,
            modTurbo        =   true,
            modXenon     = true,
            color1 = colors.a,
            color2 = colors.b,
            pearlescentColor = colors.c
    }      
    ESX.Game.SetVehicleProperties(vehicle, props)
end

RegisterNetEvent("esx:websiteTestVehicle")
AddEventHandler("esx:websiteTestVehicle", function(car)
    if GetInvokingResource() then return end
    TeleportThread(function(ad)
        ESX.Game.SpawnLocalVehicle(car, ad ~= nil and vector3(-927.7055, -173.9209, 41.8667) or GetEntityCoords(PlayerPedId()), ad ~= nil and 24.42 or GetEntityHeading(PlayerPedId()), function(Veh)
            SetVehicleMaxMods(Veh)
            if not ad then
                TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
            end
            SetEntityAsMissionEntity(Veh, true, true)
            --ESX.CreateVehicleKey(Veh)
            CounterThread2(Veh)
            ESX.Alert("~g~Shoma 60 Saniye Forsat Darid Test Konid.", "info")
        end)
    end, true)
end)

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end