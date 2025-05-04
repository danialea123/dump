local response = false
ESX = nil
local targetIds
local tradeDatas
local tradeIds

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while not response do
        Citizen.Wait(100)
    end
    Citizen.Wait(3000)
    SendNUIMessage({type="SetLanguages", value = Config.Locale})
end)

RegisterNUICallback("GetResponse", function(data, callback)
    response = true
    if callback then 
        callback("ok")
    end
end)

Citizen.CreateThread(function ()
    while true do 
        Citizen.Wait(1000)
        SendNUIMessage({
            type = "send_response",
            resourceName = GetCurrentResourceName()
        })
        if response then 
            return
        end
    end
end)

local getreq = false

RegisterNetEvent("trade:receiveTradeRequest")
AddEventHandler("trade:receiveTradeRequest", function(senderId, name)
    if getreq then return end
    getreq = true

    local clicked = false

    Citizen.SetTimeout(5000, function()
        if not clicked then
            TriggerServerEvent("trade:cancelTradeRequest", senderId)
            getreq = false
            ESX.UI.Menu.CloseAll()
        end
    end)

	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
	{
		title 	 = 'Darkhast Trade',
		align    = 'center',
		question = "Aya Darkhast Trade Az Taraf ("..name..") Ra Ghabool Mikonid?",
		elements = {
            {label = 'Kheyr', value = 'no'},
			{label = 'Bale', value = 'yes'},
		}
	}, function(data, menu)
		if data.current.value == "yes" then
			clicked = true
            getreq = false
            TriggerServerEvent("trade:acceptTradeRequest", senderId)
			menu.close()
		elseif data.current.value == "no" then
			clicked = true
            getreq = false
            TriggerServerEvent("trade:rejectTradeRequest", senderId)
			menu.close()
		end
	end)
end)

RegisterNetEvent("trade:startTrade")
AddEventHandler("trade:startTrade", function(targetId, tradeData,tradeId)
    print(json.encode(tradeData))
    targetIds = targetId
    tradeDatas = tradeData
    tradeIds = tradeId
    onTrade = true
    getTradePlayerInventory(function(items)
        local inventoryTable = {}       
        for _, item in pairs(items) do
            table.insert(inventoryTable, {label = item.label, count = item.count, name = item.name, info = item.info})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "startTrade",
            targetId = targetId,
            tradeId = tradeId,
            myId = GetPlayerServerId(PlayerId()),
            tradeData = tradeData,
            inventory = inventoryTable
        })
    end)
    local entity = GetPlayerPed(GetPlayerFromServerId(targetId))
    Citizen.CreateThread(function()
        while onTrade do
            Citizen.Wait(1000)
            local coord = GetEntityCoords(PlayerPedId())
            local coord2 = GetEntityCoords(entity)
            if PlayerPedId() ~= entity and not DoesEntityExist(entity) and #(coord - coord2) >= 10.0 then
                TriggerServerEvent('codem-trade:declineTrade', {tradeID = tradeData.iDTrade})
            end
        end
    end)
end)

function getTradePlayerInventory(callback)
    ESX.TriggerServerCallback("trade:getPlayerInventory", function(items, money)
        local items = items
        table.insert(items, {label = Config.MoneyName, count = money, name = "cash"})
        if callback then
            callback(items)
        end
    end)
end

RegisterNetEvent("trade:rejectTradeRequest")
AddEventHandler("trade:rejectTradeRequest", function(senderId)
    Config.Notification(Config.Notifications["rejected"]["message"], Config.Notifications["rejected"]["type"])
    TriggerServerEvent("trade:rejectTradeRequest", senderId)
end)

RegisterNetEvent("trade:tradeRequestRejected")
AddEventHandler("trade:tradeRequestRejected", function(otherPlayerServerId)
    Config.Notification(Config.Notifications["rejected"]["message"], Config.Notifications["rejected"]["type"])
end)

