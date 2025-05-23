CreateThread(function()
    if Config.Garages ~= 'qb-garages' or (Config.Framework ~= 'qb' and Config.Framework ~= 'qbox') then return end

    debugPrint("Using qb-garages")

    function GetVehicleLabel(model)
        local vehicleLabel = GetDisplayNameFromVehicleModel(model):lower()

        if not vehicleLabel or vehicleLabel == 'null' or vehicleLabel == 'carnotfound' then
            vehicleLabel = 'Unknown'
        else
            local text = GetLabelText(vehicleLabel)
            if text and text:lower() ~= 'null' then
                vehicleLabel = text
            end
        end
        return vehicleLabel
    end

    function FindVehicleByPlate(plate)
        local vehicles = GetGamePool('CVehicle')
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            if DoesEntityExist(vehicle) and GetVehicleNumberPlateText(vehicle):gsub('%s+', '') == plate:gsub('%s+', '') then
                return GetEntityCoords(vehicle)
            end
        end

        return lib.callback.await('yseries:server:garage:find-vehicle-by-plate', false, plate)
    end

    function MapVehiclesData(vehicles)
        if vehicles then
            for i = 1, #vehicles do
                vehicles[i].model = GetVehicleLabel(vehicles[i].model)
            end
        end

        return vehicles
    end
end)
