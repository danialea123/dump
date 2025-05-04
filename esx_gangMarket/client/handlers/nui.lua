---@diagnostic disable: undefined-global, undefined-field
RegisterNuiCallback('close', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('addItem', function(data, cb)
    if tonumber(data.price) and tonumber(data.price) > 5000000 then 
        cb(false)
        ESX.Alert("Gheymat Mahsool Bishtar Az 5 Million Nemitavanad Bashad", "info")
        return
    end
    if tonumber(data.price) and tonumber(data.price) <= 0 then 
        cb(false)
        ESX.Alert("Kamtarin Gheymat 1$ Mibashad", "info")
        return
    end
    if tonumber(data.quantity) and tonumber(data.quantity) <= 0 then 
        cb(false)
        ESX.Alert("Kamtarin Tedad 1 Mibashad", "info")
        return
    end
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:addItem', function(result, reason)
            cb(result)
            if reason then ESX.ShowNotification(reason) end
        end, LastMarket, data)
    end
end)

RegisterNuiCallback('unlistProduct', function(data, cb)
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:unlistProduct', function(result)
            cb(result)
        end, LastMarket, data.product)
    end
end)

RegisterNuiCallback('editItem', function(data, cb)
    if tonumber(data.price) and tonumber(data.price) > 5000000 then 
        ESX.Alert("Gheymat Mahsool Bishtar Az 5 Million Nemitavanad Bashad", "info")
        return
    end
    TriggerServerEvent('s1n_marketplace:editItem', LastMarket, data)
end)

local click = false

RegisterNuiCallback('buyItem', function(data, cb)
    if click then return cb(false, "") end
    click = true
    Citizen.SetTimeout(2000, function()
        click = false
    end)
    local data = data
    local cb = cb
    Citizen.Wait(math.random(100, 450))
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:buyItem', function(result, reason)
            cb(result)
            if reason then ESX.ShowNotification(reason) end
        end, LastMarket, data.item, ClosestMarket.Type == 'blackmarket')
    end
end)

RegisterNuiCallback('getPlayerStats', function(data, cb)
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:getPlayerStats', function(stats)
            cb(stats)
        end)
    end
end)

RegisterNuiCallback('buyAdvertisement', function(data, cb)
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:buyAdvertisement', function(result, reason)
            cb(result)
            if reason then ESX.ShowNotification(reason) end
        end, LastMarket, data)
    end
end)

RegisterNuiCallback('unlistAuctionProduct', function(data, cb)
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:unlistAuctionProduct', function(result)
            cb(result)
        end, LastMarket, data.product)
    end
end)

RegisterNuiCallback('placeOffer', function(data, cb)
    if ESX then
        ESX.TriggerServerCallback('s1n_marketplace:placeOffer', function(result, reason)
            cb(result)
            if reason then ESX.ShowNotification(reason) end
        end, LastMarket, data)
    end
end)

RegisterNuiCallback('notify', function(data, cb)
    if ESX then
        ESX.ShowNotification(data.text)
        ESX.Alert(data.text, "info")
    end
end)