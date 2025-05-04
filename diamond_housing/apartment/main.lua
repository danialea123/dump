---@diagnostic disable: undefined-global, undefined-field, param-type-mismatch, missing-parameter, lowercase-global
Points = {}
Interacts = {}
InApt = nil
isNearApt = false
Markers = {
    ["Inventory"] = 42,
    ["Exit"] = 21,
    ["Locker"] = 31,
}
Colors = {
    ["Inventory"] = {r =255 , g = 134, b = 93},
    ["Exit"] = {r =240 , g = 19, b = 40},
    ["Locker"] = {r = 255, g = 250, b = 210},
}
local Apartments = {
    [1] = {
        Entry     = vector3(-619.32, 37.9, 43.6),
        h1        = 176.26,
        Exit      = vector3(-603.2835, 58.94506, 98.19556),
        h2        = 86.27,
        Inventory = vector3(-621.9561, 54.60659, 97.58899),
        Locker    = vector3(-594.6989, 56.36044, 96.99927),
    },
    [2] = {
        Entry     = vector3(-909.2308, -446.2022, 39.59192),
        h1        = 114.58,
        Exit      = vector3(-890.4923, -437.0901, 121.6),
        h2        = 26.02,
        Inventory = vector3(-898.7209, -440.2022, 121.6),
        Locker    = vector3(-910.4835, -445.8593, 115.3993),
    },
    [3] = {
        Entry     = vector3(-778.8791, 312.567, 85.69299),
        h1        = 175.45,
        Exit      = vector3(-784.4703, 323.6571, 211.9824),
        h2        = 268.24,
        Inventory = vector3(-766.3384, 328.022, 211.3927),
        Locker    = vector3(-793.5297, 326.545, 210.7861),
    },
    [4] = {
        Entry     = vector3(348.43,441.49,147.7),
        h1        = 300.45,
        Exit      = vector3(340.04,436.89,149.39),
        h2        = 126.24,
        Inventory = vector3(337.48,437.39,141.77),
        Locker    = vector3(334.42,428.63,145.57),
    },
    [5] = {
        Entry     = vector3(411.89,-1487.98,30.15),
        h1        = 36.45,
        Exit      = vector3(346.74,-1012.11,-99.2),
        h2        = 359.24,
        Inventory = vector3(351.23,-999.0,-99.2),
        Locker    = vector3(350.66,-993.88,-99.2),
    },
    [6] = {
        Entry     = vector3(1125.19,2642.1,38.14),
        h1        = 344.11,
        Exit      = vector3(1116.4, 2643.88, 32.27),
        h2        = 359.24,
        Inventory = vector3(1119.6, 2646.68, 32.27),
        Locker    = vector3(1114.66, 2648.59, 32.27),
    },
}

local canEnter = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canEnter = true
    else
        canEnter = false
    end
end)

AddEventHandler("PlayerLoadedToGround", function()
    --ApartmentThread()
    if GetResourceKvpInt("AptNumber") ~= 0 then
        if Apartments[GetResourceKvpInt("AptNumber")] then
            if GetResourceKvpInt("AptVisit") == 0 then
                TeleportToApt(GetResourceKvpInt("AptNumber"), true)
            else
                TeleportToApt(GetResourceKvpInt("AptNumber"))
            end
        end
    end
end)

