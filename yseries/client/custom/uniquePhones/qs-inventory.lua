CreateThread(function()
    if Config.Item.Inventory ~= "qs-inventory" or not Config.Item.UniquePhones or not Config.Item.Require then
        return
    end

    local ESX, QBCore
    if Config.Framework == "esx" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == "qb" then
        QBCore = exports["qb-core"]:GetCoreObject()
    end

    local function GetItemsByName(name)
        if Config.Framework == "esx" then
            local items = {}
            local inventory = ESX.GetPlayerData().inventory
            for _, item in pairs(inventory) do
                if item?.name == name then
                    items[#items + 1] = item
                end
            end
            return items
        elseif Config.Framework == "qb" then
            local items = {}
            local inventory = QBCore.Functions.GetPlayerData().items
            for _, item in pairs(inventory) do
                if item?.name == name then
                    items[#items + 1] = item
                end
            end
            return items
        end
    end

    function HasImeiIdentifier(imei)
        for _, itemName in ipairs(Config.UseableItems) do
            local phones = GetItemsByName(itemName) -- Retrieve items by each name in the useable items list.
            for i = 1, #phones do
                local phone = phones[i]
                if phone and phone.info and phone.info.imei == imei then
                    return true -- Return true if any phone matches the IMEI.
                end
            end
        end

        return false -- Return false if no matching IMEI is found.
    end

    function GetImeiFromItem(item)
        return item?.info?.imei
    end

    RegisterNetEvent("yseries:use-phone-item", function(phoneItem)
        local active = SetupPhone(phoneItem)

        if active then
            ToggleOpen(true)
        end
    end)

    RegisterNetEvent('yseries:phone-item-added', function()
        debugPrint('Phone item added')
    end)

    RegisterNetEvent('yseries:phone-item-removed', function()
        Wait(500)

        if Config.Item.UniquePhones and CurrentPhoneImei and not HasImeiIdentifier(CurrentPhoneImei) then
            PhoneDropped()

            local _phoneImei = CurrentPhoneImei

            RemovePrimaryPhone(PlayerData.identifier, CurrentPhoneImei)

            if not HasPrimaryPhone then
                debugPrint('Removed primary phone item with imei: ' .. _phoneImei)
            else
                debugPrint('Could not remove primary phone item with imei: ' .. _phoneImei)
            end
        end
    end)
end)
