CreateThread(function()
    if Config.Housing ~= 'nolag_properties' then return end

    debugPrint("Using nolag_properties")

    function MapHomes(homes)
        return homes
    end

    function MapKeyHolders(keys)
        return keys
    end
end)
