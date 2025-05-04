---@diagnostic disable: missing-parameter, undefined-global
Keys = {["E"] = 38, ["L"] = 182, ["G"] = 47}

payAmount = 0
Basket = {}

--[[ Gets the ESX library ]]--
ESX = nil 
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end)

DrawText3D = function(x, y, z, text)
    local onScreen,x,y = World3dToScreen2d(x, y, z)
    local factor = #text / 370

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x,y)
        DrawRect(x,y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 120)
    end
end

--[[ Requests specified model ]]--
_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

--[[ Deletes the cashiers ]]--
DeleteCashier = function()
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) then
            DeletePed(cashier["entity"])
            SetPedAsNoLongerNeeded(cashier["entity"])
        end
    end
end

Citizen.CreateThread(function()
    local defaultHash = 416176080
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if cashier then
            cashier["hash"] = cashier["hash"] or defaultHash
            _RequestModel(cashier["hash"])
            if not DoesEntityExist(cashier["entity"]) then
                cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
                SetEntityAsMissionEntity(cashier["entity"])
                SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
                FreezeEntityPosition(cashier["entity"], true)
                SetEntityInvincible(cashier["entity"], true)
            end
            SetModelAsNoLongerNeeded(cashier["hash"])
        end
    end
end)

RegisterNetEvent('esx_shop:DisableCashier')
AddEventHandler('esx_shop:DisableCashier', function(id)
    local cashier = Config.Locations[id]["cashier"]
    if DoesEntityExist(cashier["entity"]) then
        DeletePed(cashier["entity"])
        SetPedAsNoLongerNeeded(cashier["entity"])
    end
end)

RegisterNetEvent('esx_shop:RecoverCashier')
AddEventHandler('esx_shop:RecoverCashier', function(id)
    local defaultHash = 416176080
    local cashier = Config.Locations[id]["cashier"]
    if cashier then
        cashier["hash"] = cashier["hash"] or defaultHash
        _RequestModel(cashier["hash"])
        if not DoesEntityExist(cashier["entity"]) then
            cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
            SetEntityAsMissionEntity(cashier["entity"])
            SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
            FreezeEntityPosition(cashier["entity"], true)
            SetEntityInvincible(cashier["entity"], true)
            -- Config.Locations[i]["cashier"]["entity"] = cashier["entity"]
        end
        SetModelAsNoLongerNeeded(cashier["hash"])
    end
    Config.Locations[id].Disable = nil
    TriggerEvent('esx_shop:DisableRobItems')
end)

AddEventHandler('esx_shop:DisableRobItems', function()
    exports.sr_main:RemoveByTag('shop_item_robber')
end)

RegisterNetEvent('esx_shop:DisableShop')
AddEventHandler('esx_shop:DisableShop', function(id)
    Config.Locations[id].Disable = true
end)

function startAnim(ped, dictionary, anim)
	Citizen.CreateThread(function()
		RequestAnimDict(dictionary)
		while not HasAnimDictLoaded(dictionary) do
			Citizen.Wait(0)
		end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function StealItems(cat)
    Citizen.CreateThread(function()
        startAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search")
        exports.rprogress:Custom({
            Duration = 6500,
            Label = "Dozdidan " .. Config.Locales[cat] .. ' ...',
            Animation = {
                scenario = "",
                animationDictionary = "",
            },
            DisableControls = {
                Mouse = false,
                Player = true,
                Vehicle = true
            }
        })
        Wait(6500)
        TriggerServerEvent('sr_shoprob:StealItems', cat)
    end)
end

AddEventHandler('esx_shop:RobItems', function(i)
    for j=1, #Config.Locations[i]["shelfs"] do
        local pos = Config.Locations[i]["shelfs"][j]
        if pos["value"] ~= 'checkout' then
            local Key
            local Interact
            local Point = RegisterPoint(vector3(pos["x"], pos["y"], pos["z"]), 5, true)
            Point.set('Tag', 'shop_item_robber')
            Point.set('InArea', function ()
                Marker(pos)
            end)
            Point.set('InAreaOnce', function ()
                Interact = RegisterPoint(vector3(pos["x"], pos["y"], pos["z"]), 0.40, true)
                Interact.set('Tag', 'shop_item_robber')
                Interact.set('InArea', function ()
                    local text = "[E] Dozdidane " .. Config.Locales[pos["value"]]
                    DrawText3D(pos["x"], pos["y"], pos["z"], text)
                end)
                Interact.set('InAreaOnce', function ()
                    Key = RegisterKey('E', function ()
                        Key = UnregisterKey(Key)
                        StealItems(pos["value"])
                        if Interact then
                            Interact.remove()
                        end
                        if Interact then
                            Point.remove()
                        end
                    end)
                end, function ()
                    Key = UnregisterKey(Key)
                end)
            end, function ()
                if Interact then
                    Interact = Interact.remove()
                end
            end)
        end
    end
end)

--[[ Creates cashiers and blips ]]--
Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local blip = Config.Locations[i]["blip"]
        if blip then
            if not DoesBlipExist(blip["id"]) then
                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
                SetBlipSprite(blip["id"], 52)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 0.6)
                SetBlipColour(blip["id"], 66)
                SetBlipAsShortRange(blip["id"], true)
                BeginTextCommandSetBlipName("shopblip")
                AddTextEntry("shopblip", "Shop")
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end
end)

--[[ Function to trigger pNotify event for easier use :) ]]--
pNotify = function(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
        text = message,
		type = messageType,
		queue = "shopcl",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

Marker = function(pos)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 200, 200, 200, 60, false, false, 2, false, nil, nil, false)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 200, 200, 200, 60, false, false, 2, false, nil, nil, false)
end

--[[ Deletes the peds when the resource stops ]]--
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        --TriggerServerEvent('esx:clientLog', "[99kr-shops]: Deleting peds...")
        DeleteCashier()
    end
end)