AddBlip = function(coords, sprite, colour, label, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

function Interact(k)
    local List = {}
    ESX.TriggerServerCallback("diamond_housing:DoesHaveApartment", function(y, p, s, z, h)
        table.insert(List, {
            img = 'SS_gold.png',
            text = 'Apartment Rooms: '..p.."/1000", 
            text2 = '', 
            callBack = function() 
        end}) 
        if y then
            table.insert(List, {
                img = 'SS_gold.png',
                text = 'Enter Apartment Room',
                text2 = 'Your Room Number: ('..s..")",
                callBack = function() 
                    exports.diamond_dialog:ForceCloseMenu()
                    if not canEnter then return end
                    EnterApt(k)  
            end})
            table.insert(List, {
                img = 'SS_gold.png',
                text = 'Sell Apartment Room', 
                text2 = '', 
                callBack = function()
                    exports.diamond_dialog:ForceCloseMenu()
                    SellApt(k)  
            end})
            table.insert(List, {
                img = 'SS_gold.png',
                text = 'Pets', 
                text2 = '', 
                callBack = function()
                    if #z > 0 then
                        exports.diamond_dialog:ForceCloseMenu()
                        if not canEnter then return end
                        OpenPetsMenu(z, h)
                    else
                        ESX.Alert("Shoma Hich Heyvan Khanegi Nadarid", "error")
                    end
            end})
        else
            table.insert(List, {
                img = 'SS_gold.png',
                text = 'Buy Apartment Room',
                text2 = '', 
                callBack = function() 
                    if p >= 1000 then return ESX.Alert("In Aparteman Zarfiat Kafi Baraye Shoma Nadarad", "info") end
                    exports.diamond_dialog:ForceCloseMenu()
                    BuyApt(k)  
            end})
            table.insert(List, {
                img = 'SS_gold.png',
                text = 'Visit', 
                text2 = '', 
                callBack = function()
                    exports.diamond_dialog:ForceCloseMenu()
                    if not canEnter then return end
                    VisitApt(k)  
            end})
        end
        table.insert(List, {
            img = 'SS_gold.png',
            text = 'Ring Other Rooms', 
            text2 = '', 
            callBack = function()
                exports.diamond_dialog:ForceCloseMenu()
                if not canEnter then return end
                RingApt(k)  
        end})
        exports.diamond_dialog:OpenMenu(List, configs)
    end, k)
end

function ApartmentThread()
    Citizen.CreateThread(function()
        for i, v in pairs(Apartments) do
            AddBlip(v.Entry, 475, 2, 'Apartment', 0.6)
            Points[i] = RegisterPoint(v.Entry, 9, true)
            Interacts[i] = RegisterPoint(v.Exit, 9, true)
            Interacts[i].set("InArea", function()
                DrawMarker(21, v.Exit, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 240, 19, 40, 255, false, true, 2, false, false, false, false)
                if #(GetEntityCoords(PlayerPedId()) - v.Exit) < 1.0 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ To Open Exit Menu')
                    if IsControlJustReleased(0, 38) then
                        ExitMenuApt(i)
                    end
                else
                    if exports.diamond_dialog:IsOpen() then
                        exports.diamond_dialog:ForceCloseMenu()
                    end
                end
            end)
            Points[i].set("InArea", function()
                if not InApt then
                    DrawMarker(6, v.Entry, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 128, 0, 255, false, true, 2, false, false, false, false)
                    DrawMarker(20, v.Entry, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 128, 0, 255, false, true, 2, false, false, false, false)
                    if #(GetEntityCoords(PlayerPedId()) - v.Entry) < 1.0 then
                        ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ To Interact With Apartment')
                        if IsControlJustReleased(0, 38) then
                            if not exports.diamond_dialog:IsOpen() then
                                Interact(i)
                            end
                        end
                    else
                        if exports.diamond_dialog:IsOpen() then
                            exports.diamond_dialog:ForceCloseMenu()
                        end
                    end
                end
            end)
            Points[i].set("OutAreaOnce", function()
                isNearApt = false
            end)
            Points[i].set("InAreaOnce", function()
                isNearApt = true
            end)
        end
    end)
end

function SellApt(k)
    local List = {}
    table.insert(List, {
        img = 'back.png',
        text = 'Back', 
        text2 = '', 
        callBack = function()
            exports.diamond_dialog:ForceCloseMenu()
            Interact(k)  
    end})
    table.insert(List, {
        img = 'product.png',
        text = 'Price: 180,000$', 
        text2 = '', 
        callBack = function()
    end})
    table.insert(List, {
        img = 'close.png',
        text = 'Confirm', 
        text2 = '', 
        callBack = function()
            exports.diamond_dialog:ForceCloseMenu()
            ForceSellApt(k)  
    end})
    exports.diamond_dialog:OpenMenu(List, configs)
end

function BuyApt(k)
    local List = {}
    table.insert(List, {
        img = 'back.png',
        text = 'Back', 
        text2 = '', 
        callBack = function()
            exports.diamond_dialog:ForceCloseMenu()
            Interact(k)  
    end})
    table.insert(List, {
        img = 'product.png',
        text = 'Price: 200,000$', 
        text2 = '', 
        callBack = function()
    end})
    table.insert(List, {
        img = 'close.png',
        text = 'Confirm', 
        text2 = '', 
        callBack = function()
            exports.diamond_dialog:ForceCloseMenu()
            ForceBuyApt(k)
    end})
    exports.diamond_dialog:OpenMenu(List, configs)
end

function ForceBuyApt(k)
    ESX.TriggerServerCallback("mf_housing:canAfford", function(res)
        if res then
            ESX.TriggerServerCallback("diamond_housing:CanPurchaseHouse", function(l)
                if l then
                    ESX.Alert("Shoma Yek Room Az In Apartment Kharidari Kardid", "check")
                    ESX.TriggerServerCallback("diamond_housing:RegisterApartment", function()
                        Interact(k)
                    end, k)
                end
            end)
        else
            ESX.Alert("Shoma Pool Kafi Nadarid", "error")
            Interact(k)
        end
    end, 200000)
end

function ForceSellApt(k)
    ESX.TriggerServerCallback("diamond_housing:Sell", function()
        Interact(k)
    end, k)
end

function VisitApt(k)
    TeleportToApt(k)
    ESX.Alert("Shoma 1 Daghighe Forsat Darid Az Aparteman Bazdid Konid", "info") 
    SetTimeout(60000, function()
        if InApt then
            TeleportOut(k)
        end
    end)
end

function RingApt(k)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'apt',{
		title = "Entekhab Vahed",
	}, function(data, menu)
		local link = data.value
		local link = tonumber(link)
		if link then
            if link >= 1 and link <= 4000 then
			    TriggerServerEvent('diamond_housing:ringApt', k, link)
                TriggerEvent("InteractSound_CL:PlayOnOne", "bell", 0.7)
                menu.close()
            else
                ESX.Alert("Faghat Vahed Haye 1 Ta 4000", "info")
            end
        else
            ESX.Alert("Shoma Hich Vahedi Entekhab Nakardid", "info")
		end
	end, function(data, menu)
		menu.close()
        Interact(k)
	end)
