Helpers = {
    IsBlacklistVehicle = function(model)
        for key, vehicle in pairs(Config.BlacklistVehicles) do
            if vehicle == model then
                return true
            end
        end
        return false
    end,

    GenerateVehicleLabels = function(vehicles)
        for key, vehicle in pairs(vehicles) do
            if Helpers.IsBlacklistVehicle(vehicle.model) then
                table.remove(vehicles, key)
            else
                local displayName = GetDisplayNameFromVehicleModel(vehicle.model)

                if not displayName or displayName == 'CARNOTFOUND' then
                    vehicle.label = vehicle.model
                else
                    vehicle.label = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))
                end
            end
        end
        return vehicles
    end,

    DrawHelpText = function(text)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayHelp(0, false, true, -1)
    end,

    -- Create the blips for the marketplaces
    CreateBlips = function()
        for key, market in pairs(Config.Marketplaces) do
            local blip = AddBlipForCoord(market.Location.x, market.Location.y, market.Location.z)
            SetBlipSprite(blip, market.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, market.Blip.Scale)
            SetBlipColour(blip, market.Blip.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(market.Blip.Label)
            EndTextCommandSetBlipName(blip)
        end
    end,

    -- Check if the player has the required job
    JobCheck = function(job)
        if type(job) == 'table' then
            return job[PlayerData.job.name]
        else
            return PlayerData.job.name == job
        end

        return false
    end,

    AllItems = {
        ["xp"] = true,
        ["gangcoin"] = true,
        ["hottub"] = true,
        ["key_"] = true,
        ["tv"] = true,
        ["casino_chips"] = true,
        ["m_"] = true,
        ["f_"] = true,
    },

    -- Exclude blacklisted items from the items list
    RemoveBlacklistItems = function(blacklistItems, items)
        for key, item in pairs(items) do
            for k, v in pairs(Helpers.AllItems) do
                if blacklistItems[item.name] or item.name:find(k) then
                    table.remove(items, key)
                end
            end
        end

        return items
    end
}