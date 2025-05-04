CreateThread(function()
    if Config.Item.Inventory ~= "ox_inventory" or not Config.Item.UniquePhones or not Config.Item.Require then
        return
    end

    exports.ox_inventory:displayMetadata({
        imei = "IMEI",
    })

    function HasImeiIdentifier(imei)
        for _, itemName in ipairs(Config.UseableItems) do
            local phones = exports.ox_inventory:Search("slots", itemName)

            for i = 1, #phones do
                local phone = phones[i]
                if phone and phone.metadata and phone.metadata.imei == imei then
                    return true
                end
            end
        end

        return false
    end

    function GetImeiFromItem(item)
        for _, itemName in ipairs(Config.UseableItems) do
            local phones = exports.ox_inventory:Search("slots", itemName)

            for i = 1, #phones do
                local phone = phones[i]
                if phone and phone.slot == item.slot then
                    return phone.metadata and phone.metadata.imei or nil
                end
            end
        end

        return nil
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