end

function TeleportToApt(k, bool, invited)
    InApt = true
    local coord = Apartments[k].Exit
    local timer = 900
    DoScreenFadeOut(750)
    RequestCollisionAtCoord(coord)
    Citizen.Wait(1500)
    ESX.SetEntityCoords(PlayerPedId(), coord)
    while timer > 0 do
        RequestCollisionAtCoord(coord)
        ESX.SetEntityCoords(PlayerPedId(), coord)
        timer = timer - 10
        Citizen.Wait(10)
    end
    SetEntityHeading(PlayerPedId(), Apartments[k].h2)
    DoScreenFadeIn(500)
    SetResourceKvpInt("AptNumber", k)
    if bool then
        TriggerServerEvent("diamond_housing:EnteredApt", k, invited)
        EnteredApt(k)
        SetResourceKvpInt("AptVisit", 0)
        return 
    end
    SetResourceKvpInt("AptVisit", 1)
end

function TeleportOut(k)
    InApt = false
    local coord = Apartments[k].Entry
    local timer = 900
    DoScreenFadeOut(750)
    RequestCollisionAtCoord(coord)
    Citizen.Wait(1500)
    ESX.SetEntityCoords(PlayerPedId(), coord)
    while timer > 0 do
        RequestCollisionAtCoord(coord)
        ESX.SetEntityCoords(PlayerPedId(), coord)
        timer = timer - 10
        Citizen.Wait(10)
    end
    SetEntityHeading(PlayerPedId(), Apartments[k].h1)
    DoScreenFadeIn(500)
    exports.sr_main:RemoveByTag("Apt")
    ESX.UI.Menu.CloseAll()
    TriggerServerEvent("diamond_housing:LeavedApt", k)
    SetResourceKvpInt("AptNumber", 0)
    SetResourceKvpInt("AptVisit", 0)
