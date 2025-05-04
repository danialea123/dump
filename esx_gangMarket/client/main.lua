---@diagnostic disable: undefined-field, param-type-mismatch, missing-parameter, undefined-global
QBCore = nil
ESX = nil

if Config.Framework.FrameworkName == 'QBCore' then
    local FileName = Config.Framework.QBCoreFileName
    QBCore = exports[FileName]:GetCoreObject()
elseif Config.Framework.FrameworkName == 'ESX' then
    if Config.Framework.OldESX then
        TriggerEvent(Config.Framework.ESXEvent, function(obj) ESX = obj end)
    else
        ESX = exports[Config.Framework.ESXFileName]:getSharedObject()
    end
end

PlayerData = nil
ClosestMarket = nil
LastMarket = nil

RegisterNetEvent('esx:playerLoaded', function()
	PlayerData = ESX.GetPlayerData()
end)

AddEventHandler("PlayerLoadedToGround", function()
    TriggerServerEvent('s1n_marketplace:checkPendingSales')
end)

RegisterNetEvent('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('s1n_marketplace:updateUI', function(shopItems, auctionItems, playerItems, playerVehicles, playerListedItems)
    SendNUIMessage({ type = 'UpdateUI', shopItems = shopItems, auctionItems = auctionItems, playerItems = playerItems, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems })
end)

RegisterNetEvent('s1n_marketplace:addNormalVehicle', function(name, data)
    data.label = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    TriggerServerEvent('s1n_marketplace:addNormalVehicle', name, data)
end)

RegisterNetEvent('s1n_marketplace:addAuctionVehicle', function(name, data)
    data.label = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    TriggerServerEvent('s1n_marketplace:addAuctionVehicle', name, data)
end)

RegisterNetEvent('s1n_marketplace:sellerNotification', function(notification)
    SendNUIMessage({ type = 'ShowNotification', notification = notification })
end)

RegisterNetEvent('s1n_marketplace:openMarket', function()
    LastMarket = ClosestMarket.Name
    ESX.TriggerServerCallback('s1n_marketplace:getData', function(shopItems, auctionItems, playerItems, playerVehicles, playerListedItems, playerWeapons, HaveAccessToSell)
        if ClosestMarket.Type == 'blackmarket' then
            playerItems = Helpers.RemoveBlacklistItems(Config.BlackMarketBlacklistItems, playerItems)
        else
            playerItems = Helpers.RemoveBlacklistItems(Config.BlackListItems, playerItems)
        end
        print(json.encode(shopItems))
        SendNUIMessage({ type = 'ShowUI', useLoadout = Config.UseEsxLoadout, marketType = ClosestMarket.Type, playerWeapons = playerWeapons, showSellerName = ClosestMarket.ShowSellerName, disableVehicles = ClosestMarket.DisableVehicles, translation = Translation, advertisement = Config.Advertisement, auction = Config.Auction, shopItems = shopItems, auctionItems = auctionItems, playerItems = playerItems, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems, HaveAccessToSell = HaveAccessToSell})
        SetNuiFocus(true, true)
    end, ClosestMarket.Name)
end)

RegisterCommand("psg", function()
    TriggerEvent("s1n_marketplace:openMarket")
end)

CreateThread(function()
    Helpers.CreateBlips()
    RequestModel(GetHashKey("ig_lamardavis"))
    while not HasModelLoaded(GetHashKey("ig_lamardavis")) do
        Citizen.Wait(10)
    end
    if Config.UseQbTarget then
        for key, market in pairs(Config.Marketplaces) do
            local entity = CreatePed(4, "ig_lamardavis", market.pedLoc.x, market.pedLoc.y, market.pedLoc.z-1, false, false)
            SetEntityHeading(entity, market.pedLoc.w or market.pedLoc.h)
            SetEntityAsMissionEntity(entity, true, true)
            SetBlockingOfNonTemporaryEvents(entity, true)
            FreezeEntityPosition(entity, true)
            SetEntityInvincible(entity, true)
            exports['diamond_target']:AddTargetEntity(entity, {
                options = {
                    {
                        action = function()
                            print(1111)
                            TriggerEvent("s1n_marketplace:openMarket")
                        end,
                        icon = Translation.TargetIcon,
                        label = Translation.TargetLabel
                    }
                },
                distance = 2.5
            })
        end
        while true do
            for key, market in pairs(Config.Marketplaces) do
                if #(GetEntityCoords(PlayerPedId()) - market.Location) < 30 then
                    ClosestMarket = market
                end
            end
            Wait(2500)
        end
    end
end)