RegisterNUICallback("ItemDrag", function(data, cb)
    TriggerServerEvent('codem-trade:itemSwap', data)
end)
RegisterNUICallback("ItemDragOther", function(data, cb)
    TriggerServerEvent('codem-trade:itemSwapOther', data)
end)

RegisterNUICallback("acceptTrade", function(data, cb)
    TriggerServerEvent('codem-trade:acceptTrade', data)
end)

RegisterNetEvent('codem-trade:tradeAccepted')
AddEventHandler('codem-trade:tradeAccepted',function ()
    SendNUIMessage({
        type = "offerAccept",
    })
end)

RegisterNUICallback("declineTrade", function(data, cb)
    TriggerServerEvent('codem-trade:declineTrade',data)
end)

RegisterNetEvent('codem-trade:otherPlayerDeclined')
AddEventHandler('codem-trade:otherPlayerDeclined',function ()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closePage",
    })
    onTrade = false
end)

RegisterNetEvent('codem-trade:tradeCompleted')
AddEventHandler('codem-trade:tradeCompleted',function ()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closePage",
    })
    onTrade = false
end)

RegisterNetEvent('codem-trade:updateTradeItems')
AddEventHandler('codem-trade:updateTradeItems',function (data)
    SendNUIMessage({
        type = "updateOtherInventory",
        items = data
    })
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function()
    if not onTrade then return end
    TriggerServerEvent("trade:restoreOfferTable", tradeDatas)
    getTradePlayerInventory(function(items)
        local inventoryTable = {}       
        for _, item in pairs(items) do
            table.insert(inventoryTable, {label = item.label, count = item.count, name = item.name, info = item.info})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "startTrade",
            targetId = targetIds,
            tradeId = tradeIds,
            myId = GetPlayerServerId(PlayerId()),
            tradeData = tradeDatas,
            inventory = inventoryTable
        })
    end)
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function()
    if not onTrade then return end
    TriggerServerEvent("trade:restoreOfferTable", tradeDatas)
    getTradePlayerInventory(function(items)
        local inventoryTable = {}       
        for _, item in pairs(items) do
            table.insert(inventoryTable, {label = item.label, count = item.count, name = item.name, info = item.info})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "startTrade",
            targetId = targetIds,
            tradeId = tradeIds,
            myId = GetPlayerServerId(PlayerId()),
            tradeData = tradeDatas,
            inventory = inventoryTable
        })
    end)
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function()
    if not onTrade then return end
    TriggerServerEvent("trade:restoreOfferTable", tradeDatas)
    getTradePlayerInventory(function(items)
        local inventoryTable = {}       
        for _, item in pairs(items) do
            table.insert(inventoryTable, {label = item.label, count = item.count, name = item.name, info = item.info})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "startTrade",
            targetId = targetIds,
            tradeId = tradeIds,
            myId = GetPlayerServerId(PlayerId()),
            tradeData = tradeDatas,
            inventory = inventoryTable
        })
    end)
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function()
    if not onTrade then return end
    TriggerServerEvent("trade:restoreOfferTable", tradeDatas)
    getTradePlayerInventory(function(items)
        local inventoryTable = {}       
        for _, item in pairs(items) do
            table.insert(inventoryTable, {label = item.label, count = item.count, name = item.name, info = item.info})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "startTrade",
            targetId = targetIds,
            tradeId = tradeIds,
            myId = GetPlayerServerId(PlayerId()),
            tradeData = tradeDatas,
            inventory = inventoryTable
        })
    end)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function()
    if not onTrade then return end
    TriggerServerEvent("trade:restoreOfferTable", tradeDatas)
    getTradePlayerInventory(function(items)
        local inventoryTable = {}       
        for _, item in pairs(items) do
            table.insert(inventoryTable, {label = item.label, count = item.count, name = item.name, info = item.info})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "startTrade",
            targetId = targetIds,
            tradeId = tradeIds,
            myId = GetPlayerServerId(PlayerId()),
            tradeData = tradeDatas,
            inventory = inventoryTable
        })
    end)
end)