end

function EnteredApt(k)
    Citizen.CreateThread(function()
        for i, v in pairs(Apartments[k]) do
            if i == "Inventory" or i == "Locker" then
                Interacts[i] = RegisterPoint(v, 3, true)
                Interacts[i].set("Tag", "Apt")
                Interacts[i].set("InArea", function()
                    DrawMarker(Markers[i], Apartments[k][i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Colors[i].r, Colors[i].g, Colors[i].b, 255, false, true, 2, false, false, false, false)
                    if #(GetEntityCoords(PlayerPedId()) - Apartments[k][i]) < 1.0 then
                        ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ To Interact With '..i)
                        if IsControlJustReleased(0, 38) then
                            if not exports.diamond_dialog:IsOpen() then
                                if i == "Inventory" then
                                    TriggerEvent("esx_inventoryhud:OpenHouseInventory")
                                elseif i == "Locker" then
                                    TriggerEvent("codem-apperance:OpenWardrobe")
                                end
                            end
                        end
                    else
                        if exports.diamond_dialog:IsOpen() then
                            exports.diamond_dialog:ForceCloseMenu()
                        end
                    end
                end)
            end
        end
        Pedaret = RegisterPoint(Apartments[k]["Inventory"], 100, true)
        Pedaret.set("Tag", "Apt")
        Pedaret.set("OutAreaOnce", function()
            if InApt then
                TeleportOut(k)
                if Pedaret then
                    Pedaret = Pedaret.remove()
                end
            else
                if Pedaret then
                    Pedaret = Pedaret.remove()
                end
            end
        end)
    end)
end

function OpenLocker()
    local elements = {}
	table.insert(elements, {label = "Lebas Haye Dakhel Khoone", value = 'player_dressing'})
	table.insert(elements, {label = "Hazf Lebas Haye Dakhel Khoone", value = 'remove_cloth'})
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = "Lebas Khoone",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        if data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Lebas Haye Khoone",
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = "Hazf Khoone",
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('esx_property:removeOutfit', nil, data2.current.value)
					ESX.Alert( ('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function ExitMenuApt(k)
    local List = {}
    ESX.TriggerServerCallback("diamond_housing:DoesHaveAptInvite", function(have, data)
        table.insert(List, {
            img = 'back.png',
            text = 'Exit Apartment', 
            text2 = '', 
            callBack = function()
                exports.diamond_dialog:ForceCloseMenu()
                TeleportOut(k) 
        end})
        if have then
            table.insert(List, {
                img = 'human.png',
                text = 'Darkhast Vorud Be Vahed Shoma', 
                text2 = data.name..'('..data.id..') Zang Vahed Shoma Ra Zade', 
                callBack = function()
                    exports.diamond_dialog:ForceCloseMenu()
                    TriggerServerEvent("diamond_housing:AcceptEntering") 
            end})
        end
        exports.diamond_dialog:OpenMenu(List, configs)
    end)
end

function EnterApt(k)
    TeleportToApt(k, true)
end

RegisterNetEvent("diamond_housing:ForceEnterHouse")
AddEventHandler("diamond_housing:ForceEnterHouse", function(id, vahed)
    if isNearApt then
        TeleportToApt(id, true, vahed)
    end
end)

ApartmentThread()